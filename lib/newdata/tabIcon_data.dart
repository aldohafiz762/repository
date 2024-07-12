import 'package:flutter/material.dart';

class TabIconData {
  TabIconData(
      {this.imagePath = '',
      this.index = 0,
      this.selectedImagePath = '',
      this.isSelected = false,
      this.animationController,
      this.selectedText = ''});

  String selectedText;
  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'images/icons8-dashboard-48.png',
      selectedImagePath: 'images/icons8-dashboards-48.png',
      selectedText: 'Home',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'images/icons8-report-48 (1).png',
      selectedImagePath: 'images/icons8-report-48.png',
      selectedText: 'Report',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'images/icons8-bell-48.png',
      selectedImagePath: 'images/icons8-bell-48 (1).png',
      selectedText: 'Alarm',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'images/icons8-avatar-48.png',
      selectedImagePath: 'images/icons8-avatar-48 (1).png',
      selectedText: 'Alarm',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'images/user.png',
      selectedImagePath: 'images/user (1).png',
      selectedText: 'Account',
      index: 4,
      isSelected: false,
      animationController: null,
    ),
  ];
}
