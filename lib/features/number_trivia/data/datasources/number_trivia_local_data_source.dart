import 'dart:convert';

import 'package:clean_architecture_exercise/core/errors/exceptions.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource{
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel);
}
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource{
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel) {
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, json.encode(triviaModel.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    // TODO: implement getLastNumberTrivia
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString != ''){
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }else{
      throw CacheException();
    }

  }

}