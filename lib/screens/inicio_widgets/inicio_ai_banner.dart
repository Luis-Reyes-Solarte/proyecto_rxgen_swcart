import 'package:flutter/material.dart';

class InicioAiBanner extends StatelessWidget {
  const InicioAiBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFF5F0FA),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE7D7EE)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Container(
            width: 30,
            height: 30,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFF9B59B6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 286,
            child: Text(
              '💡 IA: Detectamos un aumento del 12% en Suscripciones respecto al mes pasado. ¿Quieres revisarlo?',
              style: TextStyle(
                color: const Color(0xFF17212B),
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
