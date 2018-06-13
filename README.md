## Flutter State Management - Four Ways

This is a sample app showing four different approaches to managing state in Flutter.

This project is an extension of the default Flutter counter app.

Supported tasks:

- Show a list of counters
- Add new counters
- Increment or decrement existing counters
- Remove counters (swipe left to dismiss)

### Preview

![](screenshots/multiple_counters_tabs.png)

## Firebase Database

The app uses Firebase Realtime Database as a source of truth for the state of the counters. This allows the data to be **easily synced** across multiple clients.

**NOTE**: For simplicity, the whole database has public read/write access, and counters can't be set per-user. For a production app it would be more appropriate to set user access rules.

## State management

The same functionality is replicated in four different pages accessible via the bottom navigation bar, using different state management techniques:

* [`setState`](https://docs.flutter.io/flutter/widgets/State/setState.html)
* [`StreamBuilder`](https://docs.flutter.io/flutter/widgets/StreamBuilder-class.html)
* [`scoped_model`](https://pub.dartlang.org/packages/scoped_model)
* [`redux`](https://pub.dartlang.org/packages/redux)

Watch my video for a full overview of the differences and tradeoffs between these techniques.

### TODO: YouTube video


### For more articles and video tutorials, check out [Coding With Flutter](https://codingwithflutter.com/).

### [License: MIT](LICENSE.md)
