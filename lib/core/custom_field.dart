import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatelessWidget {
  final int? maxLines;
  final IconData? icon;
  final Widget? suffixIcon;
  final Function(String?)? onSubmitted;
  final String? suffix;
  final String? label;
  final Function(String)? onChange;
  final List<TextInputFormatter>? formatters;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  const CustomTextField(
      {super.key,
      this.maxLines,
      this.icon,
      this.suffix,
      this.label,
      this.controller,
      this.formatters,
      this.validator,
      this.suffixIcon,
      this.onSubmitted,
      this.onChange});

  @override
  Widget build(
    BuildContext context,
  ) {
    return TextFormField(
      onChanged: onChange,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      inputFormatters: formatters,
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          suffixText: suffix,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
          suffixIcon: suffixIcon),
    );
  }
}

class AppValidators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName maydonini to\'ldiring';
    }
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.isEmpty) return 'Narxni kiriting';
    String cleanValue = value.replaceAll(RegExp(r'\s+'), '');
    print(cleanValue);
    if (int.tryParse(cleanValue) == null) {
      return 'Faqat raqam kiriting';
    }
    return null;
  }

  // 3. Telefon raqami uchun (+998 formatida)
  static String? phone(String? value) {
    String pattern = r'^\+998\d{9}$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) return 'Telefon raqamini kiriting';
    if (!regex.hasMatch(value)) return 'Format noto\'g\'ri (+998XXXXXXXXX)';
    return null;
  }

  static String? quantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Soni (miqdori)ni kiriting';
    }
    String cleanValue = value.replaceAll(' ', '');
    final number = int.tryParse(cleanValue);

    if (number == null) {
      return 'Faqat butun son kiriting';
    }

    if (number <= 0) {
      return 'Soni 0 dan katta bo\'lishi kerak';
    }

    return null; // Hammasi to'g'ri bo'lsa
  }
}

class ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    // Faqat raqamlarni olamiz
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedText.isEmpty) return const TextEditingValue();

    final int value = int.parse(cleanedText);
    final formatter = NumberFormat('#,###', 'uz');
    // Bo'sh joy bilan formatlaymiz
    String formattedText = formatter.format(value).replaceAll(',', ' ');

    return TextEditingValue(
      text: formattedText,
      // Kursorni har doim matn oxirida to'g'ri saqlaydi
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
