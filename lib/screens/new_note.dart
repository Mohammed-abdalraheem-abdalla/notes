import 'package:flutter/material.dart';
import 'package:noteyyy/db/notes_database.dart';
import '../model/note_model.dart';
import 'new_note_components.dart';

class AddNewNotePage extends StatefulWidget {
  final Note? note;
  const AddNewNotePage({Key? key, this.note}) : super(key: key);

  @override
  State<AddNewNotePage> createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<AddNewNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
   isImportant = widget.note?.isImportant ?? false;
   number = widget.note?.number ?? 0;
   title = widget.note?.title ?? '';
   description = widget.note?.description ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  const IconThemeData(
          color: Colors.black ),
        backgroundColor: Colors.grey[300],
        actions: [
          saveButton(),
        ],
      ),
      body: Form(
        key: _formKey,
        child: NoteComponentWidget(
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,

          onChangedTitle: (title) {
            setState(()
            => this.title = title
            );
          },
          onChangedNumber: (number) {
            setState(()
            => this.number = number
            );
          },
          onChangedDescription: (description) {
            setState(()
            => this.description = description
            );
          },
          onChangedImportant: (isImportant) {
            setState(()
            => this.isImportant = isImportant
            );
          },
        ),
      ),
    );
  }
  Widget saveButton() {
    final isFormValid =
        title.isNotEmpty && description.isNotEmpty;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        primary: isFormValid ? Colors.white : Colors.grey.shade800,
          shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5)
    ),
      ),

        onPressed: (){
        updateOrAddNote();
        },
        child: const Text('Save',
          style: TextStyle(color: Colors.black87),
        ),
    );
  }
  void updateOrAddNote() async {
    final isValid = _formKey.currentState!.validate();

    if(isValid) {
      final isUpdating = widget.note != null;
      if(isUpdating) {
        await updateNote();
      } else {
        await saveNewNote();
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future saveNewNote() async{
    final note = Note(
      title: title,
      isImportant: isImportant,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);

  }

  Future updateNote() async{
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );
    await NotesDatabase.instance.update(note);
  }
}
