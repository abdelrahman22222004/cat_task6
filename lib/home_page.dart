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
    await sqldb.deleteData("DELETE FROM notes");
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
        title: const Text('ملاحظاتي', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              await myDeleteDataBase();
            },
            tooltip: 'حذف الكل',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('addnotes');
        },
        child: const Icon(Icons.add, size: 28),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : noteList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_add, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد ملاحظات بعد',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'انقر على زر + لإنشاء ملاحظة جديدة',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: noteList.length,
                  itemBuilder: (context, i) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNote(
                                    note: noteList[i]['note'],
                                    title: noteList[i]['title'],
                                    brief: noteList[i]['brief'],
                                    id: noteList[i]['id'],
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (noteList[i]['title'] != null &&
                                  noteList[i]['title'].toString().isNotEmpty)
                                Text(
                                  noteList[i]['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),)                                ),
                              const SizedBox(height: 8),
                              Text(
                                noteList[i]['note'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              if (noteList[i]['brief'] != null &&
                                  noteList[i]['brief'].toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    noteList[i]['brief'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          size: 20, color: Color(0xFF666666)),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => EditNote(
                                                      note: noteList[i]['note'],
                                                      title: noteList[i]
                                                          ['title'],
                                                      brief: noteList[i]
                                                          ['brief'],
                                                      id: noteList[i]['id'],
                                                    )));
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          size: 20, color: Colors.red),
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('حذف الملاحظة'),
                                            content: const Text(
                                                'هل أنت متأكد من حذف هذه الملاحظة؟'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('إلغاء'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  int response =
                                                      await sqldb.deleteData(
                                                          'DELETE FROM notes WHERE id = ${noteList[i]['id']}');
                                                  if (response > 0) {
                                                    setState(() {
                                                      noteList.removeAt(i);
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('حذف',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}