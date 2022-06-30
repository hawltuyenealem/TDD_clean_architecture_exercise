
import 'dart:convert';

import 'package:clean_architecture_exercise/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  final tNumberTrivalModel = NumberTriviaModel(text: 'Test Text', number: 1);

  test(
    'Should be sub class of NumberTrivia entity',
      () async{

      expect(tNumberTrivalModel,isA<NumberTrivia>());
      }
  );

  group('fromJson',() {
    test('should return a valid model when the JSON number is an integer', () async{
      final Map<String,dynamic> jsonMap = json.decode(fixture('trivia_double.json'));

      final result  = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberTrivalModel));
    });
  });

  group('toJson', (){
    test('should return a JSON map containing the proper data', () async{
      final result = tNumberTrivalModel.toJson();

      final expectedMap = {
        "text" : 'Test Text',
        "number": 1
      };
      expect(result, expectedMap);
    });
  });
}