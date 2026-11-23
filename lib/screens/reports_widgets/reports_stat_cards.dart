import 'package:flutter/material.dart';

class ReportsStatCards extends StatelessWidget {
  final double savingsRate;
  final double monthlyGoal;

  const ReportsStatCards({
    super.key,
    required this.savingsRate,
    required this.monthlyGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Tasa de ahorro',
            value: '${savingsRate.toStringAsFixed(1)}%',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Meta mensual',
            value: '\$${monthlyGoal.toStringAsFixed(2)}',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EDF1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6F7A86), fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF17212B),
            ),
          ),
        ],
      ),
    );
  }
}
