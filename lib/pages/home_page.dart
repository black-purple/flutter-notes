import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/db/db.dart';
import 'package:flutter_notes/pages/note_page.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _noteTitleController = TextEditingController();
  final _noteContentController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool isList = false;

  Map<int, Color> colors = {
    0: Colors.redAccent,
    1: Colors.lightBlue,
    2: Colors.lightGreenAccent,
    3: Colors.greenAccent,
    4: Colors.blueGrey,
  };

  List<Map> notes = [];
  DatabaseHelper db = DatabaseHelper();

  Future getNotes() async {
    notes = await db.getNotes();
    // isList = await db.getLayout();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    getNotes();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              child: const Icon(CupertinoIcons.add_circled),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: const Text("Ajouter Note"),
                    content: Form(
                      key: _key,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            CupertinoTextFormFieldRow(
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Champ obligatoire";
                                }
                                return null;
                              },
                              placeholder: "Titre note",
                              controller: _noteTitleController,
                            ),
                            CupertinoTextFormFieldRow(
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Champ obligatoire";
                                }
                                return null;
                              },
                              placeholder: "Contenu note",
                              controller: _noteContentController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: const Text("Ajouter"),
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            db.addNote(
                              _noteTitleController.text.trim().toString(),
                              _noteContentController.text.trim().toString(),
                              Random().nextInt(4),
                            );
                            getNotes();
                            setState(() {});
                            _noteTitleController.clear();
                            _noteContentController.clear();
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text("Annuler"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                );
              },
            ),
            CupertinoButton(
              child: Icon(
                isList ? CupertinoIcons.grid : CupertinoIcons.list_bullet,
              ),
              onPressed: () {
                setState(() {
                  isList = !isList;
                  db.layoutSwap(isList);
                });
              },
            ),
          ],
        ),
        backgroundColor: CupertinoColors.systemGrey.withOpacity(0.5),
        middle: const Text('Notes'),
      ),
      child: isList
          ? ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) => SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NotePage(
                          id: notes[index]['id'],
                        ),
                      ),
                    ),
                    child: CupertinoListTile(
                      title: Text(
                        notes[index]['title'],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        notes[index]['content'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      backgroundColor: colors[notes[index]['color']],
                    ),
                  ),
                ),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: notes.length,
              itemBuilder: (_, index) => SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NotePage(
                          id: notes[index]['id'],
                        ),
                      ),
                    ),
                    child: Card(
                      color: colors[notes[index]['color']],
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notes[index]['title'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                notes[index]['content'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
