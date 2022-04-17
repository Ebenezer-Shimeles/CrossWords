import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WonPage extends StatelessWidget {
  const WonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: Icon(Icons.backpack))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text("WON!"),
            )
          ],
        ),
      ),
    );
  }
}
