import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/common_widgets/counter_list_tile.dart';
import 'package:multiple_counters_flutter/common_widgets/list_items_builder.dart';
import 'package:multiple_counters_flutter/database.dart';

class StreamsPage extends StatelessWidget {
  StreamsPage({this.database, this.subscription});
  final Database database;
  final NodeSubscription<List<Counter>> subscription;

  void _createCounter(BuildContext context) async {
    int now = DateTime.now().millisecondsSinceEpoch;
    Counter counter = Counter(key: '$now', value: 0);
    await database.setCounter(counter);
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
        title: Text('setState'),
        elevation: 1.0,
      ),
      body: Container(
        child: _buildContent(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createCounter(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<List<Counter>>(
      stream: subscription.stream,
      builder: (context, snapshot) {
        return ListItemsBuilder<Counter>(
          items: snapshot.hasData ? snapshot.data : null,
          itemBuilder: (context, items, index) {
            Counter counter = items[index];
            return CounterListTile(
              key: Key('counter-$index'),
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

