import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:k8todonote/home_screen/home_screen.dart';
import 'package:k8todonote/pages/webview/webview.dart';
import 'package:k8todonote/stream.dart';

import 'firebase_options.dart';

const keyIsActive = 'isActive';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  // open a box
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isActive = FirebaseRemoteConfig.instance.getBool(keyIsActive);
  String url = FirebaseRemoteConfig.instance.getString('url');
  StreamRemoteConfig stream = StreamRemoteConfig();

  @override
  void initState() {
    stream.setUpRemoteConfig();

    print('---------isActive');
    print(isActive);
    super.initState();
  }

  @override
  void dispose() {
    stream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: isActive,
      stream: stream.isActiveRealtime,
      builder: (context, snapshot) {
        print('--------$url');
        print(snapshot.data);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: (snapshot.hasData && (snapshot.data == true))
              ? Scaffold(
                  body: SizedBox(
                    width: double.infinity,
                    child: K8HomePage(
                      url: url,
                      title: 'K8 Home',
                    ),
                  ),
                )
              : const HomeScreen(),
        );
      },
    );
  }
}
