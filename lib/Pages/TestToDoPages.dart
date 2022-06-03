import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestToDoPages extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  void _addText() {
    FirebaseFirestore.instance
        .collection("TestInput")
        .add({"text": _controller.text});
    _controller.text = "";
  }

  // Widget _buildList(QuerySnapshot snapshot) {
  //   return ListView.builder(
  //       itemCount: snapshot.docs.length,
  //       itemBuilder: (context, index) {
  //         final doc = snapshot.docs.map(("TestInput"){
  //             return ListTile(
  //               title:Text(TestInput['text'])
  //               )
  //         });
  //       });
  // }

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
            builder: (context, snapshot) {
              //if (!snapshot.hasData)
              return LinearProgressIndicator();
              // else
              //   return Expanded(child: _buildList(snapshot.data!));
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
