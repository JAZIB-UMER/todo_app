import 'package:flutter/material.dart';
import 'package:untitled/sqflite_asif/db_handler.dart';
import 'package:untitled/sqflite_asif/notes.dart';

class SqfliteHome extends StatefulWidget {
  const SqfliteHome({super.key});

  @override
  State<SqfliteHome> createState() => _SqfliteHomeState();
}

class _SqfliteHomeState extends State<SqfliteHome> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "TODO",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    setState(() {
                      dbHelper!
                          .insert(NotesModel(
                              title: controller.text.toString() == ''
                                  ? 'Empty'
                                  : controller.text.toString(),
                              age: 20,
                              description: 'This is my first sql app',
                              email: 'jazibumer@gamil.com'))
                          .then((value) {})
                          .onError((error, stackTrace) {});
                      controller.text = '';
                      loadData();
                    });
                  },
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: 'Task...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              )),
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              dbHelper!.update(NotesModel(
                                  id: snapshot.data![index].id!,
                                  title: controller.text,
                                  age: 21,
                                  description: 'New Description',
                                  email: 'xyz@'));

                              setState(() {
                                controller.text = '';
                                notesList = dbHelper!.getNotesList();
                              });
                            },
                            child: Dismissible(
                              key: ValueKey<int>(snapshot.data![index].id!),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete_forever),
                              ),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  dbHelper!.delete(snapshot.data![index].id!);
                                  notesList = dbHelper!.getNotesList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                });
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                        snapshot.data![index].title.toString()),
                                    // subtitle: Text(snapshot
                                    //     .data![index].description
                                    //     .toString()),
                                    trailing: Text('${index + 1}'),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       dbHelper!
      //           .insert(NotesModel(
      //               title: controller.text.toString() == ''
      //                   ? 'Empty'
      //                   : controller.text.toString(),
      //               age: 20,
      //               description: 'This is my first sql app',
      //               email: 'jazibumer@gamil.com'))
      //           .then((value) {})
      //           .onError((error, stackTrace) {});
      //       controller.text = '';
      //       loadData();
      //     });
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
