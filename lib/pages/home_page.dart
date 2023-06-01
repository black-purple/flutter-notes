import 'package:flutter/cupertino.dart';
import 'package:flutter_notes/db/db.dart';
import 'dart:math';

import 'package:flutter_notes/widgets/notes_grid.dart';
import 'package:flutter_notes/widgets/notes_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isList = false;

  List<Map> notes = [];
  DatabaseHelper db = DatabaseHelper();
  final _noteTitleController = TextEditingController();
  final _noteContentController = TextEditingController();
  final _key = GlobalKey<FormState>();

  Future getNotes() async {
    notes = await db.getNotes();
    setState(() {});
  }

  showNewNoteForm() {
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
  }

  layoutToggle() {
    setState(() {
      isList = !isList;
    });
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
        trailing: CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
              child: CupertinoButton(
                onPressed: showNewNoteForm,
                child: const Icon(CupertinoIcons.add_circled),
              ),
            ),
            CupertinoContextMenuAction(
              child: CupertinoButton(
                onPressed: layoutToggle,
                child: Icon(
                  isList ? CupertinoIcons.grid : CupertinoIcons.list_bullet,
                ),
              ),
            ),
          ],
          child: const Icon(CupertinoIcons.dot_square),
        ),
        backgroundColor: CupertinoColors.systemGrey.withOpacity(0.5),
        middle: const Text('Notes'),
      ),
      child: isList ? NotesList(notes: notes) : NotesGrid(notes: notes),
    );
  }
}
