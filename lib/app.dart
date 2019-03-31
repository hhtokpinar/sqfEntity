import 'package:flutter/material.dart';

String _modelString;

String get modelString => _modelString;

set modelString(String modelStrings) {
  _modelString = modelStrings;
}

class MyApp extends StatelessWidget {
  MyApp(String setmodelString) {
    modelString = setmodelString;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SqfEntity Model Creator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  final TextEditingController txtModel =
      new TextEditingController(text: modelString);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SqfEntity Model Creator"),
        leading: Icon(Icons.assignment),
      ),
      body: _buildHomePage(context),
    );
  }

  _buildHomePage(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      // hack textfield height
      padding: EdgeInsets.only(bottom: 40.0),
      child: TextField(
        controller: txtModel,
        maxLines: 99,
      ),
    );
  }
}
