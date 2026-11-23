import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/utils/currency_formatter.dart';

class ReportsSavingsCard extends StatelessWidget {
  final bool hasHistory;
  final double savings;
  final double savingsRate;

  const ReportsSavingsCard({
    super.key,
    required this.hasHistory,
    required this.savings,
    required this.savingsRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9EDF1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ahorro este mes',
                style: TextStyle(color: Color(0xFF6F7A86), fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                savings.toColombianCurrency(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17212B),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: hasHistory && savings > 0
                  ? const Color(0xFFEAF9F0)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${savingsRate.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: hasHistory && savings > 0
                    ? const Color(0xFF2ECC71)
                    : const Color(0xFF6F7A86),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
