

import 'package:clean_architecture_exercise/core/errors/exceptions.dart';
import 'package:clean_architecture_exercise/core/errors/failures.dart';
import 'package:clean_architecture_exercise/core/network/network_info.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{

}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{}

class MockNetworkInfo extends Mock implements NetworkInfo{}

void main(){

  MockRemoteDataSource mockRemoteDataSource = MockRemoteDataSource();
  MockLocalDataSource mockLocalDataSource = MockLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();
  NumberTriviaRepositoryImpl numberTriviaRepositoryImpl  = NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: mockRemoteDataSource,
      numberTriviaLocalDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo
  );

  setUp((){
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
        numberTriviaRemoteDataSource: mockRemoteDataSource,
        numberTriviaLocalDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestOnline(Function body){
    group('', (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async=> true);
      });
      body();
    });
  }
  void runTestOffline(Function body){
    group('', (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async=> false);
      });
      body();
    });
  }


  group('getConcreteNumberTrivia',()
  {
    final tNumber  = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia  = tNumberTriviaModel;

    test('should check if the device is online',
            () async {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          numberTriviaRepositoryImpl.getConcreteNumberTrivia(1);
          verify(mockNetworkInfo.isConnected);
        });



    runTestOnline(() {

      test(
          'should return remote data when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(1)).thenAnswer((
            _) async => tNumberTriviaModel);
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(
            tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(1)).thenAnswer((
            _) async => tNumberTriviaModel);
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(1)).thenThrow(
            ServerException());
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(
            tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'should return last locally cached data when the cached data is present', () async {
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((
            _) async => tNumberTriviaModel);
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(
            tNumber);

        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should return Cache Failure when there is no  cached data', () async {
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(
            CacheException());
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(
            tNumber);

        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });


  group('getRandomNumberTrivia',()
  {
   // final tNumber  = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number:123);
    final NumberTrivia tNumberTrivia  = tNumberTriviaModel;

    test('should check if the device is online',
            () async {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          numberTriviaRepositoryImpl.getRandomNumberTrivia();
          verify(mockNetworkInfo.isConnected);
        });



    runTestOnline(() {

      test(
          'should return remote data when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((
            _) async => tNumberTriviaModel);
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((
            _) async => tNumberTriviaModel);
        await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(
            ServerException());
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'should return last locally cached data when the cached data is present', () async {
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((
            _) async => tNumberTriviaModel);
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should return Cache Failure when there is no  cached data', () async {
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(
            CacheException());
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}