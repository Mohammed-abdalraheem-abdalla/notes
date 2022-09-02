import 'package:flutter/material.dart';

class NoteComponentWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;

  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteComponentWidget({Key? key,
    this.isImportant,
    this.number,
    this.title,
    this.description,
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Switch(
                value: isImportant ?? false,
                onChanged: onChangedImportant,
              ),
            ),
            titleForm(),
            const SizedBox(height: 5,),
            const Divider(thickness: 0.5,),
            const SizedBox(height: 5,),
            descriptionForm(),
          ],
        ),
      ),
    );
  }
  Widget  titleForm(){
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 24,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (title)
      => title != null && title.isEmpty
          ? 'Title can not be empty': null,
      onChanged: onChangedTitle,
    );
  }

  Widget descriptionForm(){
    return TextFormField(
      maxLines: 9,
      initialValue: description,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 18,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Note details',
        hintStyle: TextStyle(color: Colors.white60),
      ),
      validator: (description)
      => description != null && description.isEmpty
          ? 'description can not be empty': null,
      onChanged: onChangedDescription,
    );
  }
}
