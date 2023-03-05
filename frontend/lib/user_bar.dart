import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/realm/app_services.dart';
import 'package:provider/provider.dart';

class UserBar extends StatelessWidget {
  const UserBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border(
              bottom: BorderSide(
                  color: Colors.grey.shade400.withAlpha(100), width: 1.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text("Welcome, [username]"),
          // Icon(FeatherIcons.bell),
          SizedBox(width: 30.0),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
            child: Icon(
              FeatherIcons.bookOpen,
              size: 36.0,
              color: Colors.blueGrey.shade600,
            ),
          ),
          SizedBox(width: 37.0),
          TabButton(buttonTitle: 'Learn', selected: true),
          SizedBox(width: 22.0),
          TabButton(buttonTitle: 'Past Courses', selected: false),
          Expanded(child: SizedBox()),

          SizedBox(width: 20.0),
          GestureDetector(
            onTap: () {
              final appServices =
                  Provider.of<AppServices>(context, listen: false);
              appServices.logOut();
              Navigator.pushNamed(context, '/login');
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200.0),
              child: Image.network(
                "https://randomuser.me/api/portraits/lego/3.jpg",
                width: 50.0,
              ),
            ),
          ),
          SizedBox(width: 50.0, height: 70.0),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String buttonTitle;
  final bool selected;

  const TabButton(
      {super.key, required this.buttonTitle, required this.selected});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        buttonTitle,
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w700,
          color: selected ? Colors.blue : Colors.grey.shade600,
        ),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //     // RoundedRectangleBorder(
        //     //     // borderRadius: BorderRadius.circular(30.0),
        //     //     ),
        //     ),
        // backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade200),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
      ),
    );
  }
}
