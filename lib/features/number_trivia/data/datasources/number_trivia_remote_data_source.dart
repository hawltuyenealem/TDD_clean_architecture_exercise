import 'dart:convert';

import 'package:clean_architecture_exercise/core/errors/exceptions.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart'as http;
abstract class NumberTriviaRemoteDataSource {

  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource{
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async{
    return await _getTriviaFromUrl('http://numbersapi.com/$number');
  /*  final response = await client.get('http://numbersapi.com/$number',headers: {'Content-Type':'application/json'
    });
    if(response.statusCode ==200){
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }else {
      throw ServerException();
    }*/
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async{
    return await _getTriviaFromUrl('http://numbersapi.com/random');
   /* final response = await client.get('http://numbersapi.com/random',headers: {'Content-Type':'application/json'});
    if(response.statusCode ==200){
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }else {
      throw ServerException();
    }*/
  }
  Future<NumberTriviaModel> _getTriviaFromUrl(String url )async{
    final response = await client.get(url,headers: {'Content-Type':'application/json'});
    if(response.statusCode ==200){
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }else {
      throw ServerException();
    }
  }

}

