import 'package:flutter/cupertino.dart';
import 'package:flutter_notes/db/db.dart';

DatabaseHelper db = DatabaseHelper();

// ignore: must_be_immutable
class NotePage extends StatefulWidget {
  final int id;

  const NotePage({
    super.key,
    required this.id,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  var _noteController = TextEditingController();
  var _titleController = TextEditingController();

  var content = "";
  var title = "";
  Future getNote() async {
    var data = await db.getNoteWithId(widget.id);
    setState(() {
      content = data[0]['content'].toString();
      title = data[0]['title'].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getNote();
  }

  @override
  Widget build(BuildContext context) {
    _noteController = TextEditingController(text: content);
    _titleController = TextEditingController(text: title);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            previousPageTitle: "Notes",
            trailing: CupertinoButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (_) => CupertinoActionSheet(
                    title: const Text(
                        "Etes vous sur de vouloir supprimer cette note?"),
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Annuler"),
                      ),
                      CupertinoActionSheetAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          db.deleteNote(widget.id);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Supprimer"),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(
                CupertinoIcons.trash,
                color: Color(0xFFFF5252),
              ),
            )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Column(
              children: [
                Focus(
                  onFocusChange: (focus) {
                    if (!focus) {
                      db.updateNoteTitle(
                        _titleController.text.toString(),
                        widget.id,
                      );
                    }
                  },
                  child: CupertinoTextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    onChanged: (value) {
                      title = _titleController.text.toString();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Focus(
                  onFocusChange: (focus) {
                    if (!focus) {
                      db.updateNoteContent(
                          _noteController.text.toString(), widget.id);
                    }
                  },
                  child: CupertinoTextField(
                    controller: _noteController,
                    minLines: 10,
                    maxLines: 30,
                    onChanged: (value) {
                      content = _noteController.text.toString();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
