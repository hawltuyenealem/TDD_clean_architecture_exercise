
import 'dart:convert';

import 'package:clean_architecture_exercise/core/errors/exceptions.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart'as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
class MockHttpClient extends Mock implements http.Client{
}

void main(){
  MockHttpClient mockHttpClient = MockHttpClient();
  NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

  group('getConcreteNumberTrivia',(){
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('should perform a GET request on a URL with number being the endpoint and with application/json header',()async{
      when(mockHttpClient.get(any,headers: anyNamed('headers'))).thenAnswer((_)async => http.Response(fixture('trivia.json'),200));

      numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',headers: {
        'Content-Type':'application/json'
      }));

    });
    test('should return Number Trivia when the response code is 200(success)',()async{
      when(mockHttpClient.get(any,headers: anyNamed('headers'))).thenAnswer((_)async => http.Response(fixture('trivia.json'),200));

      final result = await numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      
      expect(result, equals(tNumberTriviaModel));

    });
    test('should throw ServerException when the response code is 404 or other',()async{
      when(mockHttpClient.get(any,headers:anyNamed('headers'))).thenAnswer((_)async => http.Response('Something went wrong',404) );

      final call = numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia;
      expect(()=>call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });
  group('getRandomNumberTrivia',(){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('should perform a GET request on a URL with number being the endpoint and with application/json header',()async{
      when(mockHttpClient.get(any,headers: anyNamed('headers'))).thenAnswer((_)async => http.Response(fixture('trivia.json'),200));

      numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      verify(mockHttpClient.get('http://numbersapi.com/random',headers: {
        'Content-Type':'application/json'
      }));

    });
    test('should return Number Trivia when the response code is 200(success)',()async{
      when(mockHttpClient.get(any,headers: anyNamed('headers'))).thenAnswer((_)async => http.Response(fixture('trivia.json'),200));

      final result = await numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));

    });
    test('should throw ServerException when the response code is 404 or other',()async{
      when(mockHttpClient.get(any,headers:anyNamed('headers'))).thenAnswer((_)async => http.Response('Something went wrong',404) );

      final call = numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      expect(()=>call, throwsA(TypeMatcher<ServerException>()));
    });
  });
}