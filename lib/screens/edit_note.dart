import 'package:flutter/material.dart';
import 'package:proj_sqflite/screens/home.dart';
import 'package:proj_sqflite/db/sqldb.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key, required this.title});
  final String title;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  SqlDb sqldb = SqlDb();
  Future<List<Map>> readData() async {
    List<Map> response = await sqldb.readData('SELECT * From Notes');
    return response;
  }

  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController color = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    int id = data["id"];
    title.text = data["Title"];
    note.text = data["Note"];
    color.text = data["Color"];
    print(id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
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
            ElevatedButton(
                onPressed: () async {
                  title.text.trim().isNotEmpty ||
                          note.text.trim().isNotEmpty ||
                          color.text.trim().isNotEmpty
                      ? await sqldb.updateData('''UPDATE Notes SET
                          Title =   '${title.text}',
                          Note =   '${note.text}',
                          Color =   '${color.text}'
                          WHERE id= $id
                           ''')
                      : print('Error');
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                      (route) => false);
                },
                child: const Text('Edit Note'))
          ],
        ),
      ),
    );
  }
}
