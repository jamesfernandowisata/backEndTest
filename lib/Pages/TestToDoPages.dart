import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proj1/model/todotile.dart';
import 'package:proj1/pages/Helper/basiccard.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class TestToDoPages extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  List<Object> _todoHistory = [];

  void _addText() {
    FirebaseFirestore.instance
        .collection("TestInput")
        .add({"text": _controller.text});
    _controller.text = "";
  }

  Future _getToDoData() async {
    var dataToDo =
        await FirebaseFirestore.instance.collection("TestInput").doc().get();
  }

  Widget _buildList(QuerySnapshot snapshot) {
    _todoHistory =
        List.from(snapshot.docs.map((doc) => todotile.fromSnapshot(doc)));

    return ListView.builder(
        itemCount: _todoHistory.length,
        itemBuilder: (context, index) {
          return basiccard(_todoHistory[index] as todotile);
        });
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Enter task name"),
            )),
            FlatButton(
              child: Text("Add Task", style: TextStyle(color: Colors.white)),
              color: Colors.green,
              onPressed: () {
                _addText();
              },
            )
          ],
        ),
        StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("TestInput").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return Expanded(child: _buildList(snapshot.data!));
            })
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List")),
      body: _buildBody(context),
    );
  }
}

class todotilesql {
  final int? id;
  final String text;

  todotilesql({this.id, required this.text});
  factory todotilesql.fromMap(Map<String, dynamic>json)=>new todotilesql(
    id: json['id'],
    text: json['text']
  );

  Map<String, dynamic>toMap(){
    return{
      'id':id,
      'text':text
    }
  }

}

class DatabaseHelper{
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = new DatabaseHelper._privateConstructor();
  static Database?_database;
  Future <Database> get database async=>_database??=await _initDatabase();

  Future <Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path=join(documentsDirectory.path, 'todolist1.db');
    return await openDatabase(
      path,
      version:1,
      onCreate:_onCreate,
    );
  }

  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE todolist(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
  }

  Future <List<todotilesql>> getToDoList()async{
      Database db =await instance.database;
      var todotiles = await db.query('todotiles');
  }


}


