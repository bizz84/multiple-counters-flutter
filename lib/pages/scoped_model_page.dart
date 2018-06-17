import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/common_widgets/counter_list_tile.dart';
import 'package:multiple_counters_flutter/common_widgets/list_items_builder.dart';
import 'package:multiple_counters_flutter/database.dart';
import 'package:scoped_model/scoped_model.dart';

class CountersModel extends Model {
  CountersModel({Stream<List<Counter>> stream}) {
    stream.listen((counters) {
      this.counters = counters;
      notifyListeners();
    });
  }

  List<Counter> counters;
}

class ScopedModelPage extends StatelessWidget {
  ScopedModelPage({this.database});
  final Database database;

  void _createCounter() async {
    await database.createCounter();
  }

  void _increment(Counter counter) async {
    counter.value++;
    await database.setCounter(counter);
  }

  void _decrement(Counter counter) async {
    counter.value--;
    await database.setCounter(counter);
  }

  void _delete(Counter counter) async {
    await database.deleteCounter(counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scoped model'),
        elevation: 1.0,
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _createCounter,
      ),
    );
  }

  Widget _buildContent() {
    return ScopedModelDescendant<CountersModel>(
        builder: (context, child, model) {
      return ListItemsBuilder<Counter>(
          items: model.counters,
          itemBuilder: (context, counter) {
            return CounterListTile(
              key: Key('counter-${counter.id}'),
              counter: counter,
              onDecrement: _decrement,
              onIncrement: _increment,
              onDismissed: _delete,
            );
          });
    });
  }
}
