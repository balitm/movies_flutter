import 'package:flutter/material.dart';
import 'ui/widgets/Movies.dart';

void main() {
  runApp(Movies());
}

class Movies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MoviesPage(title: 'Flutter Demo Home Page'),
    );
  }
}
