import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
import 'package:proyecto_rxgen_swcart/services/ai_finance_service.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';

class IncomesScreen extends StatefulWidget {
  const IncomesScreen({super.key});

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _conceptController = TextEditingController();

  String _selectedCategory = 'Nómina';
  String _selectedCurrency = 'MXN';
  bool _autoClassifiedByAi = false;

  final List> final _categories = [
    {'name': 'Nómina', 'icon': Icons.work_outline},
    {'name': 'Ventas', 'icon': Icons.storefront_outlined},
    {'name': 'Inversiones', 'icon': Icons.trending_up},
    {'name': 'Transferencia', 'icon': Icons.swap_horiz},
  ];

  void _onConceptChanged(String value) {
    final predicted = AiFinanceService.instance.predictCategoryFromHistory(
      state: FinanceState.instance,
      conceptInput: value,
      type: TransactionType.income,
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

  Future<void> _saveIncome() async {
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
      type: TransactionType.income,
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
      const SnackBar(content: Text('Ingreso registrado y guardado en historial.')),
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
            onChanged: _onConceptChanged,
            decoration: InputDecoration(
              hintText: 'Ej. Nómina quincenal, Pago cliente...',
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
                selectedColor: Colors.green.shade600,
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

          // Botón de Guardar Ingreso
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _saveIncome,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
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

  @override
  void dispose() {
    _amountController.dispose();
    _conceptController.dispose();
    super.dispose();
  }
}
