import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/pages/note_page.dart';

class NotesList extends StatelessWidget {
  final List notes;
  NotesList({
    super.key,
    required this.notes,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              backgroundColor: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
