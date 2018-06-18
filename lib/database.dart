import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class Counter {
  Counter({this.id, this.value});
  int id;
  int value;
}

abstract class Database {
  Future<void> createCounter();
  Future<void> setCounter(Counter counter);
  Future<void> deleteCounter(Counter counter);
}

class AppDatabase implements Database {
  Future<void> createCounter() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    Counter counter = Counter(id: now, value: 0);
    await setCounter(counter);
  }

  Future<void> setCounter(Counter counter) async {
    DatabaseReference databaseReference = _databaseReference(counter);
    await databaseReference.set(counter.value);
  }

  Future<void> deleteCounter(Counter counter) async {
    DatabaseReference databaseReference = _databaseReference(counter);
    await databaseReference.remove();
  }

  DatabaseReference _databaseReference(Counter counter) {
    var path = '$rootPath/${counter.id}';
    return FirebaseDatabase.instance.reference().child(path);
  }

  static Stream<List<Counter>> countersStream() {
    return _NodeStream<List<Counter>>(
      apiPath: rootPath,
      parser: _CountersParser(),
    ).stream;
  }

  static final String rootPath = 'counters';
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

      var counters = keys
          .map((key) => Counter(id: int.parse(key), value: values[key]))
          .toList();
      counters.sort((lhs, rhs) => rhs.id.compareTo(lhs.id));
      return counters;
    } else {
      return [];
    }
  }
}
