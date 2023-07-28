import 'package:flutter/material.dart';
import 'package:proj_sqflite/screens/home.dart';
import 'package:proj_sqflite/service/sqldb.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key});

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
  String errorText = '';
  Color? _selectedColor;
  String? part;
  final List<Color> filtersColor = [
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.red,
  ];
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

    //_selectedColor = Color(int.parse(data['Color']));

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
              ],
            ),
            const SizedBox(height: 8),
            Text(errorText),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (title.text.trim().isNotEmpty ||
                      note.text.trim().isNotEmpty ||
                      color.text.trim().isNotEmpty) {
                    // await sqldb.updateData('''UPDATE Notes SET
                    //       Title =   '${title.text}',
                    //       Note =   '${note.text}',
                    //       Color =   '$part'
                    //       WHERE id= $id
                    //        ''');
                    await sqldb.update(
                      'Notes',
                      {
                        'Title': title.text,
                        'Note': note.text,
                        'Color': part,
                      },
                      'id= $id',
                    );
                  } else {
                    setState(() {
                      errorText =
                          'Please Check Title, Note and Color is not empty';
                    });
                  }
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
