import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/app_button.dart';
import 'package:frontend/card_result.dart';
import 'package:frontend/question.dart';
import 'package:frontend/user_bar.dart';

import 'choose_button.dart';

class Question {
  final String question;
  final List<String> answers;
  final String correctAnswer;

  Question(this.question, this.answers, this.correctAnswer);
}

class Topic {
  final String title;
  final List<String> body;
  final List<Question> questions;

  Topic({
    required this.title,
    required this.body,
    required this.questions,
  });
}

class Lesson {
  final String title;
  final List<Topic> topics;

  Lesson({
    required this.title,
    required this.topics,
  });
}

class LessonPage extends StatefulWidget {
  final String title;
  final Lesson lesson;

  const LessonPage({
    super.key,
    required this.title,
    required this.lesson,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> with TickerProviderStateMixin {
  late PageController _pageCtrl;
  int page = 0;
  bool quizMode = false;

  final List<int> levels = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.lesson.topics.length; i++) {
      levels.add(0);
    }

    _pageCtrl = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            UserBar(),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                allowImplicitScrolling: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(fontSize: 40.0, fontFamily: 'Schyler'),
                      ),
                      const SizedBox(height: 20.0),
                      for (int i = 0; i < widget.lesson.topics.length; i++)
                        Column(
                          children: [
                            TextButton(
                              child: Text(
                                '${i + 1}. ${widget.lesson.topics[i].title}',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontFamily: 'Schyler',
                                ),
                              ),
                              onPressed: () {
                                _pageCtrl.animateToPage(
                                  i + 1,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                                setState(() => page = 1);
                              },
                            ),
                            SizedBox(height: 30.0),
                          ],
                        ),
                      const SizedBox(height: 40.0),
                      ChooseButton(
                        buttonTitle: 'Start Lesson',
                        onPressed: () {
                          setState(() => page += 1);

                          _pageCtrl.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                      ),
                      SizedBox(height: 20),
                      ChooseButton(
                        buttonTitle: 'Take Quiz',
                        onPressed: () {
                          setState(() {
                            quizMode = true;

                            page += 1;
                          });

                          _pageCtrl.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                  // for (final topic in widget.lesson.topics)
                  for (int i = 0; i < widget.lesson.topics.length; i++)
                    Column(children: [
                      TopicPage(
                        pageCtrl: _pageCtrl,
                        topic: widget.lesson.topics[i],
                        quizMode: quizMode,
                        exitQuizMode: (correctness) {
                          print('called');
                          if (correctness > 0.8) {
                            this.levels[i] = 0;
                          } else if (correctness > 0.5) {
                            this.levels[i] = 1;
                          } else if (correctness > 0.3) {
                            this.levels[i] = 2;
                          } else {
                            this.levels[i] = 3;
                          }

                          if (i == this.levels.length - 1) {
                            this.setState(() {
                              quizMode = false;
                              page = 0;
                              _pageCtrl.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            });

                            print(this.levels);
                          } else {
                            page += 1;
                            _pageCtrl.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }

                          setState(() {});
                        },
                        level: this.levels[i],
                      ),
                    ])
                ],
              ),
            ),
            if (page != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChooseButton(
                    buttonTitle: 'Previous Topic',
                    onPressed: () {
                      _pageCtrl.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      setState(() {
                        page -= 1;
                      });
                    },
                  ),
                  SizedBox(width: 40.0),
                  if (page != widget.lesson.topics.length)
                    ChooseButton(
                      buttonTitle: 'Next Topic',
                      onPressed: () {
                        _pageCtrl.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                        setState(() {
                          page += 1;
                        });
                      },
                    ),
                ],
              ),
            SizedBox(height: 40.0)
          ],
        ),
      ),
    );
  }
}

class TopicPage extends StatefulWidget {
  final PageController pageCtrl;
  final bool quizMode;
  final Topic topic;
  final Function(double correctness) exitQuizMode;
  final int level;

  const TopicPage({
    super.key,
    required this.pageCtrl,
    required this.topic,
    required this.quizMode,
    required this.exitQuizMode,
    required this.level,
  });

  @override
  State<TopicPage> createState() => _TopicState();
}

class _TopicState extends State<TopicPage> {
  // bool quizMode = false;
  List<bool> corrects = [];

  int i = 0;

  @override
  void initState() {
    for (int i = 0; i < widget.topic.questions.length; i++) {
      corrects.add(false);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.quizMode) {
      i = 0;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.topic.title,
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'Grafana',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.topic.body[widget.level]),
            SizedBox(height: 30.0),
            TextButton(
              onPressed: () {},
              child: Text("Take Quiz"),
            ),
            SizedBox(height: 30.0),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 570.0,
        width: 700.0,
        child: Column(
          children: [
            Text(
              widget.topic.title,
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'Grafana',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30.0),
            QuestionWidget(
              question: widget.topic.questions[i].question,
              correctAnswer: widget.topic.questions[i].correctAnswer,
              answers: widget.topic.questions[i].answers,
              submit: (bool correct) {
                this.corrects[i] = correct;
                setState(() {
                  i += 1;
                });

                double o = 0.0;
                for (final item in this.corrects) {
                  if (item) o += 1.0;
                }

                if (i > this.corrects.length - 1) {
                  print("exit");
                  i -= 1;
                  print(o / this.corrects.length);
                  widget.exitQuizMode(o / this.corrects.length);
                }

                // if (i > this.corrects.length - 1) {

                //   }
              },
            )
          ],
        ),
      );
    }
  }
}
