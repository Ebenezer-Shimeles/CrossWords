import 'package:flutter/material.dart';

class LvlDesc extends StatelessWidget {
  String level;
  bool isLocked;
  LvlDesc({Key? key, required this.level, this.isLocked = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        isLocked
            ? null
            : Navigator.pushReplacementNamed(context, '/game',
                arguments: level);
        print("lvel: $level");
      },
      child: Container(
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLocked ? Icon(Icons.lock_rounded) : Icon(Icons.play_arrow),
            Center(
              child: Text(
                "${this.level}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
