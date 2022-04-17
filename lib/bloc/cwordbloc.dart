import 'dart:convert';

import 'package:crossword/services/db.dart';
import 'package:crossword/widgets/letter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'events/cword_event.dart';
import '../models/word.dart';
import '../widgets/box.dart';
import '../widgets/letter_board.dart';
import '../widgets/letter.dart';

import 'dart:math';

class CWordBloc extends Bloc<CWordEvent, String> {
  late List<Box> _boxes;
  late BuildContext _context;
  // late List<Letter> _keys;
  // setKeys(List<Letter> _keys) => this._keys = _keys;
  setBoxes(List<Box> boxes) {
    this._boxes = boxes;
  }

  setContext(BuildContext con) => _context = con;
  String hintStr = "";
  get words => _words;
  List<Word> _words = [];
  Set<Word> _answerdWords = {};
  List<String> _hints = [];
  String _letters = "";
  String get letters => _letters;
  bool _wordsLoaded = false;
  get wordsLoaded => _wordsLoaded;

  //String _str = "";
  CWordBloc(String level) : super("") {
    on<ShowHintEvent>((event, emit) {
      int index = Random().nextInt(_hints.length);
      this.hintStr = _hints[index];
      Fluttertoast.showToast(
          msg: "hint: " + this.hintStr, toastLength: Toast.LENGTH_LONG);
    });
    on<ClearWordEvent>((event, emit) => emit(""));
    on<CorrectEvent>((event, emit) => emit("Correct!"));
    on<RemoveOneEvent>((event, emit) {
      this.add(RemoveLetterEvent(state[state.length - 1]));
    });
    on<RemoveLetterEvent>((event, emit) {
      List<String> newStrList = state.split('');
      newStrList.remove(event.letter);
      String newStr = "";
      newStrList.forEach((String element) {
        newStr += element;
      });
      emit("");
    });
    on<AddedLetterEvent>((event, emit) async {
      final audioPlayer = Provider.of<AudioPlayer>(_context, listen: false);
      final letterBoard = Provider.of<LetterBoard>(_context, listen: false);

      emit(state + event.newStr);
      // int wordIndex = 0;
      _words.forEach((Word element) {
        if (state == element.spelling && !element.answerd) {
          //List<Letter> letters = _letterBoard.lettes as List<Letter>;
          // _words.removeAt(wordIndex);
          //wordIndex++;
          _answerdWords.add(element);
          element.answerd = true;
          _hints.remove(element.hint);
          if (_answerdWords.length == _words.length) {
            print("Hostile!");
            (() async {
              final dbService = Provider.of<DbService>(_context, listen: false);
              if (dbService == null) {
                print("Error cannot find dbSVC");
              }
              int curLevel =
                  await dbService.read("general", "cur_level", Object());
              curLevel++;
              print("new curlevel: $curLevel");

              await dbService.write("general", "cur_level", curLevel, Object());
              Navigator.pushReplacementNamed(_context, '/won');
            })();
          }

          letterBoard.letters.forEach((element) {
            element.isSelected = false;
          });
          Fluttertoast.showToast(msg: "Correct");
          _boxes.forEach((Box box) {
            final word = element;
            if (word.direction == 'H') {
              for (int i = 0; i < word.spelling.length; i++) {
                _boxes[i + word.startPos + word.startCross * 6].show();
              }
            } else if (word.direction == 'V') {
              // print("Vertical");
              for (int i = 0; i < word.spelling.length; i++) {
                // print("Looping");
                int index = i * 6 + 6 * word.startPos + word.startCross;
                print("index: $index");
                _boxes[index].show();
              }
            }
          });
          try {
            (() async {
              //await Future.delayed(Duration(microseconds: 500));
              //if (audioPlayer.playing) await audioPlayer.dispose();

              //await audioPlayer.setAsset('assets/audio/word_completed.wav');

              //await audioPlayer.play();
            })();
          } on Exception catch (e) {
            print("Audi player exception: $e");
          }
          emit("");
        }
      });
      (() async {
        //await Future.delayed(Duration(microseconds: 500));
        // (audioPlayer.playing) await audioPlayer.dispose();

        await audioPlayer.setAsset("assets/audio/letter_select.wav");
        //await Future.delayed(Duration(microseconds: 500));
        await audioPlayer.play();
      })();
    });
    (() async {
      print("Opening Level $level");
      String levelString =
          (await rootBundle.loadString("assets/levels/${level}/words.json"));
      final levelWordsData = await jsonDecode(levelString);
      final levelWordsRaw = levelWordsData['words'];
      this._letters = levelWordsData['letters'];
      levelWordsRaw as List;
      levelWordsRaw.forEach((element) {
        element as Map<String, dynamic>;
        final word = Word.fromJson(element['spelling'], element['direction'],
            element['startPos'], element['hint'], element["startCross"]);
        print("Word : $word");
        _hints.add(word.hint);
        _words.add(word);
      });
      _wordsLoaded = true;
      emit("");
    })();
  }
}
