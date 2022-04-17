import 'package:crossword/widgets/letter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:circle_list/circle_list.dart';
import 'package:transparent_pointer/transparent_pointer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

import '../bloc/cwordbloc.dart';
import '../bloc/events/cword_event.dart';
import '../models/word.dart';
import '../widgets/box.dart';
import '../widgets/letter_board.dart';

import 'dart:math'; //kill later

List<Box> _wids = [];
bool areBoxesBuilt = false;
Widget _buildBoxes(List<Word> words, BuildContext context) {
  final _crossAxisNum = 6;
  final _rowNum = 4;
  if (areBoxesBuilt)
    return GridView.count(crossAxisCount: _crossAxisNum, children: _wids);
//_wids;
  areBoxesBuilt = true;

  for (int i = 0; i < _rowNum * _crossAxisNum; i++)
    _wids.add(Box(
      isBorder: false,
    ));
  //return Text("ds");

  words.forEach((Word word) {
    if (word.direction == 'H') {
      for (int i = 0; i < word.spelling.length; i++) {
        _wids[i + word.startPos + word.startCross * _crossAxisNum] = Box(
          letter: word.spelling[i],
          isBorder: true,
        );
      }
    } else if (word.direction == 'V') {
      print("Vertical");
      for (int i = 0; i < word.spelling.length; i++) {
        print("Looping");
        int index =
            i * _crossAxisNum + _crossAxisNum * word.startPos + word.startCross;
        print("index: $index");
        _wids[index] = Box(
          letter: word.spelling[i],
          isBorder: true,
        );
      }
    }
  });
  final cwBloc = Provider.of<CWordBloc>(context, listen: false);
  cwBloc.setBoxes(_wids);
  cwBloc.setContext(context);
  return GridView.count(crossAxisCount: _crossAxisNum, children: _wids);
}

class GamePage extends StatelessWidget {
  late String _level = "01";
  GamePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    print("see" + route!.settings.arguments.toString());
    _level = route!.settings.arguments.toString();
    final _cwBloc = CWordBloc(_level);
    final size = MediaQuery.of(context).size;
    final letterBoard = new LetterBoard();
    //_cwBloc.setKeys(letterBoard.letters);
    return SafeArea(
      child: Provider(
        create: (_) => letterBoard,
        child: Provider(
          create: (_) => _cwBloc,
          child: Scaffold(
            appBar: AppBar(title: Text("Level $_level ")),
            body: BlocBuilder<CWordBloc, String>(
                builder: (context, String state) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 9,
                      child: _cwBloc.wordsLoaded
                          ? _buildBoxes(_cwBloc.words, context)
                          : Center(child: CircularProgressIndicator()),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(state,
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ))),
                    // Expanded(
                    //     flex: 4,
                    //     child: Row(children: [
                    //       Image.asset("assets/images/person.jpg"),
                    //       Text("Hint: ${_cwBloc.hintStr}"),
                    //     ])),
                    Expanded(flex: 9, child: letterBoard)
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
