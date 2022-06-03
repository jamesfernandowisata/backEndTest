class todotile {
  String? text;

  todotile();

  Map<String, dynamic> toJson() => {'text': text};

  todotile.fromSnapshot(snapshot) : text = snapshot.data()['text'];
}
