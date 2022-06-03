import 'package:flutter/material.dart';
import 'package:proj1/model/todotile.dart';

class basiccard extends StatelessWidget {
  final todotile _todotile;

  basiccard(this._todotile);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(_todotile.text!));
  }
}
