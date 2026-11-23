import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
import 'package:proyecto_rxgen_swcart/screens/expenses_widgets/expense_amount_field.dart';
import 'package:proyecto_rxgen_swcart/screens/expenses_widgets/expense_category_selector.dart';
import 'package:proyecto_rxgen_swcart/services/ai_finance_service.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';
import 'package:proyecto_rxgen_swcart/utils/currency_formatter.dart';

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

  final List<Map<String, dynamic>> _categories = [
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
    if (predicted != null && _categories.any((c) => c['name'] == predicted)) {
      setState(() {
        _selectedCategory = predicted;
        _autoClassifiedByAi = true;
      });
    } else if (_autoClassifiedByAi) {
      setState(() => _autoClassifiedByAi = false);
    }
  }

  Future<void> _saveExpense() async {
    final amount = CurrencyFormatter.parse(_amountController.text);
    final concept = _conceptController.text.trim();

    if (amount <= 0 || concept.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido y un concepto.')),
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
      const SnackBar(
        content: Text('Gasto registrado y guardado en historial.'),
      ),
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
          ExpenseAmountField(
            controller: _amountController,
            selectedCurrency: _selectedCurrency,
            onCurrencyChanged: (val) => setState(() => _selectedCurrency = val),
          ),
          const SizedBox(height: 16),
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
          ExpenseCategorySelector(
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
