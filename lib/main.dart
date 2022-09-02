import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:noteyyy/db/notes_database.dart';
import 'package:noteyyy/screens/new_note.dart';
import 'package:noteyyy/screens/note_deatils.dart';
import 'model/note_model.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[300],
       // primarySwatch: Colors.blue,
      ),
      home: const HomePage()
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

   super.dispose();
  }

   Future refreshNotes() async{
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.raedAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        title: const Text('Notes',style: TextStyle(color: Colors.black87),),
      ),
      body: Center(
        child: isLoading
        ? const CircularProgressIndicator(color:Colors.black87,)
        : notes.isEmpty
        ? const Text('No Notes',)
        : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.add,color: Colors.black87,),
        onPressed: () async{
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  const AddNewNotePage() ),
          );
          refreshNotes();
        },
      ),
    );
  }
  Widget buildNotes() {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index){
          final note = notes[index];
          final time = DateFormat.yMMMd().format(note.createdTime);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(40),
                boxShadow:[
                  BoxShadow(
                    color: Colors.grey[600]!,
                    offset: const Offset(4, 4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4,-4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(time),
                leading: IconButton(
                  icon: Icon(
                      Icons.edit,
                    color: Colors.grey[700],
                  ),
                  onPressed: () async{
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)
                        => NoteDetailPage(noteId: note.id!,)
                        )
                    );
                    refreshNotes();
                  },
                ),
                trailing: IconButton(
            icon:  Icon(
                Icons.delete,
              color: Colors.grey[700],
            ),
            onPressed: () async{
              //delete note
              await NotesDatabase.instance.delete(note.id!);
              refreshNotes();
            },

        ),
              ),
            ),
          );
        });

  }
}
