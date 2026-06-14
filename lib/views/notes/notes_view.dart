// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rohnewnotes/services/auth/auth_service.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_events.dart';
import 'package:rohnewnotes/services/cloud/cloud_note.dart';
import 'package:rohnewnotes/services/cloud/firebase_cloud_storage.dart';
import 'package:rohnewnotes/views/notes/notes_list_view.dart';
import 'package:rohnewnotes/views/notes/create_update_note_view.dart' hide NotesView;

import '../../constants/routes.dart';
import '../../enums/menu_actions.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../utilities/dialogs/logout_dialog.dart' show showLogOutDialog;

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rohnewnotes/services/auth/auth_service.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_events.dart';
import 'package:rohnewnotes/services/cloud/cloud_note.dart';
import 'package:rohnewnotes/services/cloud/firebase_cloud_storage.dart';
import 'package:rohnewnotes/views/notes/notes_list_view.dart';
import 'package:rohnewnotes/views/notes/create_update_note_view.dart' hide NotesView;

import '../../constants/routes.dart';
import '../../enums/menu_actions.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../utilities/dialogs/logout_dialog.dart' show showLogOutDialog;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Two-pane state: which note is selected in the detail pane
  CloudNote? _selectedNote;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  void _openNote(CloudNote note, bool isWide) {
    if (isWide) {
      setState(() => _selectedNote = note);
    } else {
      Navigator.of(context).pushNamed(createOrUpdateNoteRoute, arguments: note);
    }
  }

  void _createNote(bool isWide) {
    if (isWide) {
      setState(() => _selectedNote = null);
      // Push the editor route — on return it will show the new note in the list automatically
      Navigator.of(context)
          .pushNamed(createOrUpdateNoteRoute)
          .then((_) => setState(() {}));
    } else {
      Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
    }
  }

  Widget _buildNoteList(Iterable<CloudNote> notes, bool isWide) {
    final filtered = _searchQuery.isEmpty
        ? notes
        : notes.where((note) {
            final heading = note.text.trim().split('\n').first.trim().toLowerCase();
            return heading.contains(_searchQuery);
          });

    return NotesListView(
      notes: filtered,
      selectedNote: isWide ? _selectedNote : null,
      onDeleteNote: (note) async {
        await _notesService.deleteNote(documentId: note.documentId);
        if (_selectedNote?.documentId == note.documentId) {
          setState(() => _selectedNote = null);
        }
      },
      onTap: (note) => _openNote(note, isWide),
    );
  }

  AppBar _buildAppBar(bool isWide) {
    return AppBar(
      title: const Text('Your Notes'),
      backgroundColor: Colors.lightBlue,
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          tooltip: _isSearching ? 'Close Search' : 'Search Notes',
          onPressed: _toggleSearchBar,
        ),
        IconButton(
          onPressed: () => _createNote(isWide),
          icon: const Icon(Icons.add),
          tooltip: 'Add Note',
        ),
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            if (value == MenuAction.logout) {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              }
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text('Log out'),
            ),
          ],
        ),
      ],
      bottom: _isSearching
          ? PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search by heading...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      appBar: _buildAppBar(isWide),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<Iterable<CloudNote>>(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final notes = snapshot.data!;

            if (isWide) {
              return Row(
                children: [
                  // Left pane — note list
                  SizedBox(
                    width: 300,
                    child: _buildNoteList(notes, isWide),
                  ),
                  const VerticalDivider(width: 1, color: Colors.white38),
                  // Right pane — editor or placeholder
                  Expanded(
                    child: _selectedNote != null
                        ? CreateUpdateNoteView(
                            key: ValueKey(_selectedNote!.documentId),
                            initialNote: _selectedNote,
                          )
                        : const Center(
                            child: Text(
                              'Select a note to edit,\nor tap + to create one.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ),
                  ),
                ],
              );
            }

            return _buildNoteList(notes, isWide);
          },
        ),
      ),
    );
  }
}


/*
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  String _searchQuery = '';

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _LiveSearchDialog(
          onQueryChanged: (query) {
            setState(() {
              _searchQuery = query.trim().toLowerCase();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Notes',
            onPressed: _openSearchDialog,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Note',
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<Iterable<CloudNote>>(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data!;
                  final filteredNotes = _searchQuery.isEmpty
                      ? allNotes
                      : allNotes.where((note) =>
                      note.text
                          .split('\n')
                          .first
                          .toLowerCase()
                          .contains(_searchQuery));

                  return NotesListView(
                    notes: filteredNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class _LiveSearchDialog extends StatefulWidget {
  final void Function(String query) onQueryChanged;

  const _LiveSearchDialog({required this.onQueryChanged});

  @override
  State<_LiveSearchDialog> createState() => _LiveSearchDialogState();
}

class _LiveSearchDialogState extends State<_LiveSearchDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(() {
      widget.onQueryChanged(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Search Notes'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Type to search...'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onQueryChanged('');
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
} */

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rohnewnotes/services/auth/auth_service.dart';
import 'package:rohnewnotes/services/auth/bloc/auth_events.dart';
import 'package:rohnewnotes/services/cloud/cloud_note.dart';
import 'package:rohnewnotes/services/cloud/firebase_cloud_storage.dart';
import 'package:rohnewnotes/views/notes/notes_list_view.dart';
import 'package:rohnewnotes/views/notes/create_update_note_view.dart' hide NotesView;

import '../../constants/routes.dart';
import '../../enums/menu_actions.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../utilities/dialogs/logout_dialog.dart' show showLogOutDialog;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: _isSearching ? 'Close Search' : 'Search Notes',
            onPressed: _toggleSearchBar,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Note',
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
        bottom: _isSearching
            ? PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by heading...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        )
            : null,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<Iterable<CloudNote>>(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final allNotes = snapshot.data!;

            final filteredNotes = _searchQuery.isEmpty
                ? allNotes
                : allNotes.where((note) {
              final lines = note.text.trim().split('\n');
              final heading = lines.isNotEmpty ? lines.first.trim().toLowerCase() : '';
              return heading.contains(_searchQuery);
            });

            return NotesListView(
              notes: filteredNotes,
              onDeleteNote: (note) async {
                await _notesService.deleteNote(documentId: note.documentId);
              },
              onTap: (note) {
                Navigator.of(context).pushNamed(
                  createOrUpdateNoteRoute,
                  arguments: note,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
  */
