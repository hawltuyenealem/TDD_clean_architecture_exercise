
import 'package:clean_architecture_exercise/core/errors/exceptions.dart';
import 'package:clean_architecture_exercise/core/errors/failures.dart';
import 'package:clean_architecture_exercise/core/network/network_info.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';


typedef Future<NumberTrivia> _ConcereteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository{
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NetworkInfo networkInfo;
  NumberTriviaRepositoryImpl({
    required this.numberTriviaRemoteDataSource,
    required this.numberTriviaLocalDataSource,
    required this.networkInfo
});
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async{

    // TODO: implement getConcreteNumberTrivia
/*    if(await networkInfo.isConnected){
      try{

        final remoteTrivia = await numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
        numberTriviaLocalDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      }on ServerException{
        return Left(ServerFailure());
      }
    }
    else {
      try{
        final localTrivia = await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      }on CacheException {
        return Left(CacheFailure());
      }

    }*/
  return await _getTrivia(() {
    return numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
  });

  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async{
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource.getRandomNumberTrivia();
    });
    // TODO: implement getRandomNumberTrivia
   /* if(await networkInfo.isConnected){
      try{

        final remoteTrivia = await numberTriviaRemoteDataSource.getRandomNumberTrivia();
        numberTriviaLocalDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      }on ServerException{
        return Left(ServerFailure());
      }
    }
    else {
      try{
        final localTrivia = await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      }on CacheException {
        return Left(CacheFailure());
      }

    }*/
  }
  Future<Either<Failure,NumberTrivia>> _getTrivia(_ConcereteOrRandomChooser getConcreteOrRandom)async{
    if(await networkInfo.isConnected){
      try{

        final remoteTrivia = await getConcreteOrRandom();
        final remoteTrivia1= NumberTriviaModel(text: remoteTrivia.text, number: remoteTrivia.number);
        numberTriviaLocalDataSource.cacheNumberTrivia(remoteTrivia1);
        return Right(remoteTrivia);
      }on ServerException{
        return Left(ServerFailure());
      }
    }
    else {
      try{
        final localTrivia = await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      }on CacheException {
        return Left(CacheFailure());
      }

    }
  }

}