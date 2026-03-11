import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_time_app/controller/navigation_controller.dart';
import 'package:prayer_time_app/view/home_screen.dart';
import 'package:prayer_time_app/view/qibla_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();
    
    final screens = [
      const HomeScreen(),
      const QiblaScreen(),
    ];

    return Scaffold(
      body: Obx(() => screens[navigationController.currentIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: navigationController.currentIndex.value,
        onTap: (index) => navigationController.changeIndex(index),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF10B981),
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Qibla',
          ),
        ],
      )),
    );
  }
}

