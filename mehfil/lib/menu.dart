import 'package:flutter/material.dart';
import 'package:mehfil/tickets.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'home_screen.dart';


class MenuScreen extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  MenuScreen({super.key});

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
       const TicketsScreen(),
      const FavouriteScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: const Color(0xffF20587),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.confirmation_number),
        title: ("Tickets"),
        activeColorPrimary: const Color(0xffF20587),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite),
        title: ("Favourite"),
        activeColorPrimary: const Color(0xffF20587),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: const Color(0xffF20587),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: const Color(0xff26141C), // Default background color.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when the keyboard appears.
      stateManagement: true, // Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: const Color(0xff26141C),
      ),
      // popActionScreens: PopActionScreensType.all,
      navBarStyle: NavBarStyle.style13, // Choose the nav bar style with this property.
    );
  }
}


// class TicketsScreen extends StatelessWidget {
//   const TicketsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: Text("Tickets Screen")),
//     );
//   }
// }

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Favourite Screen")),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Profile Screen")),
    );
  }
}
