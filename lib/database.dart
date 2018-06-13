import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

abstract class NodeParser<T> {

  T parse(Event event);
}

class Counter {
  Counter({this.key, this.value});
  String key;
  int value;
}

class CountersParser implements NodeParser<List<Counter>> {

  List<Counter> parse(Event event) {
    Map<dynamic, dynamic> values = event.snapshot.value;
    if (values != null) {
      Iterable<String> keys = values.keys.cast<String>();
      return keys.map((key) => Counter(key: key, value: values[key])).toList();
    } else {
      return [];
    }
  }
}

abstract class Database {

  Future<void> setCounter(Counter counter);
  Future<void> deleteCounter(Counter counter);
}

class NodeSubscription<T> {

  NodeSubscription({this.apiPath, this.parser}) {
    DatabaseReference databaseReference = firebaseDatabase.reference().child(apiPath);
    var eventStream = databaseReference.onValue;
    stream = eventStream.map((event) => parser.parse(event));
    subscription = eventStream.listen((event) {
      current = parser.parse(event);
    }, cancelOnError: true, onError: (error) {
      print('$error');
    });
  }
  final String apiPath;
  final NodeParser<T> parser;
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  StreamSubscription subscription;

  T current;
  Stream<T> stream;

  void cancel() {
    subscription.cancel();
    stream = null;
  }
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

  static NodeSubscription<List<Counter>> countersStream() {
    return NodeSubscription(
      apiPath: rootPath,
      parser: CountersParser(),
    );
  }
}

