import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/database.dart';

class CounterListTile extends StatelessWidget {
  CounterListTile({this.key, this.counter, this.onDecrement, this.onIncrement, this.onDismissed});
  final Key key;
  final Counter counter;
  final ValueChanged<Counter> onDecrement;
  final ValueChanged<Counter> onIncrement;
  final ValueChanged<Counter> onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(counter),
      child: ListTile(
        title: Text(
          '${counter.value}',
          style: TextStyle(fontSize: 48.0),
        ),
        subtitle: Text(
          '${counter.id}',
          style: TextStyle(fontSize: 16.0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CounterActionButton(
              iconData: Icons.remove,
              onPressed: () => onDecrement(counter),
            ),
            SizedBox(width: 8.0),
            CounterActionButton(
              iconData: Icons.add,
              onPressed: () => onIncrement(counter),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterActionButton extends StatelessWidget {
  CounterActionButton({this.iconData, this.onPressed});
  final VoidCallback onPressed;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28.0,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        icon: Icon(iconData, size: 28.0),
        color: Colors.black,
        onPressed: onPressed,
      ),
    );
  }
}
