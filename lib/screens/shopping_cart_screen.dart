import 'package:flutter/material.dart';

// Modelo de datos para un producto de la lista
class ShoppingItem {
  String id;
  String name;
  int quantity;
  String unit;
  bool isDone;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.isDone = false,
  });
}

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  // Lista de productos dinámica (inicia vacía)
  final List<ShoppingItem> _items = [];

  // Controladores para el modal de agregar producto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  String _selectedUnit = 'pieza(s)';

  final List<String> _unitOptions = ['litro(s)', 'pieza(s)', 'paquete(s)'];

  // Función para abrir el modal de nuevo producto
  void _openAddItemModal() {
    _nameController.clear();
    _quantityController.text = '1';
    _selectedUnit = 'pieza(s)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Añadir producto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Nombre del producto',
                      hintText: 'Ej. Leche deslactosada',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cantidad',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedUnit,
                          decoration: InputDecoration(
                            labelText: 'Unidad',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: _unitOptions.map((String unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setModalState(() {
                                _selectedUnit = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _addItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Agregar a la lista',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Guardar nuevo item en el estado
  void _addItem() {
    final String name = _nameController.text.trim();
    final int quantity = int.tryParse(_quantityController.text) ?? 1;

    if (name.isEmpty) return;

    setState(() {
      _items.add(
        ShoppingItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          quantity: quantity,
          unit: _selectedUnit,
        ),
      );
    });

    Navigator.pop(context);
  }

  // Diálogo de confirmación para eliminar
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
                _items.removeWhere((element) => element.id == item.id);
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra superior del módulo con el botón "+"
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

              // Contador dinámico de items
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
              const SizedBox(height: 12),

              // Lista o mensaje de Estado Vacío
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
                                onChanged: (bool? val) {
                                  if (val != null) {
                                    setState(() {
                                      item.isDone = val;
                                    });
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

              // ===============================================================
              // TODO: [ESPACIO RESERVADO PARA IA]
              // Módulo de sugerencias por ciclo de consumo inteligente[cite: 3].
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, size: 16, color: Colors.purple),
                      SizedBox(width: 6),
                      Text(
                        'Sugeridos por tu ciclo de consumo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // SUGERENCIAS GENERADAS POR IA
                        _buildAiSuggestionChip(
                          'Café',
                          'Comprado hace 18 días',
                        ), //[cite: 3]
                        const SizedBox(width: 8),
                        _buildAiSuggestionChip(
                          'Detergente',
                          'Suele agotarse esta semana',
                        ), //[cite: 3]
                      ],
                    ),
                  ),
                ],
              ),
              // ===============================================================
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiSuggestionChip(String title, String reason) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                reason,
                style: TextStyle(fontSize: 11, color: Colors.purple.shade700),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.add_circle_outline, color: Colors.purple, size: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
