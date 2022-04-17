import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/cwordbloc.dart';
import '../bloc/events/cword_event.dart';

class Letter extends StatelessWidget {
  String letter;
  Letter(this.letter, {Key? key}) : super(key: key);
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CWordBloc, String>(builder: (context, state) {
      return Card(
        elevation: isSelected ? 10.00 : 0.00,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                  color: isSelected ? Colors.black : Colors.amberAccent)),
          padding: EdgeInsets.all(10),
          child: TextButton(
            onPressed: () {
              print("PRESSED");
              final cwBloc = Provider.of<CWordBloc>(context, listen: false);
              if (!isSelected)
                cwBloc.add(AddedLetterEvent(this.letter));
              else
                cwBloc.add(RemoveLetterEvent(this.letter));
              this.isSelected = !this.isSelected;
            },
            child: Text(
              "$letter",
              style: TextStyle(fontSize: 25),
            ),
          ),
        ),
      );
    });
  }
}
