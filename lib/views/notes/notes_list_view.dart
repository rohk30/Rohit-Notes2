
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/cloud_note.dart';
import '../../services/crud/notes_service.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);


class NotesListView extends StatefulWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  _NotesListViewState createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  String searchQuery = "";
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final filteredNotes = widget.notes.where((note) {
      final title = note.text.split('\n').first.toLowerCase();
      return title.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      /*appBar: AppBar(
        title: isSearching
            ? TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search notes...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        )
            : const Text("Search for your Notes here"),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchQuery = "";
              });
            },
          ),
        ],
      ),    */
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            final note = filteredNotes[index];
            final noteLines = note.text.split('\n');
            final title = noteLines.isNotEmpty ? noteLines[0] : '';
            final preview = noteLines.length > 1
                ? noteLines.sublist(1).join(' ').trim().split(' ').take(15).join(' ') + '...'
                : '';

            return GestureDetector(
              onTap: () => widget.onTap(note),
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        preview,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () async {
                            final shouldDelete = await showDeleteDialog(context);
                            if (shouldDelete) {
                              widget.onDeleteNote(note);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
