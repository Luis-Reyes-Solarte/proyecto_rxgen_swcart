import 'package:flutter/material.dart';

class InicioBottomNav extends StatelessWidget {
  const InicioBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE9EDF1)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _NavItem(label: 'Inicio', selected: true),
          _NavItem(label: 'Gastos', selected: false),
          _NavItem(label: 'Compras', selected: false),
          _NavItem(label: 'Reportes', selected: false),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool selected;

  const _NavItem({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4,
        children: [
          Container(
            width: 21,
            height: 21,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Stack(),
          ),
          Text(
            label,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF17212B)
                  : const Color(0xFFAAB2BA),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Container(
            width: selected ? 18 : null,
            height: 3,
            decoration: ShapeDecoration(
              color: selected ? const Color(0xFF2ECC71) : const Color(0xFF2ECC71),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
