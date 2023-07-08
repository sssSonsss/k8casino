import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';

const keyIsActive = 'isActive';

class StreamRemoteConfig {
  StreamController<bool> streamController = StreamController<bool>();
  // StreamSubscription? _streamSubscription;
  bool? isActive;

  Stream<bool> get isActiveRealtime => streamController.stream;

  Future<void> setUpRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 5),
        ),
      );

      await remoteConfig.fetchAndActivate();
      // if (_streamSubscription != null) {
      //   await _streamSubscription?.cancel();
      //   _streamSubscription = null;
      // }
      // _streamSubscription = remoteConfig.onConfigUpdated.listen(
      //   (RemoteConfigUpdate event) async {
      //     await remoteConfig.activate();
      //     streamController.add(getRemoteConfig(event.updatedKeys.join(', ')));
      //   },
      //   onError: (e) {
      //     print('remote config error: ${e.toString()}');
      //   },
      // );
    } catch (e) {
      print('log firebase');
      print(e.toString());
    }
  }

  getRemoteConfig(String key) {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    final result = remoteConfig.getBool(key);

    return result;
  }

  void dispose() {
    // _streamSubscription?.cancel();
    streamController.close();
  }
}
