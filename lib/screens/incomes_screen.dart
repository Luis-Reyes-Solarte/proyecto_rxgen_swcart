import 'package:flutter/material.dart';

class IncomesScreen extends StatefulWidget {
  const IncomesScreen({super.key});

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  final TextEditingController _amountController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _conceptController = TextEditingController(
    text: 'Nómina',
  );

  String _selectedCategory = 'Nómina';
  String _selectedCurrency = 'MXN';

  final List _categories = [
    {'name': 'Nómina', 'icon': Icons.work_outline},
    {'name': 'Ventas', 'icon': Icons.storefront_outlined},
    {'name': 'Inversiones', 'icon': Icons.trending_up},
    {'name': 'Transferencia', 'icon': Icons.swap_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nuevo ingreso',
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

          // Concepto / Fuente
          const Text(
            'Concepto / Fuente',
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
                selectedColor: Colors.green.shade600,
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
          // Predicciones de Contexto dinámicas para ingresos recurrentes
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
                  _buildAiPredictionChip('Nómina quincenal'),
                  _buildAiPredictionChip('Pago cliente'),
                  _buildAiPredictionChip('Rendimientos'),
                ],
              ),
            ],
          ),
          // ===============================================================

          const SizedBox(height: 28),

          // Botón de Guardar Ingreso (VERDE)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ingreso registrado correctamente.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600, // 👈 Botón en verde
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Text(
                'Guardar ingreso',
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
