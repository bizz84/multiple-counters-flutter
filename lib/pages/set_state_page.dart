import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/common_widgets/counter_list_tile.dart';
import 'package:multiple_counters_flutter/common_widgets/list_items_builder.dart';
import 'package:multiple_counters_flutter/database.dart';

class SetStatePage extends StatefulWidget {
  SetStatePage({this.database, this.subscription});
  final Database database;
  final NodeSubscription<List<Counter>> subscription;

  @override
  State<StatefulWidget> createState() => SetStatePageState();
}

class SetStatePageState extends State<SetStatePage> {
  List<Counter> _counters;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.subscription.stream.listen((counters) {
      setState(() {
        _counters = counters;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _createCounter() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    Counter counter = Counter(key: '$now', value: 0);
    await widget.database.setCounter(counter);
  }

  void _increment(Counter counter) async {
    counter.value++;
    await widget.database.setCounter(counter);
  }

  void _decrement(Counter counter) async {
    counter.value--;
    await widget.database.setCounter(counter);
  }

  void _delete(Counter counter) async {
    await widget.database.deleteCounter(counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setState'),
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
    return ListItemsBuilder<Counter>(
      items: _counters,
      itemBuilder: (context, counter) {
        return CounterListTile(
          key: Key('counter-${counter.key}'),
          counter: counter,
          onDecrement: _decrement,
          onIncrement: _increment,
          onDismissed: _delete,
        );
      },
    );
  }
}
