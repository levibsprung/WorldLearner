import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/login_page.dart';
import 'package:frontend/question.dart';
import 'package:frontend/realm/app_services.dart';
import 'package:frontend/realm/realm_services.dart';
import 'package:frontend/search_page.dart';
import 'package:frontend/welcome_page.dart';
import 'package:provider/provider.dart';

import 'lesson_page.dart';

// void main() {
//   runApp(const LearnerApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final realmConfig = json
      .decode(await rootBundle.loadString('assets/config/atlasConfig.json'));
  String appId = realmConfig['appId'];
  Uri baseUrl = Uri.parse(realmConfig['baseUrl']);

  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppServices>(
          create: (_) => AppServices(appId, baseUrl)),
      ChangeNotifierProxyProvider<AppServices, RealmServices?>(
          // RealmServices can only be initialized only if the user is logged in.
          create: (context) => null,
          update: (BuildContext context, AppServices appServices,
              RealmServices? realmServices) {
            return appServices.app.currentUser != null
                ? RealmServices(appServices.app)
                : null;
          }),
    ],
    child: const LearnerApp(),
  ));
}

class LearnerApp extends StatelessWidget {
  const LearnerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<RealmServices?>(context, listen: false)?.currentUser;

    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        title: 'World Learner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == "/") {
            return PageRouteBuilder(
              settings:
                  settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
              pageBuilder: (_, __, ___) => SearchPage(title: "a"),
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) =>
                  SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          }
          // Unknown route
          return MaterialPageRoute(builder: (_) => const LoginPage(title: 'a'));
        },
        initialRoute: currentUser != null ? '/' : '/login',
      ),
    );
  }
}
