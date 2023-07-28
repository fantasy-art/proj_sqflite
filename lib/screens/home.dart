import 'package:flutter/material.dart';
import 'package:proj_sqflite/db/sqldb.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqldb = SqlDb();
  bool isLoading = true;

  List notes = [];
  Future readData() async {
    //List<Map> response = await sqldb.readData('SELECT * From Notes');
    List<Map> response = await sqldb.read('Notes');
    notes.addAll(response);
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
      ),
      body: SafeArea(
          child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              color: Colors.indigo,
              width: double.infinity,
              height: 50,
              alignment: Alignment.topCenter,
              child: const Text('My Notes',
                  style: TextStyle(fontSize: 26, color: Colors.white))),
          const SizedBox(height: 10),
          Expanded(
            child: notes.isNotEmpty
                ? isLoading == false
                    ? ListView(children: [
                        ListView.builder(
                          itemCount: notes.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).canvasColor,
                                child: Text((index + 1).toString()),
                              ),
                              title: Text(notes[index]['Title'].toString()),
                              subtitle: Text(notes[index]['Note'].toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'EditNote',
                                          arguments: {
                                            'id': notes[index]['id'],
                                            'Title': notes[index]['Title'],
                                            'Note': notes[index]['Note'],
                                            'Color': notes[index]['Color'],
                                          });
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      // int response = await sqldb.deleteData(
                                      //     "DELETE FROM Notes WHERE id=${notes[index]['id']}");
                                      int response = await sqldb.delete(
                                          'Notes', 'id=${notes[index]['id']}');
                                      if (response > 0) {
                                        notes.removeWhere((element) =>
                                            element['id'] ==
                                            notes[index]['id']);
                                        setState(() {});
                                      }
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ])
                    : const Center(child: Text('Loading ...'))
                : const Center(child: Text('No Data Yet')),
          )
        ]),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'AddNote');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
