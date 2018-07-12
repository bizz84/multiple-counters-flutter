## Flutter State Management

This is a sample app showing four different approaches to managing state in Flutter:

### [`setState`](https://docs.flutter.io/flutter/widgets/State/setState.html) vs [`StreamBuilder`](https://docs.flutter.io/flutter/widgets/StreamBuilder-class.html) vs [`scoped_model`](https://pub.dartlang.org/packages/scoped_model) vs [`redux`](https://pub.dartlang.org/packages/redux)

**Use case: manage multiple counters, synced with Firebase Database.**

Watch my video for a full overview of the differences and tradeoffs between these techniques:

[![](screenshots/poster-state-management.png)](https://youtu.be/HLop7s2sJ7Q)

Supported tasks:

- Show a list of counters
- Add new counters
- Increment or decrement existing counters
- Remove counters (swipe left to dismiss)

## Database

The app uses Firebase as a source of truth for the state of the counters. This allows the data to be **easily synced** across multiple clients. Realtime Database and Cloud Firestore are both supported (see `database.dart` class).

**NOTE**: For simplicity, the whole database has public read/write access, and counters can't be set per-user. For a production app it would be more appropriate to set user access rules.

## State management

The same functionality is replicated in four different pages accessible via the bottom navigation bar, using different state management techniques:

* [`setState`](https://docs.flutter.io/flutter/widgets/State/setState.html)
* [`StreamBuilder`](https://docs.flutter.io/flutter/widgets/StreamBuilder-class.html)
* [`scoped_model`](https://pub.dartlang.org/packages/scoped_model)
* [`redux`](https://pub.dartlang.org/packages/redux)

## Running the project

You need to register the project with your own Firebase account.

- Use `com.musevisions.multipleCountersFlutter` as your bundle / application ID when generating the Firebase project.

- Download the `ios/Runner/GoogleService-Info.plist` and `android/app/google-services.json` files as needed.

### For more articles and video tutorials, check out [Coding With Flutter](https://codingwithflutter.com/).

### [License: MIT](LICENSE.md)
