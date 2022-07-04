
import 'package:clean_architecture_exercise/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  InputConverter inputConverter = InputConverter();

  group('stringToUnsignedInt', (){
    test('should return an integer when string represents an unsigned integer',()async{
      final str = '1234';
      final result = inputConverter.stringToUnsignedInteger(str);
      
      expect(result, Right(1234));
    });
  });
  test('should return a failure when the string is not an integer ', ()async{
    final str = 'abcd';
    final result = inputConverter.stringToUnsignedInteger(str);
    expect(result, Left(InvalidInputFailure()));
  });
  test('should return a failure when the string is not negative integer ', ()async{
    final str = '-123';
    final result = inputConverter.stringToUnsignedInteger(str);
    expect(result, Left(InvalidInputFailure()));
  });
}