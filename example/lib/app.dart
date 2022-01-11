import 'package:flutter/material.dart';
import 'main.dart';
import 'model/controller.dart';
import 'tools/helper.dart';
import 'tools/popup.dart';

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
  Home({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  TextEditingController txtModel = TextEditingController();
  int? selectedDb;
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
                    Icon(Icons.arrow_right, color: Colors.black),
                    Text('About SqfEntity'),
                  ],
                ),
                value: 0,
              ),
              PopupMenuItem<int>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    Text('Create entities from \nthe model in Model.dart'),
                  ],
                ),
                value: 1,
              ),
              PopupMenuItem<int>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.arrow_right, color: Colors.black),
                    Text('Generate model\nfrom existing database\n_'),
                  ],
                ),
                value: 3,
              ),
              PopupMenuItem<int>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.arrow_right, color: Colors.black),
                    Text('run runSamples()'),
                  ],
                ),
                value: 2,
              ),
              PopupMenuItem<int>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.arrow_right, color: Colors.black),
                    Text('switch to Chinook.db'),
                  ],
                ),
                value: 4,
              ),
              PopupMenuItem<int>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.arrow_right, color: Colors.black),
                    Text('switch to Sample.db'),
                  ],
                ),
                value: 5,
              ),
            ],
          )
        ],
      ),
      body:
          //Text('HELLO')
          MainController(),
    );
  }

  void select(int value) async {
    switch (value) {
      case 0:
        showPopup(context, _aboutSqfEntity(), 'About SqfEntity');
        break;
      case 1:
        final String modelString = await createSqfEntityModelString(false);
        txtModel.text = modelString;
        showPopup(context, _generetedModelWindow(),
            'Model Entities was created\nsuccessfully');

        break;
      case 2:
        runSamples();
        UITools(context)
            .alertDialog('runSamples() ran. Go DEBUG CONSOLE for see results');
        break;
      case 3:
        txtModel.text = '''import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

   ''';
        txtModel.text += await createModelFromDatabaseSample();
        showPopup(context, _createdModelWindow(),
            'Model was generated\nfrom database successfully');

        break;
      case 4:
      case 5:
        setState(() {
          UITools.selectedDb = value - 4;
        });
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

  Widget _generetedModelWindow() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                    child: Text(
                  "Create models.g.dart file in your project and press Ctrl+V to paste the model from the Clipboard. If the clipboard didn't work, you can copy the text below",
                  style: TextStyle(color: Colors.deepPurple),
                )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: TextField(
                controller: txtModel,

                maxLines: 29, //grow automatically
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createdModelWindow() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                    child: Text(
                  'STEP1: Create lib/model/model.dart file in your project and press Ctrl+V to paste the model from the Clipboard.',
                  style: TextStyle(color: Colors.deepPurple),
                )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('Your database model is here:'),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: TextField(
                controller: txtModel,

                maxLines: 19, //grow automatically
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: Text(
                'STEP 2: To create ORM entities, go to the Terminal Window and run the following command:',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            TextField(
              maxLines: 2,
              controller: TextEditingController(
                  text:
                      'flutter pub run build_runner build --delete-conflicting-outputs'),
            ),
          ],
        ),
      ),
    );
  }
}
