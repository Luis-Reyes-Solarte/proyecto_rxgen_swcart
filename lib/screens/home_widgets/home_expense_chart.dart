import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/utils/currency_formatter.dart';

class HomeExpenseChart extends StatelessWidget {
  final double totalExpense;
  final Map<String, double> catTotals;

  const HomeExpenseChart({
    super.key,
    required this.totalExpense,
    required this.catTotals,
  });

  double _pctFor(String cat) {
    if (totalExpense <= 0) return 0;
    return ((catTotals[cat] ?? 0.0) / totalExpense) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 132,
          height: 132,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 16,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    totalExpense > 0
                        ? const Color(0xFF2ECC71)
                        : Colors.grey.shade200,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Gastos',
                    style: TextStyle(color: Color(0xFF6F7A86), fontSize: 11),
                  ),
                  Text(
                    totalExpense.toColombianCurrency(),
                    style: const TextStyle(
                      color: Color(0xFF17212B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryLegendRow(
                label: 'Comida',
                percentage: '${_pctFor('Comida').toStringAsFixed(0)}%',
                dotColor: totalExpense > 0
                    ? const Color(0xFF2ECC71)
                    : Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              _CategoryLegendRow(
                label: 'Transporte',
                percentage: '${_pctFor('Transporte').toStringAsFixed(0)}%',
                dotColor: totalExpense > 0
                    ? const Color(0xFFE74C3C)
                    : Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              _CategoryLegendRow(
                label: 'Hogar',
                percentage: '${_pctFor('Hogar').toStringAsFixed(0)}%',
                dotColor: totalExpense > 0
                    ? const Color(0xFFF4B942)
                    : Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryLegendRow extends StatelessWidget {
  final String label;
  final String percentage;
  final Color dotColor;

  const _CategoryLegendRow({
    required this.label,
    required this.percentage,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF6F7A86), fontSize: 12),
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            color: Color(0xFF17212B),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
