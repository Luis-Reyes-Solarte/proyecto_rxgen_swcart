import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de Balance General (Estilo Figma #111820 en $0.00)
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
                const Text(
                  '\$0.00',
                  style: TextStyle(
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
                        children: const [
                          Text(
                            '↑ Ingresos',
                            style: TextStyle(
                              color: Color(0xFFAEB7C0),
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '\$0.00',
                            style: TextStyle(
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
                        children: const [
                          Text(
                            '↓ Gastos',
                            style: TextStyle(
                              color: Color(0xFFAEB7C0),
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '\$0.00',
                            style: TextStyle(
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

          // ===============================================================
          // TODO: [ESPACIO RESERVADO PARA IA]
          // Integración del módulo de alertas y detección inteligente (VIA)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7D7EE)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9B59B6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'VIA: Registra tus primeros ingresos o gastos para comenzar a analizar tus hábitos financieros.',
                    style: TextStyle(
                      color: Color(0xFF17212B),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ===============================================================

          const SizedBox(height: 22),

          // Gráfico circular de categorías en estado vacío (Anillo neutro)
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
                          Colors.grey.shade200,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Gastos',
                          style: TextStyle(
                            color: Color(0xFF6F7A86),
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '\$0',
                          style: TextStyle(
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
                      '0%',
                      Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    _buildCategoryLegendRow(
                      'Transporte',
                      '0%',
                      Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    _buildCategoryLegendRow(
                      'Hogar',
                      '0%',
                      Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sección de Últimos Movimientos (Estado vacío)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Últimos movimientos',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17212B),
                ),
              ),
              Text(
                'Ver todos',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6F7A86),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
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
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
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
