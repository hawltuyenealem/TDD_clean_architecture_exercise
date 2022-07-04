
import 'package:clean_architecture_exercise/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]):super(props);
}

class Empty extends NumberTriviaState {
}
class Loading extends NumberTriviaState {
}
class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded({required this.numberTrivia}):super([numberTrivia]);
}
class Error extends NumberTriviaState {
  final String message;

  Error({required this.message}):super([message]);
}