import 'package:flutter/material.dart';
import 'package:sqfentity_sample/models/MyDbModel.dart';
import 'package:sqfentity_sample/screens/categoryList.dart';
import 'package:sqfentity_sample/tools/popup.dart';

import './tools/helper.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CONSTANTS.APP_TITLE,
      theme: ThemeData(
          primaryColor: Color.fromRGBO(95, 66, 119, 1.0),
          fontFamily: 'LexendDeca'),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(95, 66, 119, 1.0),
        title: Text(CONSTANTS.APP_TITLE),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: select,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.arrow_right),
                    Text("About SqfEntity"),
                  ],
                ),
                value: 0,
              ),
              PopupMenuItem<int>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.arrow_right),
                    Text("Generate model.dart"),
                  ],
                ),
                value: 1,
              ),
            ],
          )
        ],
      ),
      body: CategoryList(),
    );
  }

  void select(int value) {
    switch (value) {
      case 0:
        showPopup(context, _aboutSqfEntity(), 'About SqfEntity');
        break;
      case 1:
         MyDbModel().createModel();
        UITools(context).alertDialog(
            'Model was created successfully. Create models.dart file in your project and press Ctrl+V to paste the model from the Clipboard');
        break;
      default:
    }
  }

  Widget _aboutSqfEntity() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                    child: Text(
                        'SqfEntity ORM for Flutter/Dart lets you build and execute SQL commands easily and quickly with the help of fluent methods similar to .Net Entity Framework.')),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Flexible(child: Text(
                    //'Leave the job to SqfEntitiy for CRUD operations. Do easily and faster adding tables, adding columns, defining multiple tables, multiple databases etc. with the help of DbModel object'
                    'This sample project includes a sample application on how you can use sqfentity')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
