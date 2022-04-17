import 'base_event.dart';

abstract class CWordEvent extends Event {}

class ClearWordEvent extends CWordEvent {}

class AddedLetterEvent extends CWordEvent {
  String newStr;
  AddedLetterEvent(this.newStr);
}

class CorrectEvent extends CWordEvent {}

class RemoveLetterEvent extends CWordEvent {
  String letter;
  RemoveLetterEvent(this.letter);
}

class ShowHintEvent extends CWordEvent {}

class RemoveOneEvent extends CWordEvent {}
