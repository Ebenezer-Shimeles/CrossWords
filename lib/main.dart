import 'package:crossword/pages/levels_page.dart';
import 'package:flutter/material.dart';

import 'pages/game_page.dart';
import 'pages/won_page.dart';
import 'services/db.dart';

import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DbService db = DbService();
  await db.init();
  await db.regTable("general");
  if (!await db.contains("general", "start", Object())) {
    db.write("general", "start", "y", Object());
    db.write("general", "cur_level", 1, Object());
  }
  runApp(Provider<DbService>.value(
    child: MyApp(),
    value: db,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AudioPlayer>(
      create: (_) => AudioPlayer(),
      child: MaterialApp(
        title: 'Ethio CrossWord',
        theme: ThemeData(
          primaryColor: Colors.amber[200],
        ),
        routes: {
          '/game': (_) => GamePage(),
          '/': (_) => LevelsPage(),
          '/won': (_) => WonPage()
        },
      ),
    );
  }
}

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/game':
      return MaterialPageRoute(builder: (_) => GamePage());
    case '/won':
      return MaterialPageRoute(builder: (_) => WonPage());
    case '/':
      return MaterialPageRoute(builder: (_) => LevelsPage());
    default:
      return MaterialPageRoute(builder: (_) => Scaffold(body: Text("Error")));
  }
}
