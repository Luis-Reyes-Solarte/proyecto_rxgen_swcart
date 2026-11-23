import 'package:flutter/material.dart';

class InicioRecentMovements extends StatelessWidget {
  const InicioRecentMovements({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Últimos movimientos',
                  style: TextStyle(
                    color: const Color(0xFF17212B),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Ver todos',
                  style: TextStyle(
                    color: const Color(0xFF6F7A86),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const _MovementItem(
            iconBg: Color(0xFFF6F8FA),
            title: 'Walmart',
            subtitle: 'Hoy · Comida',
            amount: '−\$86.40',
            amountColor: Color(0xFFE74C3C),
            textWidth: 232,
          ),
          const _MovementItem(
            iconBg: Color(0xFFEAF9F0),
            title: 'Nómina',
            subtitle: 'Ayer · Ingreso',
            amount: '+\$2,450',
            amountColor: Color(0xFF2ECC71),
            textWidth: 232,
          ),
          const _MovementItem(
            iconBg: Color(0xFFF6F8FA),
            title: 'Uber',
            subtitle: '18 sep · Transporte',
            amount: '−\$18.90',
            amountColor: Color(0xFFE74C3C),
            textWidth: 234,
          ),
          const _MovementItem(
            iconBg: Color(0xFFF6F8FA),
            title: 'Netflix',
            subtitle: '17 sep · Suscripciones',
            amount: '−\$15.49',
            amountColor: Color(0xFFE74C3C),
            textWidth: 234,
          ),
        ],
      ),
    );
  }
}

class _MovementItem extends StatelessWidget {
  final Color iconBg;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final double textWidth;

  const _MovementItem({
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    required this.textWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          Container(
            width: 38,
            height: 38,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: iconBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  SizedBox(
                    width: textWidth,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: const Color(0xFF17212B),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: textWidth,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: const Color(0xFF6F7A86),
                        fontSize: 11,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
