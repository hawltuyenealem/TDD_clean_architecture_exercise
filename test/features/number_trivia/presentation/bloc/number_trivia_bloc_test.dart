
import 'package:clean_architecture_exercise/core/errors/failures.dart';
import 'package:clean_architecture_exercise/core/usecases/usecase.dart';
import 'package:clean_architecture_exercise/core/util/input_converter.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_exercise/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:clean_architecture_exercise/features/number_trivia/presentation/bloc/bloc.dart';
class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia{
}
class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia{}

class MockInputConverter extends Mock implements InputConverter{}

void main(){

  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
  MockInputConverter mockInputConverter = MockInputConverter();
  NumberTriviaBloc numberTriviaBloc = NumberTriviaBloc(
      concreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia:mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
  );
  test('initial state should be empty', (){
    expect(numberTriviaBloc.initialState, equals(Empty()));
  });
  group('GetTriviaForConcreteNumber',(){
    final tNumberString  = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: tNumberParsed);
    
    test('should call the InputConverter to validate and convert the string to unsigned integer', ()async{
      when(mockInputConverter.stringToUnsignedInteger('1')).thenReturn(Right(tNumberParsed));
      
      numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger('1'));
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });
    test('should emit when input is invalid', ()async{
      when(mockInputConverter.stringToUnsignedInteger('1')).thenReturn(Left(InvalidInputFailure()));

      numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      final expectedResult =[
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expectedResult));
      
    });
    
    test('should get data from the concrete use case', ()async{
      when(mockInputConverter.stringToUnsignedInteger('1')).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(Params(number: 1))).thenAnswer((_)async => Right(tNumberTrivia));

      numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(Params(number: 1)));

      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });
    test('should emit [loading ,loaded] when the data is gone successfully', ()async{
      when(mockInputConverter.stringToUnsignedInteger('1')).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(Params(number: 1))).thenAnswer((_) async=>Right(tNumberTrivia) );

      final expectedResult = [
        Empty(),
        Loading(),
        Loaded(numberTrivia: tNumberTrivia),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expectedResult));
      numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [loading ,Error] when getting data fails', ()async{
      when(mockInputConverter.stringToUnsignedInteger('1')).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(Params(number: 1))).thenAnswer((_) async=> Left(ServerFailure()));

      final expectedResult = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expectedResult));
      numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });
    test('should emit [loading ,Error] with proper error message for the error when getting data fails', ()async{
      when(mockInputConverter.stringToUnsignedInteger('1')).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(Params(number: 1))).thenAnswer((_) async=> Left(ServerFailure()));

      final expectedResult = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expectedResult));
      numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });



  });


  group('GetTriviaForRandomNumber',(){
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: tNumberParsed);

    test('should get data from the random use case', ()async{

      when(mockGetRandomNumberTrivia(NoParams())).thenAnswer((_)async => Right(tNumberTrivia));

      numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(NoParams()));

      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [loading ,loaded] when the data is gone successfully', ()async{

      when(mockGetRandomNumberTrivia(NoParams())).thenAnswer((_) async=>Right(tNumberTrivia) );

      final expectedResult = [
        Empty(),
        Loading(),
        Loaded(numberTrivia: tNumberTrivia),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expectedResult));
      numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
    });

    test('should emit [loading ,Error] when getting data fails', ()async{
      when(mockGetRandomNumberTrivia(NoParams())).thenAnswer((_) async=> Left(ServerFailure()));

      final expectedResult = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expectedResult));
      numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
    });
    test('should emit [loading ,Error] with proper error message for the error when getting data fails', ()async{

      when(mockGetRandomNumberTrivia(NoParams())).thenAnswer((_) async=> Left(CacheFailure()));

      final expectedResult = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expectedResult));
      numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
    });



  });
}