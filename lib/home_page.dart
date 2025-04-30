import 'package:flutter/material.dart';
import 'package:sql/edit_notes.dart';
import 'package:sql/sqldb.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List noteList = [];
  Sqldb sqldb = Sqldb();
  bool isLoading = true;

  Future<void> readData() async {
    List<Map> response = await sqldb.readData("SELECT * from 'notes'");
    setState(() {
      noteList.addAll(response);
      isLoading = false;
    });
  }

  Future<void> myDeleteDataBase() async {
    setState(() {
      noteList.clear();
      isLoading = true;
    });
    await readData();
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
        title: const Text('Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('addnotes');
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: MaterialButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: () async {
                      await myDeleteDataBase();
                    },
                    child: const Text('Delete All Notes'),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: noteList.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                          title: Text('${noteList[i]['note']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (noteList[i]['title'] != null)
                                Text('Title: ${noteList[i]['title']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  int response = await sqldb.deleteData(
                                      'DELETE FROM notes WHERE id = ${noteList[i]['id']}');
                                  if (response > 0) {
                                    setState(() {
                                      noteList.removeAt(i);
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditNote(
                                        note: noteList[i]['note'],
                                        title: noteList[i]['title'],
                                        color: noteList[i]['color'],
                                        id: noteList[i]['id'],
                                      )));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          )),
                    );
                  },
                ),
              ],
            ),
    );
  }
}