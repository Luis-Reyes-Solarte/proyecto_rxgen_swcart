import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedPeriod = 1; // 0: Semana, 1: Mes, 2: Año

  @override
  Widget build(BuildContext context) {
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

          // Tarjeta principal: Ahorro este mes ($0.00)
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
                  children: const [
                    Text(
                      'Ahorro este mes',
                      style: TextStyle(color: Color(0xFF6F7A86), fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$0.00',
                      style: TextStyle(
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
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '0.0%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6F7A86),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Histórico / Meta en estado vacío
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Ahorro mes a mes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF17212B),
                ),
              ),
              Text(
                'Sin datos registrados',
                style: TextStyle(color: Color(0xFF6F7A86), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Gráfica mes a mes sin datos (barras base neutras)
          Container(
            height: 135,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
                      _buildEmptyBar('Abr'),
                      _buildEmptyBar('May'),
                      _buildEmptyBar('Jun'),
                      _buildEmptyBar('Jul'),
                      _buildEmptyBar('Ago'),
                      _buildEmptyBar('Sep'),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Aún no hay historial de ahorro para graficar',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tarjetas inferiores: Tasa de ahorro y Meta mensual (Figma pág. 4)
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tasa de ahorro',
                        style: TextStyle(
                          color: Color(0xFF6F7A86),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '0.0%',
                        style: TextStyle(
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meta mensual',
                        style: TextStyle(
                          color: Color(0xFF6F7A86),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$0.00',
                        style: TextStyle(
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

          // ===============================================================
          // TODO: [ESPACIO RESERVADO PARA IA]
          // Coach Financiero Interactivo (LLM Chat Integration)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade600, Colors.blue.shade600],
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
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Pregúntale a tu Coach Financiero: '¿Me alcanza para comprar unos tenis hoy?'",
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.purple,
                      ),
                      onPressed: () {
                        // AQUÍ SE EJECUTA LA CONSULTA A LA IA
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ===============================================================
        ],
      ),
    );
  }

  Widget _buildEmptyBar(String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 8,
          width: 16,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
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
}
