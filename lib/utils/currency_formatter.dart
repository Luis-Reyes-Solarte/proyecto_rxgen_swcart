import 'package:flutter/services.dart';

class CurrencyFormatter {
  /// Formatea un número a estilo colombiano: 1000000 -> 1'000.000
  static String format(num value, {bool includeSymbol = true}) {
    final bool isNegative = value < 0;
    final absValue = value.abs();

    // Separar parte entera y decimal (solo si tiene decimales distintos de 0)
    final parts = absValue.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final formattedInt = _addColombianSeparators(integerPart);
    final decimals = decimalPart == '00' ? '' : ',$decimalPart';
    final prefix = '${isNegative ? '-' : ''}${includeSymbol ? '\$' : ''}';

    return '$prefix$formattedInt$decimals';
  }

  /// Convierte texto formateado (ej. "1'250.000") de vuelta a double (1250000.0)
  static double parse(String formattedText) {
    final cleaned = formattedText
        .replaceAll('\$', '')
        .replaceAll("'", '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  static String _addColombianSeparators(String digits) {
    if (digits.length <= 3) return digits;

    final buffer = StringBuffer();
    int count = 0;

    for (int i = digits.length - 1; i >= 0; i--) {
      buffer.write(digits[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        // Cada 6 dígitos va apóstrofo de millón ('), cada 3 va punto de mil (.)
        buffer.write(count % 6 == 0 ? "'" : '.');
      }
    }
    return buffer.toString().split('').reversed.join();
  }
}

/// Formateador en vivo para los TextField de Monto
class ColombianCurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Dejar solo dígitos
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final number = int.parse(digitsOnly);
    final formatted = CurrencyFormatter.format(number, includeSymbol: false);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Extensión para usar directamente en tus widgets: balance.toColombianCurrency()
extension NumCurrencyExtension on num {
  String toColombianCurrency({bool includeSymbol = true}) {
    return CurrencyFormatter.format(this, includeSymbol: includeSymbol);
  }
}
