


import 'dart:convert';

import 'package:clean_architecture_exercise/core/errors/exceptions.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{}

void main(){
  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences) ;

  group('getLastNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return NumberTrivia from the Sharedpreferences when there is one in the cache', ()async{
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));

      final result = await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw a CacheException  when there is not cached value', ()async{
      when(mockSharedPreferences.getString(any)).thenReturn('');

      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia();

      expect(() => numberTriviaLocalDataSourceImpl.getLastNumberTrivia(), throwsA(TypeMatcher<CacheException>()));
    });
  });
  group('cacheNumberTrivia',(){
    final tNumberTriviaModel = NumberTriviaModel(number: 1,text: 'test trivia');
    test('should call SharedPreferences to cache the data', ()async{

      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA,expectedJsonString));
    });
  });
}