import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:k8todonote/alarm/screens/home.dart';
import 'package:k8todonote/home_screen/keep_alive_page.dart';
import 'package:k8todonote/pages/home_page.dart';
import 'package:k8todonote/style/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    const KeepAlivePage(
      child: ToDoScreen(),
    ),
    const KeepAlivePage(
      child: ExampleAlarmHomeScreen(),
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 12),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: AppColor.yellow,
            iconSize: 24,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(
                icon: Icons.edit_note_sharp,
                text: 'Note',
                hoverColor: Colors.grey,
              ),
              GButton(
                icon: Icons.alarm,
                text: 'Alarm',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
