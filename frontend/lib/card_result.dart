import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/course_page.dart';
import 'package:frontend/slide_right_page.dart';

class CardResult extends StatefulWidget {
  const CardResult({super.key});

  @override
  State<CardResult> createState() => _CardResultState();
}

class _CardResultState extends State<CardResult> {
  Color color = Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (PointerEvent details) =>
          setState(() => color = Colors.grey.shade400),
      onExit: (PointerEvent details) =>
          setState(() => color = Colors.grey.shade200),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            SlideRightRoute(page: CoursePage()),
          );
        },
        child: AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            // color: Colors.grey.shade200,
            color: color,
          ),
          width: 400.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          duration: const Duration(milliseconds: 80),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Result",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text("SmallResult"),
          ]),
        ),
      ),
    );
  }
}
