import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_ios/db/db.dart';
import 'package:test_ios/pages/home_page.dart';

DatabaseHelper db = DatabaseHelper();

class NotePage extends StatelessWidget {
  final int id;
  final String content;
  final String title;
  final int color;

  const NotePage({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          previousPageTitle: title,
          trailing: CupertinoButton(
            onPressed: () {
              db.deleteNote(id);
              Get.offAll(() => const HomePage());
            },
            child: const Icon(
              CupertinoIcons.trash,
              color: Color(0xFFFF5252),
            ),
          )),
      child: Text(
        content,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 25,
        ),
      ),
    );
  }
}
