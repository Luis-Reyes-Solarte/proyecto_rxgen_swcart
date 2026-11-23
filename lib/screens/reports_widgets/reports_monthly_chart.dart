import 'package:flutter/material.dart';

class ReportsMonthlyChart extends StatelessWidget {
  final bool hasHistory;
  final double savings;

  const ReportsMonthlyChart({
    super.key,
    required this.hasHistory,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EDF1)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar('Abr', 0.0),
                _buildBar('May', 0.0),
                _buildBar('Jun', 0.0),
                _buildBar('Jul', 0.0),
                _buildBar('Ago', 0.0),
                _buildBar('Sep', hasHistory && savings > 0 ? 0.65 : 0.0),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasHistory
                ? 'Balance positivo acumulado del periodo actual'
                : 'Aún no hay historial de ahorro para graficar',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double heightFactor) {
    final bool hasData = heightFactor > 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: hasData ? 60 * heightFactor : 8,
          width: 16,
          decoration: BoxDecoration(
            color: hasData ? const Color(0xFF2ECC71) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6F7A86)),
        ),
      ],
    );
  }
}
