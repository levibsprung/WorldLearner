import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/app_button.dart';
import 'package:frontend/card_result.dart';
import 'package:frontend/user_bar.dart';

import 'choose_button.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.title});
  final String title;
  // final

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> with TickerProviderStateMixin {
  late PageController _pageCtrl;
  int page = 0;

  @override
  void initState() {
    super.initState();

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
                      TextButton(
                        child: Text(
                          '1. The Congo',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Schyler',
                          ),
                        ),
                        onPressed: () {
                          _pageCtrl.animateToPage(
                            1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                          setState(() => page = 1);
                        },
                      ),
                      SizedBox(height: 30.0),
                      TextButton(
                        child: Text(
                          '2. Independence',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Schyler',
                          ),
                        ),
                        onPressed: () {
                          _pageCtrl.animateToPage(
                            2,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                          setState(() => page = 2);
                        },
                      ),
                      SizedBox(height: 30.0),
                      TextButton(
                        child: Text(
                          '3. WWI',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Schyler',
                          ),
                        ),
                        onPressed: () {
                          _pageCtrl.animateToPage(
                            3,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                          setState(() => page = 3);
                        },
                      ),
                      const SizedBox(height: 40.0),
                      ChooseButton(
                        buttonTitle: 'Start Lesson',
                        onPressed: () {
                          setState(() => page += 1);

                          _pageCtrl.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                      ),
                    ],
                  ),
                  Topic(pageCtrl: _pageCtrl),
                  Topic(
                    pageCtrl: _pageCtrl,
                  ),
                  Topic(
                    pageCtrl: _pageCtrl,
                  ),
                  Topic(
                    pageCtrl: _pageCtrl,
                  ),
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

class Topic extends StatefulWidget {
  final PageController pageCtrl;
  // final bool quizMode;

  const Topic({
    super.key,
    required this.pageCtrl,
    // required this.quizMode,
  });

  @override
  State<Topic> createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  bool quizMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          const Text(
            'The Congo',
            style: TextStyle(
              fontSize: 30.0,
              fontFamily: 'Grafana',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Bacon ipsum dolor amet laborum ham hock est buffalo tail. Occaecat ground round laborum tempor flank rump tongue dolore velit in ball tip. Labore short loin bresaola, biltong beef ribs pancetta frankfurter velit tempor sausage andouille. T-bone officia sirloin, strip steak consequat id voluptate quis ea elit ipsum dolore ut drumstick. Adipisicing labore elit tri-tip alcatra capicola ad in t-bone andouille exercitation boudin est buffalo.',
          ),
          Text(
            'Bacon ipsum dolor amet laborum ham hock est buffalo tail. Occaecat ground round laborum tempor flank rump tongue dolore velit in ball tip. Labore short loin bresaola, biltong beef ribs pancetta frankfurter velit tempor sausage andouille. T-bone officia sirloin, strip steak consequat id voluptate quis ea elit ipsum dolore ut drumstick. Adipisicing labore elit tri-tip alcatra capicola ad in t-bone andouille exercitation boudin est buffalo.',
          ),
          SizedBox(height: 30.0),
          TextButton(
            onPressed: () {},
            child: Text("Take Quiz"),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
