import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class TriviaControl extends StatefulWidget{
  _TriviaControlState createState()=> _TriviaControlState();
}
class _TriviaControlState extends State<TriviaControl>{
  final controller  = TextEditingController();
  late String inputStr;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Column(children: [
      TextField(
        onSubmitted: (_){
          _dispatchConcrete();
        },
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Input Number',

        ),
        onChanged: (value){
          inputStr = value;
        },),
      SizedBox(height: 10.0,),
      Row(children: [
        Expanded(child: RaisedButton(
          onPressed: _dispatchConcrete,
          color:Theme.of(context).accentColor ,
          textTheme: ButtonTextTheme.primary,
          child: Text('Search'),)),
        SizedBox(width: 10,),
        Expanded(child: RaisedButton(
          onPressed: _dispatchRandom,
          child: Text('Get random trivia'),)),
      ],)
    ],);

  }
  void _dispatchConcrete(){
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetTriviaForConcreteNumber(inputStr));
  }
  void _dispatchRandom(){
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetTriviaForRandomNumber());
  }
}