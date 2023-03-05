import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/choose_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'I am a',
              style: TextStyle(
                fontFamily: "Schyler",
                fontSize: 50.0,
              ),
            ),
            const SizedBox(height: 30.0),
            ChooseButton(
              buttonTitle: "Student",
              onPressed: () {},
            ),
            const SizedBox(height: 20.0),
            ChooseButton(
              buttonTitle: "Teacher",
              onPressed: () {},
            ),
            // const ContinueButton(buttonTitle: 'Let\'s go'),
          ],
        ),
      ),
    );
  }
}
