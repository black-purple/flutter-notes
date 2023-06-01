import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/db/db.dart';
import 'package:flutter_notes/pages/home_page.dart';

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

  var content = "";
  Future getNote() async {
    var data = await db.getNoteWithId(widget.id);
    setState(() {
      content = data[0]['content'].toString();
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              previousPageTitle: "Notes",
              trailing: CupertinoButton(
                onPressed: () {
                  db.deleteNote(widget.id);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
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
              child: Focus(
                onFocusChange: (focus) async {
                  if (!focus) {
                    db.updateNoteContent(
                        _noteController.text.toString(), widget.id);
                  }
                },
                child: CupertinoTextField(
                  minLines: 10,
                  maxLines: 30,
                  onChanged: (value) {
                    content = _noteController.text.toString();
                  },
                  controller: _noteController,
                ),
              ),
            ),
          )),
    );
  }
}
