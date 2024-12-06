import 'package:flutter/material.dart';
import 'package:oecd_app_dir/screens/chat.dart';
import 'package:oecd_app_dir/screens/calendar.dart';
import 'package:oecd_app_dir/screens/life.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();

  final List<Widget> screens = [
    const CalendarScreen(),
    const ChatScreen(),
    const LifeScreen(),
  ];

  int _screenIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: screens,
        onPageChanged: (index) {
          setState(() {
            _screenIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _screenIndex,
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          setState(() {
            _screenIndex = index;
          });
          pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.sunny), label: 'Life'),
        ],
      ),
    );
  }
}
