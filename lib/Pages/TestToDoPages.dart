import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proj1/model/todotile.dart';
import 'package:proj1/pages/Helper/basiccard.dart';

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
