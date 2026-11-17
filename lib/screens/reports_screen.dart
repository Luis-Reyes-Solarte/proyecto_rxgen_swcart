import 'package:flutter/material.dart';
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

  int _selectedPeriod = 1;
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

              // Selector de temporalidad
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Semana')),
                    ButtonSegment(value: 1, label: Text('Mes')),
                    ButtonSegment(value: 2, label: Text('Año')),
                  ],
                  selected: {_selectedPeriod},
                  onSelectionChanged: (set) {
                    setState(() => _selectedPeriod = set.first);
                  },
                ),
              ),
              const SizedBox(height: 18),

              // Tarjeta principal: Ahorro este mes
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE9EDF1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ahorro este mes',
                          style: TextStyle(
                            color: Color(0xFF6F7A86),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${savings.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF17212B),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: hasHistory && savings > 0
                            ? const Color(0xFFEAF9F0)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${savingsRate.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: hasHistory && savings > 0
                              ? const Color(0xFF2ECC71)
                              : const Color(0xFF6F7A86),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Histórico / Meta
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

              // Gráfica mes a mes
              Container(
                height: 135,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE9EDF1)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBar('Abr', 0.0),
                          _buildBar('May', 0.0),
                          _buildBar('Jun', 0.0),
                          _buildBar('Jul', 0.0),
                          _buildBar('Ago', 0.0),
                          _buildBar(
                            'Sep',
                            hasHistory && savings > 0 ? 0.65 : 0.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      hasHistory
                          ? 'Balance positivo acumulado del periodo actual'
                          : 'Aún no hay historial de ahorro para graficar',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tarjetas inferiores: Tasa de ahorro y Meta mensual
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE9EDF1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tasa de ahorro',
                            style: TextStyle(
                              color: Color(0xFF6F7A86),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${savingsRate.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF17212B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE9EDF1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Meta mensual',
                            style: TextStyle(
                              color: Color(0xFF6F7A86),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${_financeState.monthlyGoal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF17212B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Coach Financiero - Opción 2 (Chips rápidos + Guardia de historial)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: hasHistory
                        ? [Colors.purple.shade600, Colors.blue.shade600]
                        : [Colors.grey.shade500, Colors.grey.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_awesome, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Coach Financiero',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (!hasHistory)
                      const Text(
                        'Registra al menos un movimiento financiero para desbloquear las consultas al Coach.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      )
                    else ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _quickPrompts.map((prompt) {
                          return ActionChip(
                            label: Text(
                              prompt,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.purple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            onPressed: _isLoadingCoach
                                ? null
                                : () => _sendCoachQuery(prompt),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _coachController,
                        onSubmitted: _sendCoachQuery,
                        decoration: InputDecoration(
                          hintText: "O escribe tu pregunta: '¿Me alcanza para unos tenis hoy?'",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: _isLoadingCoach
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.purple,
                                  ),
                            onPressed: _isLoadingCoach
                                ? null
                                : () => _sendCoachQuery(_coachController.text),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      if (_coachResponse != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _coachResponse!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF17212B),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBar(String label, double heightFactor) {
    final bool hasData = heightFactor > 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: hasData ? 60 * heightFactor : 8,
          width: 16,
          decoration: BoxDecoration(
            color: hasData ? const Color(0xFF2ECC71) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6F7A86)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _coachController.dispose();
    super.dispose();
  }
}
