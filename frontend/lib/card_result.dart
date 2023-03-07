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
              title: 'Belgium',
              lesson: Lesson(title: 'Belgium', topics: [
                Topic(
                  title: '<Cool Title>',
                  body: [
                    '<short explanation>',
                    '<long explanation>',
                    '<longer explanation>',
                    '<longest explanation>',
                  ],
                  questions: [
                    Question("What is 2+2?", ["4", "1", "90", "4"], "4"),
                    Question(
                        'What is 4+4?',
                        [
                          "8",
                          "40",
                          "r",
                          "90",
                        ],
                        "8")
                  ],
                ),
                Topic(
                  title: 'What Does it Mean?',
                  body: [
                    'Nice! You understand the lesson!',
                    'Nice! You understand the lesson!',
                    'Nice! You understand the lesson!',
                    'Nice! You understand the lesson!'
                  ],
                  questions: [
                    Question(
                      "What is the best programming languge?",
                      ["Pascal", "Ruby", "Rust", "JavaScript"],
                      "Rust",
                    )
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
