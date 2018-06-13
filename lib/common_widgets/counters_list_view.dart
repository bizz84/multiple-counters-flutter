
import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/common_widgets/counter_list_tile.dart';
import 'package:multiple_counters_flutter/database.dart';
import 'package:multiple_counters_flutter/common_widgets/placeholder_content.dart';

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
        return PlaceholderContent();
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
