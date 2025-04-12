import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mock Notes Service', () {
    late MockNotesService notesService;
    const userId = 'user123';

    setUp(() {
      notesService = MockNotesService();
    });

    test('Should create a note successfully', () async {
      final note = await notesService.createNote(
        title: 'Test Note',
        content: 'This is a test note',
        ownerId: userId,
      );

      expect(note.title, 'Test Note');
      expect(note.content, 'This is a test note');
      expect(note.ownerId, userId);

      final fetched = notesService.getNoteById(note.id);
      expect(fetched, isNotNull);
      expect(fetched!.id, note.id);
    });

    test('Should fetch all notes for a user', () async {
      await notesService.createNote(
        title: 'First',
        content: 'First content',
        ownerId: userId,
      );
      await notesService.createNote(
        title: 'Second',
        content: 'Second content',
        ownerId: userId,
      );

      final notes = await notesService.getNotesForUser(userId);
      expect(notes.length, 2);
      expect(notes.every((n) => n.ownerId == userId), true);
    });

    test('Should delete a note', () async {
      final note = await notesService.createNote(
        title: 'To be deleted',
        content: 'Goodbye!',
        ownerId: userId,
      );

      await notesService.deleteNote(note.id);
      final fetched = notesService.getNoteById(note.id);
      expect(fetched, isNull);
    });

    test('Should update a note', () async {
      final note = await notesService.createNote(
        title: 'Original Title',
        content: 'Original Content',
        ownerId: userId,
      );

      final updated = await notesService.updateNote(
        id: note.id,
        newTitle: 'Updated Title',
        newContent: 'Updated Content',
      );

      expect(updated, isNotNull);
      expect(updated!.title, 'Updated Title');
      expect(updated.content, 'Updated Content');
      expect(updated.id, note.id);
    });

    test('Deleting a non-existent note should not throw', () async {
      try {
        await notesService.deleteNote('non_existent_id');
        // If it gets here, the test passes because no exception was thrown
        expect(true, isTrue);
      } catch (_) {
        fail('Deleting a non-existent note should not throw an exception');
      }
    });


  });
}


class Note {
  final String id;
  final String title;
  final String content;
  final String ownerId;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.ownerId,
  });
}

class MockNotesService {
  final Map<String, Note> _notes = {};
  int _noteCounter = 0;

  Future<Note> createNote({
    required String title,
    required String content,
    required String ownerId,
  }) async {
    final note = Note(
      id: (_noteCounter++).toString(),
      title: title,
      content: content,
      ownerId: ownerId,
    );
    _notes[note.id] = note;
    return note;
  }

  Future<void> deleteNote(String id) async {
    _notes.remove(id);
  }

  Future<List<Note>> getNotesForUser(String userId) async {
    return _notes.values.where((note) => note.ownerId == userId).toList();
  }

  Future<Note?> updateNote({
    required String id,
    String? newTitle,
    String? newContent,
  }) async {
    final existingNote = _notes[id];
    if (existingNote == null) return null;

    final updatedNote = Note(
      id: existingNote.id,
      title: newTitle ?? existingNote.title,
      content: newContent ?? existingNote.content,
      ownerId: existingNote.ownerId,
    );

    _notes[id] = updatedNote;
    return updatedNote;
  }


  Note? getNoteById(String id) => _notes[id];
}