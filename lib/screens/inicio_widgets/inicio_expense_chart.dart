import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';
import 'package:proyecto_rxgen_swcart/utils/currency_formatter.dart';

class InicioExpenseChart extends StatelessWidget {
  const InicioExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final financeState = FinanceState.instance;

    return ListenableBuilder(
      listenable: financeState,
      builder: (context, _) {
        final totalExpense = financeState.totalExpense;
        final catTotals = financeState.expensesByCategory;
        final hasExpenses = totalExpense > 0;

        String pctFor(String category) {
          if (!hasExpenses) return '0%';
          final pct = ((catTotals[category] ?? 0.0) / totalExpense) * 100;
          return '${pct.toStringAsFixed(0)}%';
        }

        return Container(
          width: double.infinity,
          height: 142,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
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
                          hasExpenses
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
                          style: TextStyle(
                            color: Color(0xFF6F7A86),
                            fontSize: 11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          totalExpense.toColombianCurrency(),
                          style: const TextStyle(
                            color: Color(0xFF17212B),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    _LegendRow(
                      color: hasExpenses
                          ? const Color(0xFF2ECC71)
                          : Colors.grey.shade300,
                      label: 'Comida',
                      percent: pctFor('Comida'),
                    ),
                    _LegendRow(
                      color: hasExpenses
                          ? const Color(0xFFE74C3C)
                          : Colors.grey.shade300,
                      label: 'Transporte',
                      percent: pctFor('Transporte'),
                    ),
                    _LegendRow(
                      color: hasExpenses
                          ? const Color(0xFFF4B942)
                          : Colors.grey.shade300,
                      label: 'Hogar',
                      percent: pctFor('Hogar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String percent;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: ShapeDecoration(color: color, shape: const OvalBorder()),
        ),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6F7A86),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          percent,
          style: const TextStyle(
            color: Color(0xFF17212B),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
