import 'package:flutter/material.dart';
import 'package:sql/home_Page.dart';
import 'package:sql/sqldb.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _MyWidgetState();
}

Sqldb sqldb = Sqldb();
GlobalKey<FormState> formstate = GlobalKey();
TextEditingController note = TextEditingController();
TextEditingController title = TextEditingController();
TextEditingController color = TextEditingController();

class _MyWidgetState extends State<AddNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Form(
              child: Column(
                key: formstate,
                children: [
                  TextFormField(
                    controller: note,
                    decoration: const InputDecoration(hintText: 'note'),
                  ),
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(hintText: 'title'),
                  ),
                  TextFormField(
                    controller: color,
                    decoration: const InputDecoration(hintText: 'color'),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 30,
                    child: MaterialButton(
                      onPressed: () async {
                        int response = await sqldb.insertData(
                            '''INSERT INTO notes (note , title , color)
                        VALUES ("${note.text}","${title.text}","${color.text}")
                        ''');
                        if (response > 0) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false);
                        }
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: const Text('Add Note'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
