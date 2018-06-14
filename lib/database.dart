import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class Counter {
  Counter({this.key, this.value});
  String key;
  int value;
}

abstract class Database {
  // sets the value for the counter or creates a new one if it doesn't exist
  Future<void> setCounter(Counter counter);
  Future<void> deleteCounter(Counter counter);
}

class AppDatabase implements Database {
  static final String rootPath = 'counters';

  Future<void> setCounter(Counter counter) async {
    DatabaseReference databaseReference = _databaseReference(counter);
    await databaseReference.set(counter.value);
  }

  Future<void> deleteCounter(Counter counter) async {
    DatabaseReference databaseReference = _databaseReference(counter);
    await databaseReference.remove();
  }

  DatabaseReference _databaseReference(Counter counter) {
    var path = '$rootPath/${counter.key}';
    return FirebaseDatabase.instance.reference().child(path);
  }

  static Stream<List<Counter>> countersStream() {
    return _NodeStream<List<Counter>>(
      apiPath: rootPath,
      parser: _CountersParser(),
    ).stream;
  }
}

class _NodeStream<T> {
  _NodeStream({String apiPath, NodeParser<T> parser}) {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference databaseReference =
        firebaseDatabase.reference().child(apiPath);
    var eventStream = databaseReference.onValue;
    stream = eventStream.map((event) => parser.parse(event));
  }

  Stream<T> stream;
}

abstract class NodeParser<T> {
  T parse(Event event);
}

class _CountersParser implements NodeParser<List<Counter>> {
  List<Counter> parse(Event event) {
    Map<dynamic, dynamic> values = event.snapshot.value;
    if (values != null) {
      Iterable<String> keys = values.keys.cast<String>();
      var counters =
          keys.map((key) => Counter(key: key, value: values[key])).toList();
      counters.sort((lhs, rhs) => rhs.key.compareTo(lhs.key));
      return counters;
    } else {
      return [];
    }
  }
}
