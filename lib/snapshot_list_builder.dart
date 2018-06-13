
import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/placeholder_content.dart';

typedef Widget SnapshotListItemBuilder<T>(BuildContext context, List<T> items, int index);

class SnapshotListBuilder<T> extends StatelessWidget {

  SnapshotListBuilder({
    this.snapshot,
    this.itemBuilder,
  });
  final AsyncSnapshot<List<T>> snapshot;
  final SnapshotListItemBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      var items = snapshot.data;
      if (items.length > 0) {
        return _buildList(items);
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

  Widget _buildList(List<T> items) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return itemBuilder(context, items, index);
        });
  }
}

