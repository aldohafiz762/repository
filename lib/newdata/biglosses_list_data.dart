import 'package:project_tugas_akhir_copy/models/bigloss_model.dart';
import 'package:project_tugas_akhir_copy/services/bigloss_service.dart';

class MealsListData {
  MealsListData(
      {this.imagePath = '',
      this.titleTxt = '',
      this.startColor = '',
      this.endColor = '',
      this.meals,
      this.kacl,
      this.unit = ''});

  String unit;
  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? meals;
  dynamic kacl;

  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
      imagePath: 'images/isometric-business-people-meeting.png',
      titleTxt: 'Setup',
      unit: '',
      meals: <String>['Change tools,', 'warming-up,', 'briefing session'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    MealsListData(
      imagePath: 'images/illustration-characters-fixing-cogwheel.png',
      titleTxt: 'Breakdown',
      unit: '',
      meals: <String>['Equipment suddenly', 'breakdown,', 'tool damage'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    MealsListData(
      imagePath: 'images/postponed-concept-with-man-illustration.png',
      titleTxt: 'Timestop',
      unit: '',
      meals: <String>['Inspection,', 'cleaning up,', 'undetected sensor'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    MealsListData(
      imagePath: 'images/risk-management-concept-illustration.png',
      titleTxt: 'Speedloss',
      unit: '',
      meals: <String>['Longtime usage,', 'work under ', 'condition'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
    MealsListData(
      imagePath: 'images/sampah.png',
      titleTxt: 'Reject',
      unit: 'Unit',
      meals: <String>['Low air pressure,', 'jammed,', 'and so on'],
      startColor: '#f6b26b',
      endColor: '#b45f06',
    ),
    MealsListData(
      imagePath:
          'images/startup-construction-development-3d-thin-line-art-style-design-concept-isometric-illustration.png',
      titleTxt: 'Startup Reject',
      unit: 'Unit',
      meals: <String>['Test product'],
      startColor: '#c27ba0',
      endColor: '#741b47',
    ),
  ];

  static Future<void> loadData() async {
    List<DashBLModel> dashData = await DashBL.dashBL();
    String toDateTime(int value) {
      final duration = Duration(seconds: value);
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      final seconds = duration.inSeconds.remainder(60);
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    if (dashData.isNotEmpty && dashData[0].state == 1) {
      tabIconsList[0].kacl = toDateTime(dashData[0].setup.toInt());
      tabIconsList[1].kacl = toDateTime(dashData[0].breakdown.toInt());
      tabIconsList[2].kacl = toDateTime(dashData[0].stoppage.toInt());
      tabIconsList[3].kacl = toDateTime(dashData[0].speed.toInt());
      tabIconsList[4].kacl = dashData[0].reject.toInt();
      tabIconsList[5].kacl = dashData[0].startup.toInt();
    } else {
      tabIconsList[0].kacl = "--:--:--";
      tabIconsList[1].kacl = "--:--:--";
      tabIconsList[2].kacl = "--:--:--";
      tabIconsList[3].kacl = "--:--:--";
      tabIconsList[4].kacl = "--";
      tabIconsList[5].kacl = "--";
    }
  }
}
