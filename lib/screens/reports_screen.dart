import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/screens/reports_widgets/reports_coach_card.dart';
import 'package:proyecto_rxgen_swcart/screens/reports_widgets/reports_monthly_chart.dart';
import 'package:proyecto_rxgen_swcart/screens/reports_widgets/reports_savings_card.dart';
import 'package:proyecto_rxgen_swcart/screens/reports_widgets/reports_stat_cards.dart';
import 'package:proyecto_rxgen_swcart/services/ai_finance_service.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final FinanceState _financeState = FinanceState.instance;
  final TextEditingController _coachController = TextEditingController();

  String? _coachResponse;
  bool _isLoadingCoach = false;

  final List<String> _quickPrompts = const [
    '¿Cómo ahorro más este mes?',
    'Analiza mis gastos',
    'Simular meta de ahorro',
  ];

  Future<void> _sendCoachQuery(String question) async {
    final trimmed = question.trim();
    if (!_financeState.hasTransactionHistory ||
        trimmed.isEmpty ||
        _isLoadingCoach) {
      return;
    }

    setState(() {
      _isLoadingCoach = true;
      _coachController.text = trimmed;
    });

    final reply = await AiFinanceService.instance.askFinancialCoach(
      state: _financeState,
      question: trimmed,
    );

    if (!mounted) return;
    setState(() {
      _coachResponse = reply;
      _isLoadingCoach = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _financeState,
      builder: (context, _) {
        final hasHistory = _financeState.hasTransactionHistory;
        final income = _financeState.totalIncome;
        final savings = _financeState.balance > 0 ? _financeState.balance : 0.0;
        final savingsRate = income > 0 ? (savings / income) * 100 : 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Análisis financiero',
                style: TextStyle(fontSize: 12, color: Color(0xFF6F7A86)),
              ),
              const SizedBox(height: 2),
              const Text(
                'Reportes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17212B),
                ),
              ),
              const SizedBox(height: 14),

              const SizedBox(height: 18),
              ReportsSavingsCard(
                hasHistory: hasHistory,
                savings: savings,
                savingsRate: savingsRate,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ahorro mes a mes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF17212B),
                    ),
                  ),
                  Text(
                    hasHistory
                        ? 'Meta: \$${_financeState.monthlyGoal.toStringAsFixed(0)}'
                        : 'Sin datos registrados',
                    style: const TextStyle(
                      color: Color(0xFF6F7A86),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ReportsMonthlyChart(hasHistory: hasHistory, savings: savings),
              const SizedBox(height: 16),
              ReportsStatCards(
                savingsRate: savingsRate,
                monthlyGoal: _financeState.monthlyGoal,
              ),
              const SizedBox(height: 22),
              ReportsCoachCard(
                hasHistory: hasHistory,
                isLoadingCoach: _isLoadingCoach,
                coachResponse: _coachResponse,
                controller: _coachController,
                quickPrompts: _quickPrompts,
                onSend: _sendCoachQuery,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _coachController.dispose();
    super.dispose();
  }
}
