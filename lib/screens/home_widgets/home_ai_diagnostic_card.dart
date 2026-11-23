import 'package:flutter/material.dart';

class HomeAiDiagnosticCard extends StatelessWidget {
  final bool hasHistory;
  final String? aiDiagnostic;
  final bool isAnalyzing;
  final VoidCallback onAnalyze;

  const HomeAiDiagnosticCard({
    super.key,
    required this.hasHistory,
    required this.aiDiagnostic,
    required this.isAnalyzing,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color:
                      hasHistory ? const Color(0xFF9B59B6) : Colors.grey.shade400,
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
                      : (aiDiagnostic ??
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
                onPressed: isAnalyzing ? null : onAnalyze,
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
                icon: isAnalyzing
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
                  isAnalyzing ? 'Analizando...' : 'Analizar mi estado',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
