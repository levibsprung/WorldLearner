import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/card_result.dart';
import 'package:frontend/user_bar.dart';

import 'app_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.title});
  final String title;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final options = [
    "Computer Science",
    "Issue #45",
    "Issue #46",
    "Some cool issue"
  ];

  String? chosenWord;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            UserBar(),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, widget) => Transform.translate(
                  offset: Offset(0.0, _controller.value * -80.0 - 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: SizedBox()),
                      const Text(
                        'Learn About...',
                        style: TextStyle(
                          fontFamily: "Schyler",
                          fontSize: 50.0,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: 500.0,
                        child: TextField(
                          autofocus: false,
                          onChanged: (str) {
                            if (str.isNotEmpty) {
                              _controller.animateTo(1.0,
                                  curve: Curves.easeInOut);
                            } else {
                              _controller.animateTo(0.0,
                                  curve: Curves.easeInOut);
                            }
                          },
                          style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.grey.shade800,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            contentPadding: const EdgeInsets.only(
                              left: 30.0,
                              bottom: 16.0,
                              top: 29.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7.0),
                      // const ContinueButton(buttonTitle: 'Let\'s go'),
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, widget) {
                            return Opacity(
                                opacity: _controller.value,
                                child: Column(children: [
                                  for (int i = 0; i < 3; i++)
                                    Transform.translate(
                                      offset: Offset(
                                          max(
                                              -_controller.value * 300.0 +
                                                  100.0 * (i + 1),
                                              0),
                                          0.0),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        child: CardResult(),
                                      ),
                                    ),
                                ]));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
