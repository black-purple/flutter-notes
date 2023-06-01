import 'package:flutter/cupertino.dart';
import 'package:flutter_notes/db/db.dart';

import 'package:flutter_notes/widgets/notes_grid.dart';
import 'package:flutter_notes/widgets/notes_list.dart';
import 'package:flutter_notes/widgets/picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isList = false;
  bool _isDropdownOpen = false;

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
        trailing: CupertinoButton(
          onPressed: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.ellipsis_circle_fill),
        ),
        backgroundColor: CupertinoColors.systemGrey.withOpacity(0.5),
        middle: const Text('Notes'),
      ),
      child: Stack(
        children: [
          isList ? NotesList(notes: notes) : NotesGrid(notes: notes),
          if (_isDropdownOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDropdownOpen = false;
                });
              },
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.3),
              ),
            ),
          if (_isDropdownOpen)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.13,
              right: 8.0,
              child: SizedBox(
                width: 150.0,
                child: CupertinoPopupSurface(
                  child: Column(
                    children: [
                      CupertinoContextMenuAction(
                        trailingIcon: CupertinoIcons.add_circled,
                        isDefaultAction: true,
                        child: CupertinoButton(
                          onPressed: () {
                            setState(() {
                              _isDropdownOpen = !_isDropdownOpen;
                            });
                            showNewNoteForm();
                          },
                          child: const Text("New"),
                        ),
                      ),
                      CupertinoContextMenuAction(
                        trailingIcon: isList
                            ? CupertinoIcons.square_grid_2x2_fill
                            : CupertinoIcons.list_bullet,
                        child: CupertinoButton(
                          onPressed: () {
                            setState(() {
                              _isDropdownOpen = !_isDropdownOpen;
                            });
                            layoutToggle();
                          },
                          child: const Text("Layout"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
