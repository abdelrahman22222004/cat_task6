import 'package:flutter/material.dart';
import 'package:sql/home_Page.dart';
import 'package:sql/sqldb.dart';

class EditNote extends StatefulWidget {
  final dynamic note;
  final dynamic title;
  final dynamic brief;
  final dynamic id;

  const EditNote({super.key, this.note, this.title, this.brief, this.id});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  Sqldb sqldb = Sqldb();
  GlobalKey<FormState> formstate = GlobalKey();
  late TextEditingController note;
  late TextEditingController title;
  late TextEditingController brief;

  @override
  void initState() {
    note = TextEditingController(text: widget.note?.toString() ?? '');
    title = TextEditingController(text: widget.title?.toString() ?? '');
    brief = TextEditingController(text: widget.brief?.toString() ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملاحظة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (note.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الرجاء إدخال الملاحظة'),
                  ),
                );
                return;
              }

              int response = await sqldb.insertData('''
                UPDATE notes SET 
                note = "${note.text}",
                title = "${title.text}",
                brief = "${brief.text}"
                WHERE id = ${widget.id}
              ''');
              if (response > 0) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formstate,
          child: Column(
            children: [
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: note,
                decoration: InputDecoration(
                  labelText: 'الملاحظة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                maxLines: 3,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: brief,
                decoration: InputDecoration(
                  labelText: 'ملاحظات إضافية (اختياري)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                maxLines: 2,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (note.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('الرجاء إدخال الملاحظة'),
                        ),
                      );
                      return;
                    }

                    int response = await sqldb.insertData('''
                      UPDATE notes SET 
                      note = "${note.text}",
                      title = "${title.text}",
                      brief = "${brief.text}"
                      WHERE id = ${widget.id}
                    ''');
                    if (response > 0) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('حفظ التعديلات',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}