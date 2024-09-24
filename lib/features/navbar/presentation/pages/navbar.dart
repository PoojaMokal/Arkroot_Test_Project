import 'package:chat_gpt_demo/core/services/dynamo_db_service.dart';
import 'package:chat_gpt_demo/features/chat_gpt/presentation/pages/chat_gpt_screen.dart';
import 'package:chat_gpt_demo/features/navbar/presentation/mixins/navbar_mixin.dart';
import 'package:chat_gpt_demo/features/profile/profile_screen.dart';
import 'package:chat_gpt_demo/utils/gesturedetector_util.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with NavbarMixin {
  List<Widget>? pages;
  List<BottomNavigationBarItem>? items;

  int _index = 0;

  DateTime now = DateTime.now();
  DateTime? currentBackPressTime;

  final titleList = ["Profiles", "Post Job", "Hot Jobs", "Plans"];

  bool loggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchCurrentUserAttributes();

    DynamoService().createTable();

    pages = [
      const ChatGptScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: GestureDetectorUtil.onScreenTap,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBarUtil.primaryAppBar(setIndex: setIndex),
        // floatingActionButton: _floatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _index = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: _index,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.chat_bubble),
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat GPT',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person_2),
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
          ],
        ),

        body: pages![_index],
      ),
    );
  }
}
