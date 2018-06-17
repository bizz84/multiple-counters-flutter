import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/common_widgets/counter_list_tile.dart';
import 'package:multiple_counters_flutter/common_widgets/list_items_builder.dart';
import 'package:multiple_counters_flutter/database.dart';

class StreamsPage extends StatelessWidget {
  StreamsPage({this.database, this.stream});
  final Database database;
  final Stream<List<Counter>> stream;

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
        title: Text('Streams'),
        elevation: 1.0,
      ),
      body: Container(
        child: _buildContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _createCounter,
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<List<Counter>>(
      stream: stream,
      builder: (context, snapshot) {
        return ListItemsBuilder<Counter>(
          items: snapshot.hasData ? snapshot.data : null,
          itemBuilder: (context, counter) {
            return CounterListTile(
              key: Key('counter-${counter.id}'),
              counter: counter,
              onDecrement: _decrement,
              onIncrement: _increment,
              onDismissed: _delete,
            );
          },
        );
      },
    );
  }
}

