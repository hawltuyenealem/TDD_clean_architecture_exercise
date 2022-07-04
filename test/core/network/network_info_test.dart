
import 'package:clean_architecture_exercise/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker{}

void main(){
  MockDataConnectionChecker mockDataConnectionChecker = MockDataConnectionChecker();
  NetworkInfoImpl networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);

  setUp((){
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected',(){

    test('should forward the call to DataConnectionChecker.hasConnection',()async{
      final tHasConnectionFuture  = Future.value(true);
      when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async=> tHasConnectionFuture);

      final result = networkInfoImpl.isConnected;

      verify(mockDataConnectionChecker.hasConnection);
      expect(result,tHasConnectionFuture);

    });
  });
}