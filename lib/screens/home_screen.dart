import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/screens/home_widgets/home_ai_diagnostic_card.dart';
import 'package:proyecto_rxgen_swcart/screens/home_widgets/home_balance_card.dart';
import 'package:proyecto_rxgen_swcart/screens/home_widgets/home_expense_chart.dart';
import 'package:proyecto_rxgen_swcart/screens/home_widgets/home_recent_movements.dart';
import 'package:proyecto_rxgen_swcart/services/ai_finance_service.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FinanceState _financeState = FinanceState.instance;
  String? _aiDiagnostic;
  bool _isAnalyzing = false;

  Future<void> _runAiDiagnostic() async {
    if (!_financeState.hasTransactionHistory || _isAnalyzing) return;
    setState(() => _isAnalyzing = true);
    final result = await AiFinanceService.instance.analyzeFinancialStatus(
      _financeState,
    );
    if (!mounted) return;
    setState(() {
      _aiDiagnostic = result;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _financeState,
      builder: (context, _) {
        final hasHistory = _financeState.hasTransactionHistory;
        final totalExpense = _financeState.totalExpense;
        final catTotals = _financeState.expensesByCategory;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeBalanceCard(
                balance: _financeState.balance,
                totalIncome: _financeState.totalIncome,
                totalExpense: totalExpense,
              ),
              const SizedBox(height: 16),
              HomeAiDiagnosticCard(
                hasHistory: hasHistory,
                aiDiagnostic: _aiDiagnostic,
                isAnalyzing: _isAnalyzing,
                onAnalyze: _runAiDiagnostic,
              ),
              const SizedBox(height: 22),
              HomeExpenseChart(
                totalExpense: totalExpense,
                catTotals: catTotals,
              ),
              const SizedBox(height: 24),
              HomeRecentMovements(
                hasHistory: hasHistory,
                transactions: _financeState.transactions,
              ),
            ],
          ),
        );
      },
    );
  }
}
