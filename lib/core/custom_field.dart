import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatelessWidget {
  final int? maxLines;
  final IconData? icon;
  final String? suffix;
  final String? label;
  final List<TextInputFormatter>? formatters;
  final TextEditingController? controller;
  const CustomTextField({super.key, this.maxLines, this.icon, this.suffix, this.label, this.controller, this.formatters});

  @override
  Widget build(BuildContext context,) {
    return TextFormField(
      inputFormatters: formatters,
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
    );
  }
}

class ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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