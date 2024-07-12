import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_doctor/screen/HomPage.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import 'ProfilePage.dart';

class HomeFunction extends StatefulWidget {
  const HomeFunction({Key? key}) : super(key: key);

  @override
  State<HomeFunction> createState() => _HomeFunctionState();
}

class _HomeFunctionState extends State<HomeFunction> {

int selectedIndex = 0;
PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomePage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          backgroundColor: Colors.white,
          onItemSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
          },
          selectedIndex: selectedIndex,
          barItems: [
            BarItem(
              filledIcon: Icons.home_filled,
              outlinedIcon: Icons.home_outlined,
            ),
            BarItem(
                filledIcon: Icons.account_circle,
                outlinedIcon: Icons.account_circle_outlined),
          ],
        ),
      ),
    );
  }
}
