import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/cwordbloc.dart';
import '../bloc/events/cword_event.dart';
import '../widgets/letter.dart';

class LetterBoard extends StatelessWidget {
  List<Letter> letters = [];
  bool _wordsLoaded = false;
  LetterBoard({Key? key}) : super(key: key);
  List<Widget> _lettersWids = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return BlocBuilder<CWordBloc, String>(builder: (context, snapshot) {
      final cwBloc = Provider.of<CWordBloc>(context, listen: false);
      if (!this._wordsLoaded && cwBloc.wordsLoaded) {
        letters = [];
        cwBloc.letters.split("").forEach((String element) {
          letters.add(new Letter(element));
        });
        this._wordsLoaded = true;
        letters.forEach((Widget element) {
          _lettersWids.add(element);
        });
      }

      return Card(
        elevation: 10.00,
        //shape: CircleBorder(),
        child: GridView.count(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisCount: 4,
          key: Key("ssdsd"),
          children: (_lettersWids +
              [
                OutlinedButton.icon(
                    onPressed: () {
                      cwBloc.add(RemoveOneEvent());
                    },
                    label: Text("Last"),
                    icon: Icon(Icons.backspace)),
                OutlinedButton.icon(
                    onPressed: () {
                      cwBloc.add(ShowHintEvent());
                    },
                    icon: Icon(Icons.question_answer_sharp),
                    label: Text("Hint?")),
                OutlinedButton.icon(
                    onPressed: () {
                      for (int i = 0; i < letters.length; i++)
                        (letters[i]).isSelected = false;
                      cwBloc.add(ClearWordEvent());
                      // _letters as List<Letter>;
                    },
                    icon: Icon(Icons.clear),
                    label: Text("Clear")),
              ]),
        ),
      );
    });
  }
}
