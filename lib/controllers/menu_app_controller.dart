import 'package:flutter/material.dart';

// controllers/menu_app_controller.dart ichiga qo'shing:
class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0; // Tanlangan sahifa indeksi

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  int get selectedIndex => _selectedIndex;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  // Sahifani o'zgartirish funksiyasi
  void setMenuIndex(int index) {
    _selectedIndex = index;
    notifyListeners(); // UI-ga o'zgarishni xabar qiladi
  }
}
