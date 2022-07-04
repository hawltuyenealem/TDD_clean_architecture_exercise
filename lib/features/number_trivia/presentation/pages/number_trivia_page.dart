
import 'package:clean_architecture_exercise/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_architecture_exercise/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/number_trivia.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widget/widgets.dart';

class NumberTriviaPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }
  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context){
    return BlocProvider(
        builder: (_) =>sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 10.0,),
                BlocBuilder<NumberTriviaBloc,NumberTriviaState>(
                    builder: (context,state) {

                      if(state is Empty){
                        return MessageDisplay(message: 'Start Searching');
                      }
                      else if(state is Loading){
                        return CircularProgressIndicator();
                      }
                      else if(state is Loaded){
                        return TriviaDisplay(numberTrivia: state.numberTrivia);
                      }
                      else if(state is Error){
                        return MessageDisplay(message: state.message);
                      }else {
                        return Container();
                      }
                      },
                  ),
                SizedBox(height: 20.0),
                TriviaControl(),

              ],
            ),
          ),
        )
    );
  }
}
