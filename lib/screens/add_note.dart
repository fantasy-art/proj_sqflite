import 'package:flutter/material.dart';
import 'package:proj_sqflite/screens/home.dart';
import 'package:proj_sqflite/service/sqldb.dart';

import '../service/color.dart';

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
  Color? _selectedColor;
  String? part;

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
            const SizedBox(height: 16),
            TextField(
              controller: note,
              decoration: const InputDecoration(
                  label: Text('Note'), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Choose Color: '),
                Expanded(
                  child: SizedBox(
                    child: Container(
                      foregroundDecoration: BoxDecoration(
                          border: Border.all(color: Colors.black54)),
                      height: 30,
                      color: _selectedColor,
                      child: DropdownButton(
                        iconSize: 0,
                        underline: const SizedBox(),
                        alignment: Alignment.centerRight,
                        value: _selectedColor,
                        items: filtersColor
                            .map(
                              (colorItem) => DropdownMenuItem(
                                value: colorItem,
                                child: Container(
                                  color: colorItem,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              part = value.toString().substring(35, 45);
                              _selectedColor = value;
                            });
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(errorText),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (title.text.trim().isNotEmpty ||
                      note.text.trim().isNotEmpty ||
                      _selectedColor != null) {
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
                      'Color': part,
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
