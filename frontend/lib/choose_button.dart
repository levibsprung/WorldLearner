import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class ChooseButton extends StatelessWidget {
  final String buttonTitle;
  final Function() onPressed;
  final double minWidth;

  const ChooseButton({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    this.minWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonTitle,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(minWidth, 10)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        // backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade200),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        ),
      ),
    );
  }
}
