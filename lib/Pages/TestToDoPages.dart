import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proj1/model/todotile.dart';
import 'package:proj1/pages/Helper/basiccard.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proj1/Pages/Helper/sqlitehelper.dart';

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

  void _addTextSql() async {
    int i = await sqlitehelper.instance
        .insert({sqlitehelper.sqliteColumnName: _controller.text});
    print('new data id is $i');
    _controller.text = "";
  }

  void _updateTextSql() {}
  void _deleteTextSql() {}
  void _queryTextSql() async {
    List<Map<String, dynamic>> queryRows =
        await sqlitehelper.instance.queryAll();
    print(queryRows);
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
            // FlatButton(
            //   child: Text("Add Task", style: TextStyle(color: Colors.white)),
            //   color: Colors.green,
            //   onPressed: () {
            //     _addText();
            //   },
            // )
          ],
        ),
        Row(
          children: [
            FlatButton(
              child: Text("Add Task", style: TextStyle(color: Colors.white)),
              color: Colors.green,
              onPressed: () {
                _addTextSql();
              },
            ),
            FlatButton(
              child: Text("Update Task", style: TextStyle(color: Colors.white)),
              color: Colors.blue,
              onPressed: () {
                _updateTextSql();
              },
            ),
            FlatButton(
              child: Text("Delete Task", style: TextStyle(color: Colors.white)),
              color: Colors.red,
              onPressed: () {
                _deleteTextSql();
              },
            ),
            FlatButton(
              child: Text("Query Task", style: TextStyle(color: Colors.white)),
              color: Colors.purple,
              onPressed: () {
                _queryTextSql();
              },
            ),
          ],
        ),
        //View SQLite Data
        //  FutureBuilder<List<todotilesql>>(
        //     builder: ,
        //     )
        //View Firebase Data
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
