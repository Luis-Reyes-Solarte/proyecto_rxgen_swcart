import 'package:flutter/material.dart';

class IncomeAmountField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;

  const IncomeAmountField({
    super.key,
    required this.controller,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MONTO',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '\$ ',
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCurrency,
                  items: ['MXN', 'USD', 'COP'].map((curr) {
                    return DropdownMenuItem(
                      value: curr,
                      child: Text(curr, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) => onCurrencyChanged(val ?? selectedCurrency),
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
