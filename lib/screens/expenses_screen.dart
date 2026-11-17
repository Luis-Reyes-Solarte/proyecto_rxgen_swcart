import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
import 'package:proyecto_rxgen_swcart/services/ai_finance_service.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _conceptController = TextEditingController();

  String _selectedCategory = 'Comida';
  String _selectedCurrency = 'MXN';
  bool _autoClassifiedByAi = false;

  final List> final _categories = [
    {'name': 'Supermercado', 'icon': Icons.shopping_bag_outlined},
    {'name': 'Comida', 'icon': Icons.restaurant},
    {'name': 'Transporte', 'icon': Icons.directions_bus_outlined},
    {'name': 'Hogar', 'icon': Icons.home_outlined},
  ];

  void _onConceptChanged(String value) {
    final predicted = AiFinanceService.instance.predictCategoryFromHistory(
      state: FinanceState.instance,
      conceptInput: value,
      type: TransactionType.expense,
    );
    if (predicted != null &&
        _categories.any((c) => c['name'] == predicted)) {
      setState(() {
        _selectedCategory = predicted;
        _autoClassifiedByAi = true;
      });
    } else if (_autoClassifiedByAi) {
      setState(() => _autoClassifiedByAi = false);
    }
  }

  Future<void> _saveExpense() async {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
    final concept = _conceptController.text.trim();

    if (amount <= 0 || concept.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un monto válido y un concepto.'),
        ),
      );
      return;
    }

    final tx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: TransactionType.expense,
      amount: amount,
      currency: _selectedCurrency,
      concept: concept,
      category: _selectedCategory,
      date: DateTime.now(),
    );

    await FinanceState.instance.addTransaction(tx);

    if (!mounted) return;
    _amountController.clear();
    _conceptController.clear();
    setState(() => _autoClassifiedByAi = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gasto registrado y guardado en historial.')),
    );
  }

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
              hintText: '0.00',
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
            onChanged: _onConceptChanged,
            decoration: InputDecoration(
              hintText: 'Ej. Walmart, Uber, Almuerzo...',
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

          // Selección de Categoría + Indicador de Autoclasificación IA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categoría',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_autoClassifiedByAi)
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, size: 14, color: Colors.purple),
                    SizedBox(width: 4),
                    Text(
                      'Autoclasificado por historial',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.purple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat['name'];
              return ChoiceChip(
                avatar: Icon(
                  cat['icon'] as IconData,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                label: Text(cat['name'] as String),
                selected: isSelected,
                selectedColor: Colors.blue.shade700,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = cat['name'] as String;
                      _autoClassifiedByAi = false;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Botón de Guardar Gasto
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _saveExpense,
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

  @override
  void dispose() {
    _amountController.dispose();
    _conceptController.dispose();
    super.dispose();
  }
}
