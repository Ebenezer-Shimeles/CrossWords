import 'package:crossword/bloc/cwordbloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/events/cword_event.dart';

class Box extends StatelessWidget {
  bool isBorder;
  late String? letter;
  bool _showLetter = false;
  Box({Key? key, this.letter, this.isBorder = false}) : super(key: key);
  show() {
    this._showLetter = true;
  }

  @override
  Widget build(BuildContext context) {
    final widthMax = MediaQuery.of(context).size.width;
    final heightMax = MediaQuery.of(context).size.height;
    return BlocBuilder<CWordBloc, String>(builder: (context, state) {
      return Card(
        //elevation: 10.00,
        child: Container(
          padding: EdgeInsets.all(10),
          //duration: Duration(seconds: 1),
          width: widthMax,
          height: heightMax,
          child: letter != null && _showLetter
              ? Center(
                  child: Text(
                  letter!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
              : null,
          decoration: isBorder
              ? BoxDecoration(border: Border.all(color: Colors.black))
              : null,
        ),
      );
    });
  }
}
