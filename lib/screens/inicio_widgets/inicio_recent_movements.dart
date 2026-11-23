import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';
import 'package:proyecto_rxgen_swcart/utils/currency_formatter.dart';

class InicioRecentMovements extends StatelessWidget {
  const InicioRecentMovements({super.key});

  @override
  Widget build(BuildContext context) {
    final financeState = FinanceState.instance;

    return ListenableBuilder(
      listenable: financeState,
      builder: (context, _) {
        final transactions = financeState.transactions;

        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Últimos movimientos',
                    style: TextStyle(
                      color: Color(0xFF17212B),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Ver todos',
                    style: TextStyle(
                      color: Color(0xFF6F7A86),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (transactions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE9EDF1)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 36,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aún no hay movimientos',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...transactions.take(5).map((tx) {
                  final isIncome = tx.type == TransactionType.income;
                  return _MovementItem(
                    iconBg: isIncome
                        ? const Color(0xFFEAF9F0)
                        : const Color(0xFFF6F8FA),
                    icon: isIncome ? Icons.south_west : Icons.north_east,
                    iconColor: isIncome
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFFE74C3C),
                    title: tx.concept,
                    subtitle: '${tx.category} · ${tx.currency}',
                    amount:
                        '${isIncome ? '+' : '−'}${tx.amount.toColombianCurrency()}',
                    amountColor: isIncome
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFFE74C3C),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _MovementItem extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;

  const _MovementItem({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: ShapeDecoration(
              color: iconBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF17212B),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF6F7A86),
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
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
