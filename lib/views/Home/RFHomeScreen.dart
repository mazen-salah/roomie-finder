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

  final List<Widget> _pages = [
    const RFHomeFragment(),
    const RFSearchDetailScreen(),
    const RFSettingsFragment(),
    const RFAccountFragment(),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setStatusBarColor(rfPrimaryColor, statusBarIconBrightness: Brightness.light);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required Widget icon,
    required String label,
    required Widget activeIcon,
  }) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
      activeIcon: activeIcon,
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedLabelStyle: boldTextStyle(size: 14),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      type: BottomNavigationBarType.fixed,
      items: [
        _buildBottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined, size: 22),
          label: 'Home',
          activeIcon: const Icon(Icons.home_outlined, color: rfPrimaryColor, size: 22),
        ),
        _buildBottomNavigationBarItem(
          icon: rfSearch.iconImage(),
          label: 'Search',
          activeIcon: rfSearch.iconImage(iconColor: rfPrimaryColor),
        ),
        _buildBottomNavigationBarItem(
          icon: rfSetting.iconImage(size: 22),
          label: 'Settings',
          activeIcon: rfSetting.iconImage(iconColor: rfPrimaryColor, size: 22),
        ),
        _buildBottomNavigationBarItem(
          icon: rfPerson.iconImage(),
          label: 'Account',
          activeIcon: rfPerson.iconImage(iconColor: rfPrimaryColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Center(child: _pages[_selectedIndex]),
    );
  }
}
