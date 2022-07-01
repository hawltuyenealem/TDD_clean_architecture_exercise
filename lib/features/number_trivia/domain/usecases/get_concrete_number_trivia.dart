
import 'package:clean_architecture_exercise/core/errors/failures.dart';
import 'package:clean_architecture_exercise/core/usecases/usecase.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia,Params> {

  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia(this.numberTriviaRepository);

  Future<Either<Failure,NumberTrivia>> call(Params params) async{
    return await numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  final int number;

  Params({required this.number}):super([number]);
}