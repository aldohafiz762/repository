import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/animRoute.dart';
import 'package:project_tugas_akhir_copy/constant.dart';
import 'package:project_tugas_akhir_copy/getStarted.dart';
import 'package:project_tugas_akhir_copy/splashscreen.dart';
import 'package:project_tugas_akhir_copy/login.dart';
import 'package:project_tugas_akhir_copy/transisi_dari_login.dart';
import 'package:project_tugas_akhir_copy/dashboard.dart';
import 'package:project_tugas_akhir_copy/mesin1/m1home.dart';
import 'package:project_tugas_akhir_copy/mesin1/m1inputparam.dart';
import 'package:project_tugas_akhir_copy/mesin1/m1cost.dart';
import 'package:project_tugas_akhir_copy/mesin1/m1oee.dart';
import 'package:project_tugas_akhir_copy/mesin1/m1monitoring.dart';
import 'package:project_tugas_akhir_copy/mesin1/m1stock.dart';
import 'package:project_tugas_akhir_copy/mesin1/m1alarm.dart';
import 'package:project_tugas_akhir_copy/preventive.dart';
import 'package:project_tugas_akhir_copy/preventive_history.dart';
import 'package:project_tugas_akhir_copy/report.dart';
import 'package:project_tugas_akhir_copy/akun.dart';
import 'package:project_tugas_akhir_copy/tambahuser.dart';

//ROUTING HALAMAN-------------------------------------------------------------------------------------------------------------
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Starting Page--------------------------------------------------------------------------------------------------------
      case mysplash:
        return MaterialPageRoute(builder: (context) => Splash());
      case mygetstarted:
        var au = settings.arguments as String;
        return BouncyPageRoute(page: GetStarted(au));
      case mylogin:
        var a = settings.arguments as String;
        return BouncyPageRoute(page: Login(a));
      case mytransisi:
        var at = settings.arguments as String;
        return MaterialPageRoute(builder: (context) => FromLogin(at));
      case mydashboard:
        var b = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) =>  dashboard(b),);
        return BouncyPageRoute(page: Dashboard(b));
      case mym1home:
        var c = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => m1home(c),);
        return BouncyPageRoute(page: M1home(c));
      case mym1param:
        var i = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => m1param(i),);
        return BouncyPageRoute(page: M1param(i));
      case mym1cost:
        var k = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => m1cost(k),);
        return BouncyPageRoute(page: M1cost(k));
      case mym1oee:
        var m = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => m1oee(m),);
        return BouncyPageRoute(page: M1oee(m));
      case mym1monitoring:
        var p = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => m1monitoring(p),);
        return BouncyPageRoute(page: M1monitoring(p));
      case mym1stock:
        var q = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => m1stock(q),);
        return BouncyPageRoute(page: M1stock(q));
      case mym1alarm:
        var j = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => m1alarm(j),);
        return BouncyPageRoute(page: M1alarm(j));
      case mypreventive:
        var h = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => preventive(h),);
        return BouncyPageRoute(page: Preventive(h));
      case myhistoriPrev:
        var aw = settings.arguments as String;
        return BouncyPageRoute(page: PreventiveHistory(aw));
      case myreport:
        var hk = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => report(h),);
        return BouncyPageRoute(page: Report(hk));
      case myakun:
        var g = settings.arguments as String;
        // return MaterialPageRoute(builder:(context) => akun(g),);
        return BouncyPageRoute(page: Akun(g));
      case mytambahuser:
        var as = settings.arguments as String;
        // return MaterialPageRoute(builder: (context) => tambahuser(as));
        return BouncyPageRoute(page: Tambahuser(as));

      default:
    }
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          body: Center(child: Text("No Pages Available")),
        );
      },
    );
  }
}
