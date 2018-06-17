import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:multiple_counters_flutter/common_widgets/counter_list_tile.dart';
import 'package:multiple_counters_flutter/common_widgets/list_items_builder.dart';
import 'package:multiple_counters_flutter/database.dart';


// Model
class ReduxModel {
  ReduxModel({this.counters});
  List<Counter> counters;
}

// Actions
class CreateCounterAction {

}

class IncrementCounterAction {
  IncrementCounterAction({this.counter});
  Counter counter;
}

class DecrementCounterAction {
  DecrementCounterAction({this.counter});
  Counter counter;
}

class DeleteCounterAction {
  DeleteCounterAction({this.counter});
  Counter counter;
}

class UpdateCountersAction {
  UpdateCountersAction({this.counters});
  List<Counter> counters;
}

// Middleware
class CountersMiddleware extends MiddlewareClass<ReduxModel> {
  CountersMiddleware({this.database, this.stream});
  final Database database;
  final Stream<List<Counter>> stream;

  void call(Store<ReduxModel> store, dynamic action, NextDispatcher next) {
    if (action is CreateCounterAction) {
      database.createCounter();
    }
    if (action is IncrementCounterAction) {
      Counter counter =
          Counter(id: action.counter.id, value: action.counter.value + 1);
      database.setCounter(counter);
    }
    if (action is DecrementCounterAction) {
      Counter counter =
          Counter(id: action.counter.id, value: action.counter.value - 1);
      database.setCounter(counter);
    }
    if (action is DeleteCounterAction) {
      database.deleteCounter(action.counter);
    }
    next(action);
  }

  void listen(Store<ReduxModel> store) {
    stream.listen((counters) {
      store.dispatch(UpdateCountersAction(counters: counters));
    });
  }
}

// Reducer
ReduxModel reducer(ReduxModel model, dynamic action) {
  if (action is UpdateCountersAction) {
    return ReduxModel(counters: action.counters);
  }
  // Special handling to ensure counter is removed immediately after Dismissable is dismissed.
  if (action is DeleteCounterAction) {
    List<Counter> counters = model.counters;
    counters.remove(action.counter);
    return ReduxModel(counters: counters);
  }
  return model;
}

// Page
class ReduxPage extends StatelessWidget {
  void _createCounter(Store<ReduxModel> store) async {
    store.dispatch(CreateCounterAction());
  }

  void _increment(Store<ReduxModel> store, Counter counter) async {
    store.dispatch(IncrementCounterAction(counter: counter));
  }

  void _decrement(Store<ReduxModel> store, Counter counter) async {
    store.dispatch(DecrementCounterAction(counter: counter));
  }

  void _delete(Store<ReduxModel> store, Counter counter) async {
    store.dispatch(DeleteCounterAction(counter: counter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux'),
        elevation: 1.0,
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createCounter(StoreProvider.of(context)),
      ),
    );
  }

  Widget _buildContent() {
    return StoreBuilder<ReduxModel>(
        builder: (context, Store<ReduxModel> store) {
          ReduxModel model = store.state;
          return ListItemsBuilder<Counter>(
            items: model.counters,
            itemBuilder: (context, counter) {
              return CounterListTile(
                key: Key('counter-${counter.id}'),
                counter: counter,
                onDecrement: (counter) => _decrement(store, counter),
                onIncrement: (counter) => _increment(store, counter),
                onDismissed: (counter) => _delete(store, counter),
              );
            },
          );
    });
  }
}
