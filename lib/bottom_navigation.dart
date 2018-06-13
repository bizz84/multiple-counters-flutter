import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:multiple_counters_flutter/database.dart';
import 'package:multiple_counters_flutter/pages/redux_page.dart';
import 'package:multiple_counters_flutter/pages/scoped_model_page.dart';
import 'package:multiple_counters_flutter/pages/set_state_page.dart';
import 'package:multiple_counters_flutter/pages/streams_page.dart';

enum TabItem {
  setState,
  scoped,
  streams,
  redux,
}

String tabItemName(TabItem tabItem) {
  switch (tabItem) {
    case TabItem.setState:
      return "setState";
    case TabItem.scoped:
      return "scoped";
    case TabItem.streams:
      return "streams";
    case TabItem.redux:
      return "redux";
  }
  return null;
}

class BottomNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  TabItem currentItem = TabItem.setState;

  _onSelectTab(int index) {
    switch (index) {
      case 0:
        _updateCurrentItem(TabItem.setState);
        break;
      case 1:
        _updateCurrentItem(TabItem.scoped);
        break;
      case 2:
        _updateCurrentItem(TabItem.streams);
        break;
      case 3:
        _updateCurrentItem(TabItem.redux);
        break;
    }
  }

  _updateCurrentItem(TabItem item) {
    setState(() {
      currentItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (currentItem) {
      case TabItem.setState:
        return SetStatePage(
          database: AppDatabase(),
          subscription: AppDatabase.countersStream(),
        );
      case TabItem.scoped:
        return ScopedModel<CountersModel>(
          model: CountersModel(
            database: AppDatabase(),
            subscription: AppDatabase.countersStream(),
          ),
          child: ScopedModelPage(),
        );
      case TabItem.streams:
        return StreamsPage(
          database: AppDatabase(),
          subscription: AppDatabase.countersStream(),
        );
      case TabItem.redux:
        final middleware = CountersMiddleWare(
          database: AppDatabase(),
          subscription: AppDatabase.countersStream(),
        );
        final store = Store<ReduxModel>(
          reducer,
          initialState: ReduxModel(counters: null),
          middleware: [ middleware ],
        );
        middleware.listen(store);
        return StoreProvider(
          store: store,
          child: ReduxPage(),
        );
    }
    return Container();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(icon: Icons.adjust, tabItem: TabItem.setState),
        _buildItem(icon: Icons.arrow_downward, tabItem: TabItem.scoped),
        _buildItem(icon: Icons.clear_all, tabItem: TabItem.streams),
        _buildItem(icon: Icons.settings_input_component, tabItem: TabItem.redux),
      ],
      onTap: _onSelectTab,
    );
  }

  BottomNavigationBarItem _buildItem({IconData icon, TabItem tabItem}) {
    String text = tabItemName(tabItem);
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentItem == item ? Theme.of(context).primaryColor : Colors.grey;
  }
}
