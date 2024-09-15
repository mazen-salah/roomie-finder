import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/fragment/RFAccountFragment.dart';
import 'package:roomie_finder/fragment/RFHomeFragment.dart';
import 'package:roomie_finder/fragment/RFSettingsFragment.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFImages.dart';
import 'package:roomie_finder/utils/RFWidget.dart';
import 'package:roomie_finder/views/RFSearchDetailScreen.dart';

class RFHomeScreen extends StatefulWidget {
  const RFHomeScreen({super.key});

  @override
  State createState() => _RFHomeScreenState();
}

class _RFHomeScreenState extends State<RFHomeScreen> {
  int _selectedIndex = 0;

  final _pages = [
    const RFHomeFragment(),
     RFSearchDetailScreen(),
    const RFSettingsFragment(),
    const RFAccountFragment(),
  ];

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedLabelStyle: boldTextStyle(size: 14),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 22),
          label: 'Home',
          activeIcon:
              Icon(Icons.home_outlined, color: rfPrimaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: rfSearch.iconImage(),
          label: 'Search',
          activeIcon: rfSearch.iconImage(iconColor: rfPrimaryColor),
        ),
        BottomNavigationBarItem(
          icon: rfSetting.iconImage(size: 22),
          label: 'Settings',
          activeIcon: rfSetting.iconImage(iconColor: rfPrimaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: rfPerson.iconImage(),
          label: 'Account',
          activeIcon: rfPerson.iconImage(iconColor: rfPrimaryColor),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(rfPrimaryColor,
        statusBarIconBrightness: Brightness.light);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomTab(),
      body: Center(child: _pages.elementAt(_selectedIndex)),
    );
  }
}
