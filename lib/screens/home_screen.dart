import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './chats_screen.dart';
import 'package:chat_app/helpers/database_service.dart';
import 'package:chat_app/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    () async {
      String? token = await FirebaseMessaging.instance.getToken();
      await FirebaseMessaging.instance.subscribeToTopic("story");
      await DataBase().setDeviceId(token ?? "");
    }();
  }

  selectScreen() {
    switch (_currentIndex) {
      case 0:
        return const ChatsScreen(
          key: ValueKey('chats_screen'),
        );
      case 1:
        return const SettingScreen();
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: selectScreen(),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        height: 65,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black12,
              )
            ]),
        child: NavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          children: [
            NavigationBarItem(
              icon: CupertinoIcons.chat_bubble,
              activeIcon: CupertinoIcons.chat_bubble_text_fill,
              label: 'Chats',
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
            NavigationBarItem(
              icon: CupertinoIcons.settings,
              activeIcon: CupertinoIcons.settings,
              label: 'Settings',
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  final List<NavigationBarItem> children;
  final int currentIndex;
  final Function onTap;

  const NavigationBar({
    Key? key,
    required this.currentIndex,
    required this.children,
    required this.onTap,
  }) : super(key: key);

  currentActiveItem(index) {
    if (currentIndex == index) {
      children[index].isActive = true;
    }
    return children[index];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children
          .map(
            (item) => GestureDetector(
              onTap: () {
                onTap(children.indexOf(item));
              },
              child: currentActiveItem(children.indexOf(item)),
            ),
          )
          .toList(),
    );
  }
}

// ignore: must_be_immutable
class NavigationBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Color activeColor;
  var isActive = false;

  NavigationBarItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? activeColor : Colors.grey.shade600,
            size: isActive ? 26 : 25,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: isActive ? 15 : 14,
              color: isActive ? activeColor : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
