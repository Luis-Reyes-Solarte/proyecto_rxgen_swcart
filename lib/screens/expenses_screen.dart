import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _amountController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _conceptController = TextEditingController(
    text: 'Walmart',
  );

  String _selectedCategory = 'Comida';
  String _selectedCurrency = 'MXN';

  final List _categories = [
    {'name': 'Supermercado', 'icon': Icons.shopping_bag_outlined},
    {'name': 'Comida', 'icon': Icons.restaurant},
    {'name': 'Transporte', 'icon': Icons.directions_bus_outlined},
    {'name': 'Hogar', 'icon': Icons.home_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nuevo gasto',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Campo de Monto
          const Text(
            'MONTO',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixText: '\$ ',
              suffixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    items: ['MXN', 'USD', 'COP'].map((curr) {
                      return DropdownMenuItem(
                        value: curr,
                        child: Text(curr, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (val) => setState(
                      () => _selectedCurrency = val ?? _selectedCurrency,
                    ),
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Concepto / Establecimiento
          const Text(
            'Concepto / Establecimiento',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _conceptController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Selección de Categoría
          const Text(
            'Categoría',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat['name'];
              return ChoiceChip(
                avatar: Icon(
                  cat['icon'],
                  size: 18,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                label: Text(cat['name']),
                selected: isSelected,
                selectedColor: Colors.blue.shade700,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                onSelected: (selected) {
                  if (selected) setState(() => _selectedCategory = cat['name']);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Fecha por defecto
          Row(
            children: const [
              Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Hoy, 22 de septiembre',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ===============================================================
          // TODO: [ESPACIO RESERVADO PARA IA]
          // Predicciones de Contexto dinámicas basadas en hábitos de consumo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_awesome, size: 16, color: Colors.purple),
                  SizedBox(width: 6),
                  Text(
                    'Predicciones de Contexto',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildAiPredictionChip('Supermercado'),
                  _buildAiPredictionChip('Almuerzo'),
                  _buildAiPredictionChip('Despensa'),
                ],
              ),
            ],
          ),
          // ===============================================================

          const SizedBox(height: 28),

          // Botón de Guardar Gasto (Rojo / Tonalidad de Gasto)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gasto registrado correctamente.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Text(
                'Guardar gasto',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              label: const Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiPredictionChip(String label) {
    return ActionChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.purple),
      ),
      backgroundColor: Colors.purple.shade50,
      side: BorderSide(color: Colors.purple.shade100),
      onPressed: () {
        setState(() {
          _conceptController.text = label;
        });
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _conceptController.dispose();
    super.dispose();
  }
}
