import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
import 'package:proyecto_rxgen_swcart/utils/currency_formatter.dart';

class HomeRecentMovements extends StatelessWidget {
  final bool hasHistory;
  final List<TransactionModel> transactions;

  const HomeRecentMovements({
    super.key,
    required this.hasHistory,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Últimos movimientos',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF17212B),
          ),
        ),
        const SizedBox(height: 12),
        if (!hasHistory)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE9EDF1)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 42,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                Text(
                  'Aún no hay movimientos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tus ingresos y gastos recientes aparecerán aquí.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          )
        else
          ...transactions.take(6).map((tx) {
            final isIncome = tx.type == TransactionType.income;
            return Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                title: Text(
                  tx.concept,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${tx.category} • ${tx.currency}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: Text(
                  '${isIncome ? '+' : '-'}${tx.amount.toColombianCurrency()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
