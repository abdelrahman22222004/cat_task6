import 'package:flutter/material.dart';
import 'package:sql/home_Page.dart';
import 'package:sql/sqldb.dart';

class EditNote extends StatefulWidget {
  final dynamic note;
  final dynamic title;
  final dynamic color;
  final dynamic id;

  const EditNote({super.key, this.note, this.title, this.color, this.id});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  Sqldb sqldb = Sqldb();
  GlobalKey<FormState> formstate = GlobalKey();
  late TextEditingController note;
  late TextEditingController title;
  late TextEditingController color;

  @override
  void initState() {
    note = TextEditingController(text: widget.note?.toString() ?? '');
    title = TextEditingController(text: widget.title?.toString() ?? '');
    color = TextEditingController(text: widget.color?.toString() ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Form(
              key: formstate,
              child: Column(
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
                  const SizedBox(height: 50,),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: () async {
                        int response = await sqldb.insertData('''
                          UPDATE notes SET 
                          note = "${note.text}",
                          title = "${title.text}",
                          color = "${color.text}"
                          WHERE id = ${widget.id}
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
                      child: const Text('Edit Note'),
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
