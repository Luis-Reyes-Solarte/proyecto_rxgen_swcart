import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
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

        double pctFor(String cat) {
          if (totalExpense <= 0) return 0;
          return ((catTotals[cat] ?? 0.0) / totalExpense) * 100;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de Balance General
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111820),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1217212B),
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Balance General',
                      style: TextStyle(color: Color(0xFFAEB7C0), fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_financeState.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '↑ Ingresos',
                                style: TextStyle(
                                  color: Color(0xFFAEB7C0),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '\$${_financeState.totalIncome.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFF2ECC71),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '↓ Gastos',
                                style: TextStyle(
                                  color: Color(0xFFAEB7C0),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '\$${totalExpense.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFFE74C3C),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Módulo de IA (VIA) - Opción 2 con guardia de historial
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE7D7EE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: hasHistory
                                ? const Color(0xFF9B59B6)
                                : Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            !hasHistory
                                ? 'VIA en espera: registra tu primer ingreso o gasto para activar el diagnóstico financiero.'
                                : (_aiDiagnostic ??
                                      'Historial detectado. Pulsa "Analizar mi estado" para obtener un diagnóstico con IA.'),
                            style: const TextStyle(
                              color: Color(0xFF17212B),
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (hasHistory) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: _isAnalyzing ? null : _runAiDiagnostic,
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF9B59B6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: _isAnalyzing
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.analytics_outlined, size: 16),
                          label: Text(
                            _isAnalyzing
                                ? 'Analizando...'
                                : 'Analizar mi estado',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Gráfico circular de categorías
              Row(
                children: [
                  SizedBox(
                    width: 132,
                    height: 132,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 16,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              totalExpense > 0
                                  ? const Color(0xFF2ECC71)
                                  : Colors.grey.shade200,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Gastos',
                              style: TextStyle(
                                color: Color(0xFF6F7A86),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '\$${totalExpense.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Color(0xFF17212B),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryLegendRow(
                          'Comida',
                          '${pctFor('Comida').toStringAsFixed(0)}%',
                          totalExpense > 0
                              ? const Color(0xFF2ECC71)
                              : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        _buildCategoryLegendRow(
                          'Transporte',
                          '${pctFor('Transporte').toStringAsFixed(0)}%',
                          totalExpense > 0
                              ? const Color(0xFFE74C3C)
                              : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        _buildCategoryLegendRow(
                          'Hogar',
                          '${pctFor('Hogar').toStringAsFixed(0)}%',
                          totalExpense > 0
                              ? const Color(0xFFF4B942)
                              : Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sección de Últimos Movimientos
              const Text(
                'Últimos movimientos',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17212B),
                ),
              ),
              const SizedBox(height: 12),

              if (!hasHistory)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE9EDF1)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 42,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Aún no hay movimientos',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tus ingresos y gastos recientes aparecerán aquí.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._financeState.transactions.take(6).map((tx) {
                  final isIncome = tx.type == TransactionType.income;
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      title: Text(
                        tx.concept,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${tx.category} • ${tx.currency}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        '${isIncome ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.green : Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryLegendRow(
    String label,
    String percentage,
    Color dotColor,
  ) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF6F7A86), fontSize: 12),
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            color: Color(0xFF17212B),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
