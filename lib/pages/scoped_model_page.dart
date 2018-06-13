import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/common_widgets/counters_list_view.dart';
import 'package:multiple_counters_flutter/database.dart';
import 'package:scoped_model/scoped_model.dart';

class CountersModel extends Model {
  CountersModel({this.database, this.subscription}) {
    subscription.stream.listen((counters) {
      this.counters = counters;
      notifyListeners();
    });
  }
  final Database database;
  final NodeSubscription<List<Counter>> subscription;

  List<Counter> counters;

  void createCounter() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    Counter counter = Counter(key: '$now', value: 0);
    await database.setCounter(counter);
  }

  void increment(Counter counter) async {
    counter.value++;
    await database.setCounter(counter);
  }

  void decrement(Counter counter) async {
    counter.value--;
    await database.setCounter(counter);
  }

  void delete(Counter counter) async {
    await database.deleteCounter(counter);
  }
}

class ScopedModelPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CountersModel>(
        builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('setState'),
          elevation: 1.0,
        ),
        body: Container(
          child: CountersListView(
            counters: model.counters,
            onDecrement: model.decrement,
            onIncrement: model.increment,
            onDismissed: model.delete,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: model.createCounter,
        ),
      );
    });
  }
}
