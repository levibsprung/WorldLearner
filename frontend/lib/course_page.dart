import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bob")),
      body: TextButton(
        child: Text("Bob"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
