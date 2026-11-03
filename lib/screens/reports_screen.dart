import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Análisis financiero', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de temporalidad
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Semana')),
                  ButtonSegment(value: 1, label: Text('Mes')),
                  ButtonSegment(value: 2, label: Text('Año')),
                ],
                selected: const {1},
                onSelectionChanged: (set) {},
              ),
              const SizedBox(height: 20),

              // Tarjetas de métricas de ahorro
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ahorro este mes', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 4),
                          Text('\$8,580', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tasa de ahorro', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 4),
                          Text('18.4%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Histórico / Meta
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Ahorro mes a mes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Meta mensual: \$10,000', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),

              // Simulación gráfica mes a mes
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar('Abr', 0.4),
                    _buildBar('May', 0.6),
                    _buildBar('Jun', 0.5),
                    _buildBar('Jul', 0.7),
                    _buildBar('Ago', 0.8),
                    _buildBar('Sep', 0.9),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // TODO: [ESPACIO RESERVADO PARA IA]
              // Coach Financiero Interactivo (LLM Chat Integration)
              // Aquí se conecta el input y la API del modelo de IA generativa.
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
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        // PREMPT BASE / SUGERENCIA PARA EL USUARIO
                        hintText: "Pregúntale a tu Coach Financiero: '¿Me alcanza para comprar unos tenis hoy?'",
                        hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_upward, color: Colors.purple),
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
        ),
      ),
    );
  }

  Widget _buildBar(String label, double heightFactor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 60 * heightFactor,
          width: 14,
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
