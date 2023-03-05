import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/course_page.dart';
import 'package:frontend/slide_right_page.dart';

import 'lesson_page.dart';

class CardResult extends StatefulWidget {
  final String title;
  final String subtitle;

  const CardResult({
    super.key,
    required this.title,
    required this.subtitle,
  });

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
            SlideRightRoute(
                page: LessonPage(
              title: 'Pronouns',
              lesson: Lesson(title: 'Pronouns', topics: [
                Topic(
                  title: 'Introduction',
                  body: ['short', 'medium', 'longer', 'long'],
                  questions: [
                    Question('What is 0+2?', ['1', '2', '3', '4'], '2'),
                    Question('What is 2+2?', ['1', '2', '3', '4'], '4')
                  ],
                ),
                Topic(
                  title: 'Specificities',
                  body: ['short', 'medium', 'longer', 'long'],
                  questions: [
                    Question('What is 2+2?', ['1', '2', '3', '4'], '4')
                  ],
                )
              ]),
            )),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(widget.subtitle),
            ],
          ),
        ),
      ),
    );
  }
}
