import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/common_widgets/counter_list_tile.dart';
import 'package:multiple_counters_flutter/common_widgets/list_items_builder.dart';
import 'package:multiple_counters_flutter/database.dart';
import 'package:scoped_model/scoped_model.dart';

class CountersModel extends Model {
  CountersModel({this.database, this.stream}) {
    stream.listen((counters) {
      this.counters = counters;
      notifyListeners();
    });
  }
  final Database database;
  final Stream<List<Counter>> stream;

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
          title: Text('Scoped model'),
          elevation: 1.0,
        ),
        body: _buildContent(model),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: model.createCounter,
        ),
      );
    });
  }

  Widget _buildContent(CountersModel model) {
    return ListItemsBuilder<Counter>(
      items: model.counters,
      itemBuilder: (context, counter) {
        return CounterListTile(
          key: Key('counter-${counter.key}'),
          counter: counter,
          onDecrement: model.decrement,
          onIncrement: model.increment,
          onDismissed: model.delete,
        );
      },
    );
  }
}
