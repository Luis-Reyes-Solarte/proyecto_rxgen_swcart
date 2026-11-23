import 'package:flutter/material.dart';
import 'package:proyecto_rxgen_swcart/services/ai_finance_service.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';

class InicioAiBanner extends StatefulWidget {
  const InicioAiBanner({super.key});

  @override
  State<InicioAiBanner> createState() => _InicioAiBannerState();
}

class _InicioAiBannerState extends State<InicioAiBanner> {
  final FinanceState _financeState = FinanceState.instance;
  String? _diagnostic;
  bool _isAnalyzing = false;

  Future<void> _analyze() async {
    if (!_financeState.hasTransactionHistory || _isAnalyzing) return;
    setState(() => _isAnalyzing = true);
    final result = await AiFinanceService.instance.analyzeFinancialStatus(
      _financeState,
    );
    if (!mounted) return;
    setState(() {
      _diagnostic = result;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _financeState,
      builder: (context, _) {
        final hasHistory = _financeState.hasTransactionHistory;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: const Color(0xFFF5F0FA),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE7D7EE)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: ShapeDecoration(
                      color: hasHistory
                          ? const Color(0xFF9B59B6)
                          : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      !hasHistory
                          ? 'VIA en espera: registra tu primer ingreso o gasto para activar el diagnóstico.'
                          : (_diagnostic ??
                                'Historial listo. Pulsa "Analizar mi estado" para recibir tu diagnóstico con IA.'),
                      style: const TextStyle(
                        color: Color(0xFF17212B),
                        fontSize: 11,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              if (hasHistory) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _isAnalyzing ? null : _analyze,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF9B59B6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.analytics_outlined, size: 14),
                    label: Text(
                      _isAnalyzing ? 'Analizando...' : 'Analizar mi estado',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
