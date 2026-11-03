import 'package:flutter/material.dart';

import 'cart_widgets/shopping_item_model.dart';
import 'cart_widgets/add_item_modal.dart';
import 'cart_widgets/ai_suggestions_widget.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final List<ShoppingItem> _items = [];

  void _openAddItemModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AddItemModal(
        onAddItem: (name, quantity, unit) {
          setState(() {
            _items.add(
              ShoppingItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                quantity: quantity,
                unit: unit,
              ),
            );
          });
        },
      ),
    );
  }

  void _confirmDeleteItem(ShoppingItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de eliminar ${item.name} de la lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _items.removeWhere((e) => e.id == item.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} eliminado correctamente.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = _items.where((item) => item.isDone).length;
    final int pendingCount = _items.length - completedCount;
    // Cálculo dinámico del porcentaje de la barra de progreso
    final double progressRatio = _items.isEmpty
        ? 0.0
        : completedCount / _items.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera del módulo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lista de compras',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton.filled(
                    onPressed: _openAddItemModal,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Contador de items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$pendingCount pendientes',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$completedCount de ${_items.length} completado',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // BARRA DE PROGRESO REACTIVA[cite: 3]
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressRatio,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressRatio == 1.0 && _items.isNotEmpty
                        ? Colors.green
                        : Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lista o Mensaje de Estado Vacío
              Expanded(
                child: _items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_shopping_cart_outlined,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'A la espera de productos',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Card(
                            elevation: 0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: item.isDone,
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => item.isDone = val);
                                  }
                                },
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  decoration: item.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: item.isDone
                                      ? Colors.grey
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                '${item.quantity} ${item.unit}',
                                style: TextStyle(
                                  fontSize: 12,
                                  decoration: item.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _confirmDeleteItem(item),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Módulo reservado para IA importado externamente[cite: 3]
              const AiSuggestionsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
