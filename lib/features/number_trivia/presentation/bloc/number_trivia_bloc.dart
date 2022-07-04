
import 'package:clean_architecture_exercise/core/errors/failures.dart';
import 'package:clean_architecture_exercise/core/usecases/usecase.dart';
import 'package:clean_architecture_exercise/core/util/input_converter.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/number_trivia.dart';
import 'bloc.dart';
import 'package:bloc/bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - ';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final GetConcreteNumberTrivia concreteNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter
}):assert(concreteNumberTrivia != null),assert(getRandomNumberTrivia != null),assert(inputConverter != null);
  @override
  // TODO: implement initialState
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async*{
    if(event is GetTriviaForConcreteNumber){
      final inputEither =  inputConverter.stringToUnsignedInteger(event.numberString);

       yield* inputEither.fold(
              (failure) async* { yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);},
              (integer) async*{
                yield Loading();

                final failureOrTrivia = await concreteNumberTrivia(Params(number: integer));
                yield* _eitherLoadedOrErrorState(failureOrTrivia);
                /*yield failureOrTrivia.fold(
                        (failure) =>
                            Error(
                            message:_mapFailureToMessage(failure)),
                        (trivia) => Loaded(numberTrivia: trivia));*/
              }
      );
    }else if(event is GetTriviaForRandomNumber){
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
     /* yield failureOrTrivia.fold(
              (failure) =>
              Error(message:_mapFailureToMessage(failure)),
              (trivia) => Loaded(numberTrivia: trivia));*/
    }
  }
  Stream<NumberTriviaState> _eitherLoadedOrErrorState(Either<Failure,NumberTrivia> failureOrTrivia) async*{
    yield failureOrTrivia.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (trivia) =>Loaded(numberTrivia: trivia),
    );
  }
  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:return SERVER_FAILURE_MESSAGE;
      case CacheFailure: return CACHE_FAILURE_MESSAGE;
      default: return 'Unexpected Error';
    }
  }
}
