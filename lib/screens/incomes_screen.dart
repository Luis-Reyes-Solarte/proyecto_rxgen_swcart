import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
import 'package:proyecto_rxgen_swcart/screens/incomes_widgets/income_amount_field.dart';
import 'package:proyecto_rxgen_swcart/screens/incomes_widgets/income_category_selector.dart';
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

  final List<Map<String, dynamic>> _categories = [
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
    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
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
          IncomeAmountField(
            controller: _amountController,
            selectedCurrency: _selectedCurrency,
            onCurrencyChanged: (val) => setState(() => _selectedCurrency = val),
          ),
          const SizedBox(height: 16),
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
          IncomeCategorySelector(
            categories: _categories,
            selectedCategory: _selectedCategory,
            autoClassifiedByAi: _autoClassifiedByAi,
            onSelected: (category) {
              setState(() {
                _selectedCategory = category;
                _autoClassifiedByAi = false;
              });
            },
          ),
          const SizedBox(height: 28),
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
