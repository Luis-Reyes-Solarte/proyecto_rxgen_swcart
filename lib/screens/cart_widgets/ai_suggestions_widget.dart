import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/screens/cart_widgets/shopping_item_model.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';

class AiSuggestionsWidget extends StatelessWidget {
  const AiSuggestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final financeState = FinanceState.instance;
    final suggestions = financeState.getConsumptionSuggestions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 16,
              color: suggestions.isNotEmpty ? Colors.purple : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              'Sugeridos por tu ciclo de consumo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: suggestions.isNotEmpty ? Colors.purple : Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (suggestions.isEmpty)
          Text(
            !financeState.hasPurchaseHistory
                ? 'Completa productos de tu lista para aprender tus ciclos de compra.'
                : 'Todos tus productos habituales ya están en la lista.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: suggestions.map((item) {
                final name = item['name'] as String;
                final unit = item['unit'] as String;
                final quantity = (item['quantity'] as num).toInt();
                final count = (item['count'] as num).toInt();

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      financeState.addShoppingItem(
                        ShoppingItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: name,
                          quantity: quantity,
                          unit: unit,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.purple.shade100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Comprado $count ${count == 1 ? 'vez' : 'veces'}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.add_circle_outline,
                            color: Colors.purple,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
