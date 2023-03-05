import 'package:flutter/material.dart';
import 'package:frontend/choose_button.dart';
import 'package:frontend/realm/app_services.dart';
import 'package:provider/provider.dart';

class Question extends StatefulWidget {
  final String question;
  final List<String> answers;
  final String correctAnswer;

  const Question({
    super.key,
    required this.question,
    required this.correctAnswer,
    required this.answers,
  });

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> with TickerProviderStateMixin {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.question,
              style: const TextStyle(
                fontFamily: "Schyler",
                fontSize: 50.0,
              ),
            ),
            for (final answer in widget.answers)
              Column(
                children: [
                  const SizedBox(height: 25.0),
                  // Text(answer),
                  ChooseButton(
                    minWidth: 300,
                    buttonTitle: answer,
                    onPressed: () {},
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
