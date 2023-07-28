import 'package:flutter/material.dart';
import 'package:proj_sqflite/screens/home.dart';
import 'package:proj_sqflite/db/sqldb.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  SqlDb sqldb = SqlDb();
  Future<List<Map>> readData() async {
    List<Map> response = await sqldb.readData('SELECT * From Notes');
    return response;
  }

  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController color = TextEditingController();

  String errorText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                  label: Text('Title'), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: note,
              decoration: const InputDecoration(
                  label: Text('Note'), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: color,
              decoration: const InputDecoration(
                  label: Text('Color'), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Text(errorText),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (title.text.trim().isNotEmpty ||
                      note.text.trim().isNotEmpty ||
                      color.text.trim().isNotEmpty) {
                    /*    await sqldb.insertData('''INSERT INTO Notes 
                        (Title, Note, Color) 
                        VALUES(
                          '${title.text}',
                          '${note.text}',
                          '${color.text}')
                          '''); */
                    await sqldb.insert("Notes", {
                      'Title': title.text,
                      'Note': note.text,
                      'Color': color.text,
                    });

                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                        (route) => false);
                  } else {
                    setState(() {
                      errorText =
                          'Please Check Title, Note and Color is not empty';
                    });
                  }
                },
                child: const Text('Add Note'))
          ],
        ),
      ),
    );
  }
}
