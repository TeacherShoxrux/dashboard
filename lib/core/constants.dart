import 'package:flutter/services.dart';

class AppConstants {
  static final priceFilter = FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'));
}