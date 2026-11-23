import 'package:flutter/material.dart';

class InicioExpenseChart extends StatelessWidget {
  const InicioExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 142,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          Container(
            width: 132,
            height: 132,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 132,
                    height: 132,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF2ECC71),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 132,
                    height: 132,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE74C3C),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 132,
                    height: 132,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF4B942),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Gastos',
                        style: TextStyle(
                          color: const Color(0xFF6F7A86),
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '\$9.8k',
                        style: TextStyle(
                          color: const Color(0xFF17212B),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
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
                spacing: 12,
                children: const [
                  _LegendRow(
                    color: Color(0xFF2ECC71),
                    label: 'Comida',
                    labelWidth: 147,
                    percent: '54%',
                  ),
                  _LegendRow(
                    color: Color(0xFFE74C3C),
                    label: 'Transporte',
                    labelWidth: 148,
                    percent: '24%',
                  ),
                  _LegendRow(
                    color: Color(0xFFF4B942),
                    label: 'Hogar',
                    labelWidth: 148,
                    percent: '22%',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final double labelWidth;
  final String percent;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.labelWidth,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: ShapeDecoration(color: color, shape: OvalBorder()),
          ),
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF6F7A86),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            percent,
            style: TextStyle(
              color: const Color(0xFF17212B),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
