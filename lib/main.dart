import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:grundfos_news/blocs/SimpleBlocDelegate.dart';
import 'package:grundfos_news/widgets/NewsListWidget.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grundfos News',
      home: NewsList(),
    );
  }
}
