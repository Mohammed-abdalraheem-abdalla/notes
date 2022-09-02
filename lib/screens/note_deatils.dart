import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/notes_database.dart';
import '../model/note_model.dart';
import 'new_note.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;
  const NoteDetailPage({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    getNoteDetails();

    super.initState();
  }

  Future getNoteDetails() async{
    setState(() => isLoading = true);

    note = (await NotesDatabase.instance.readNote(widget.noteId))!;

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        iconTheme:  const IconThemeData(
            color: Colors.black ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[900],
        child: const Icon(Icons.edit,color: Colors.white,),
        onPressed: () async{
          if (isLoading) return;

          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddNewNotePage(note: note),
          ));

          getNoteDetails();
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300]!,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade600,
                offset: const Offset(5,5),
                blurRadius: 15,
              ),
              BoxShadow(
                color: Colors.grey.shade600,
                offset: const Offset(-5,-5),
                blurRadius: 15,
              ),
            ]
          ),
          // color: Colors.red,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
            children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              const SizedBox(height: 8),
              Text(
                DateFormat.yMMMd().format(note.createdTime),
                style: TextStyle(color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Text(
                note.description,
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
