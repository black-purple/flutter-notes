import 'package:flutter/material.dart';
import 'package:flutter_notes/pages/note_page.dart';

class NotesGrid extends StatelessWidget {
  final List notes;
  const NotesGrid({
    super.key,
    required this.notes,
  });
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
              color: Colors.blueGrey[100],
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      notes[index]['content'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
