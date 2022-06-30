

import 'package:clean_architecture_exercise/core/platform/network_info.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/entities/number_trivia.dart';
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

  group('getConcreteNumberTrivia',(){
    final tNumber  = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia  = tNumberTriviaModel;
   test('should check if the device is online',
           () async{
     when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

     numberTriviaRepositoryImpl.getConcreteNumberTrivia(1);
     verify(mockNetworkInfo.isConnected);

   });
  });

}