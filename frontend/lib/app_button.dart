import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ContinueButton extends StatelessWidget {
  final String buttonTitle;

  const ContinueButton({super.key, required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Continue",
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Icon(FeatherIcons.arrowRight)
        ],
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        ),
      ),
    );
  }
}
