import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';

const keyIsActive = 'isActive';

class StreamRemoteConfig {
  StreamController<bool> streamController = StreamController<bool>();
  StreamSubscription? _streamSubscription;
  bool? isActive;

  Stream<bool> get isActiveRealtime => streamController.stream;

  Future<FirebaseRemoteConfig> setUpRemotConfig() async {
    final FirebaseRemoteConfig remoteConfig = await getInitRemote();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 5),
    ));
    _streamSubscription =
        remoteConfig.onConfigUpdated.listen((RemoteConfigUpdate event) async {
      await getInitRemote();
      streamController.add(getRemoteConfig(event.updatedKeys.join(', ')));
    });
    return remoteConfig;
  }

  getRemoteConfig(String key) {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    final result = remoteConfig.getBool(key);

    return result;
  }

  Future<FirebaseRemoteConfig> getInitRemote() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.fetch();
    await remoteConfig.activate();

    return remoteConfig;
  }

  void dispose() {
    _streamSubscription?.cancel();
    streamController.close();
  }
}
