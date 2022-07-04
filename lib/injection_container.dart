

import 'package:clean_architecture_exercise/core/network/network_info.dart';
import 'package:clean_architecture_exercise/core/util/input_converter.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_exercise/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_exercise/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_exercise/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
final sl = GetIt.instance;
Future<void>init() async{
  // Features
  sl.registerFactory(() => NumberTriviaBloc(
      concreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()
  ));

  //use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //repository
  sl.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: sl(),
      numberTriviaLocalDataSource: sl(),
      networkInfo: sl()
  ));

  // Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client);
  sl.registerLazySingleton(() => DataConnectionChecker());

}

void initFeatures(){}