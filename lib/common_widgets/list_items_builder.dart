
import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/common_widgets/placeholder_content.dart';

typedef Widget ItemWidgetBuilder<T>(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  ListItemsBuilder({this.items, this.itemBuilder});
  final List<T> items;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (items != null) {
      if (items.length > 0) {
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
        itemCount: items.length,
        itemBuilder: (context, index) {
          return itemBuilder(context, items[index]);
        });
  }
}
