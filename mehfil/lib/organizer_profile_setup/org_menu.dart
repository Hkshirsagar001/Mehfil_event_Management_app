import 'package:flutter/material.dart';
import 'package:mehfil/organizer_profile_setup/dashboard.dart';
import 'package:mehfil/organizer_profile_setup/qrScanner.dart';

class MyMenu extends StatefulWidget {
  final String uid; // Accept the UID
  const MyMenu({super.key, required this.uid});

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  int _selectedIndex = 0; // Track the currently selected tab index

  // List of widgets (screens) for each tab
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      Dashboard(uid: widget.uid),
      const QRCodeScannerScreen(),
      const ProfileScreen(),
    ];
  }

  // Navigation function to update the selected tab index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff26141C), // Set the background color
      body: _screens[_selectedIndex], // Display the current screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlight the selected tab
        onTap: _onItemTapped, // Handle tab selection
        backgroundColor: const Color(0xff26141C), // Background color
        selectedItemColor: const Color(0xffF20587), // Active tab color
        unselectedItemColor: Colors.grey, // Inactive tab color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Sample Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff26141C),
      body: Center(
        child: Text(
          "Profile Screen",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
