import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:project_tugas_akhir_copy/constant.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(Home());
}

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LOGIN',
      // home: splash() ,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: mysplash,
    );
  }
}
