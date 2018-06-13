import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/counter_list_tile.dart';
import 'package:multiple_counters_flutter/database.dart';
import 'package:multiple_counters_flutter/placeholder_content.dart';

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

  void _createCounter(BuildContext context) async {
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
      body: Container(
        child: CountersListView(
          counters: _counters,
          onDecrement: _decrement,
          onIncrement: _increment,
          onDismissed: _delete,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createCounter(context),
      ),
    );
  }
}

class CountersListView extends StatelessWidget {
  CountersListView(
      {this.counters, this.onDecrement, this.onIncrement, this.onDismissed});
  final List<Counter> counters;
  final ValueChanged<Counter> onDecrement;
  final ValueChanged<Counter> onIncrement;
  final ValueChanged<Counter> onDismissed;

  @override
  Widget build(BuildContext context) {
    if (counters != null) {
      if (counters.length > 0) {
        return _buildList();
      } else {
        return PlaceholderContent(
          title: 'Nothing Here',
          message: 'Add a new item to get started.',
        );
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: counters.length,
        itemBuilder: (context, index) {
          Counter counter = counters[index];
          return CounterListTile(
            key: Key('counter-$index'),
            counter: counter,
            onDecrement: onDecrement,
            onIncrement: onIncrement,
            onDismissed: onDismissed,
          );
        });
  }
}
