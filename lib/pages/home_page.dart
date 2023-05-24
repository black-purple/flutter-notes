import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_ios/db/db.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _noteController = TextEditingController();
  final _key = GlobalKey<FormState>();

  List<Map> notes = [];
  DatabaseHelper db = DatabaseHelper();

  Future getNotes() async {
    notes = await db.getNotes();
  }

  @override
  void initState() {
    super.initState();
    getNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                title: const Text("Ajouter Note"),
                content: Form(
                  key: _key,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: CupertinoTextFormFieldRow(
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Champ obligatoire";
                        }
                        return null;
                      },
                      placeholder: "Ecrirre une note",
                      controller: _noteController,
                    ),
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text("Ajouter"),
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        db.addNote(_noteController.text.trim().toString());
                        getNotes();
                        setState(() {});
                        _noteController.clear();
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
        backgroundColor: Colors.amber,
        middle: const Text('Notes'),
      ),
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (_, index) => SizedBox(
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.only(bottom: 2),
            child: Slidable(
              endActionPane: ActionPane(
                extentRatio: 0.25,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      db.deleteNote(notes[index]['id']);
                      setState(() {});
                    },
                    autoClose: true,
                    icon: CupertinoIcons.delete,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  )
                ],
              ),
              child: Card(
                margin: EdgeInsets.zero,
                child: CupertinoListTile(
                  backgroundColor: Colors.grey[300],
                  title: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(notes[index]['content']),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
