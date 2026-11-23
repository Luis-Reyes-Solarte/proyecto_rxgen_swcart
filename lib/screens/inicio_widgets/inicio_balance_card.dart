import 'package:flutter/material.dart';

class InicioBalanceCard extends StatelessWidget {
  const InicioBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFF111820),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x1217212B),
            blurRadius: 18,
            offset: Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            'Balance General',
            style: TextStyle(
              color: const Color(0xFFAEB7C0),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '\$24,580.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Expanded(
                  child: _BalanceMetric(
                    label: '↑ Ingresos',
                    value: '\$18,420',
                    valueColor: const Color(0xFF2ECC71),
                  ),
                ),
                Expanded(
                  child: _BalanceMetric(
                    label: '↓ Gastos',
                    value: '\$9,840',
                    valueColor: const Color(0xFFE74C3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _BalanceMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 3,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFFAEB7C0),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
