import 'package:intl/intl.dart';

extension PriceFormatter on String {
  String toPrice() {
    try {
      // Keep only numbers and decimal point
      final cleanPrice = replaceAll(RegExp(r'[^0-9.]'), '');

      if (cleanPrice.isEmpty) {
        return 'TSh 0';
      }

      final doubleValue = double.tryParse(cleanPrice) ?? 0;

      final formatter = NumberFormat('#,###');
      final formatted = formatter.format(doubleValue);

      return 'TSh $formatted';
    } catch (e) {
      return 'TSh $this';
    }
  }
}