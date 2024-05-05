import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'package:noteapp/note_model.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  Client client = http.Client();
  List<String> notes = [];
  List<Note> notesList = [];

  @override
  void initState() {
    _retrieveNotes();
    super.initState();
  }

  _retrieveNotes() async {
    Uri url = Uri.parse('https://60nczx0w-8080.inc1.devtunnels.ms/api/');
    print((await client.get(url)).body);
    List response = json.decode((await client.get(url)).body);
    notesList = response.map((e) => Note.fromJson(e)).toList();
    setState(() {});
  }

  _deleteNote(int id) async {
    print(id);
    Uri url =
        Uri.parse('https://60nczx0w-8080.inc1.devtunnels.ms/api/$id/delete/');
    var response = await client.delete(url);
    print(response.statusCode);
    _retrieveNotes();
  }

  _updateNote(int id, String note) async {
    Uri url =
        Uri.parse('https://60nczx0w-8080.inc1.devtunnels.ms/api/$id/update/');
    await client.put(url, body: {'note': note});
    _retrieveNotes();
  }

  _createNote(String note) async {
    Uri url = Uri.parse('https://60nczx0w-8080.inc1.devtunnels.ms/api/');
    await client.post(url, body: {'note': note});
    _retrieveNotes();
  }

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _retrieveNotes();
        },
        child: Column(
          children: [
            Expanded(
              child: NoteList(
                notesList: notesList,
                onDelete: (index) {
                  setState(() {
                    _deleteNote(notesList[index].id);
                  });
                },
                onEdit: (index, newText) {
                  setState(() {
                    _updateNote(notesList[index].id, newText);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your note',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final newNote = _textController.text.trim();
                        if (newNote.isNotEmpty) {
                          _createNote(_textController.text.trim());
                          _retrieveNotes();
                          _textController.clear();
                        }
                      });
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class NoteList extends StatelessWidget {
  final List<Note> notesList;
  final Function(int) onDelete;
  final Function(int, String) onEdit;

  const NoteList({
    super.key,
    required this.notesList,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notesList[index].note ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editNoteDialog(context, index, notesList[index].note ?? '');
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onDelete(index);
                },
              ),
            ],
          ),
          onTap: () {
            // Add action to view/edit the note
          },
        );
      },
    );
  }

  void _editNoteDialog(BuildContext context, int index, String currentNote) {
    TextEditingController _editingController =
        TextEditingController(text: currentNote);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: TextField(
            controller: _editingController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final editedNote = _editingController.text.trim();
                if (editedNote.isNotEmpty) {
                  onEdit(index, editedNote);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
