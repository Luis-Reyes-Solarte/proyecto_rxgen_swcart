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
          // Tarjeta de Balance General
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Balance General',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  '\$24,580.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 18),
                        SizedBox(width: 4),
                        Text('Ingresos \$18,420', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Container(height: 15, width: 1, color: Colors.white30),
                    Row(
                      children: const [
                        Icon(Icons.arrow_downward, color: Colors.orangeAccent, size: 18),
                        SizedBox(width: 4),
                        Text('Gastos \$9,840', style: TextStyle(color: Colors.white)),
                      ],
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
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.purple.shade600),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'VIA: Detectamos un aumento del 12% en Suscripciones respecto al mes pasado. ¿Quieres revisarlo?',
                    style: TextStyle(
                      color: Colors.purple.shade900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ===============================================================

          const SizedBox(height: 20),

          // Resumen gráfico de categorías
          const Text(
            'Gastos \$9.8k',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildCategoryChip('Comida', '54%', Colors.blue.shade100, Colors.blue.shade900)),
              const SizedBox(width: 8),
              Expanded(child: _buildCategoryChip('Transporte', '24%', Colors.amber.shade100, Colors.amber.shade900)),
              const SizedBox(width: 8),
              Expanded(child: _buildCategoryChip('Hogar', '22%', Colors.teal.shade100, Colors.teal.shade900)),
            ],
          ),
          const SizedBox(height: 24),

          // Sección de Últimos Movimientos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Últimos movimientos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Ver todos'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTransactionTile('Walmart', 'Hoy • Comida', '-\$86.40', Colors.red),
          _buildTransactionTile('Nómina', 'Ayer • Ingreso', '+\$2,450', Colors.green),
          _buildTransactionTile('Uber', '18 sep • Transporte', '-\$18.90', Colors.red),
          _buildTransactionTile('Netflix', '17 sep • Suscripciones', '-\$15.49', Colors.red),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String percentage, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(percentage, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(String title, String subtitle, String amount, Color amountColor) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Text(
          amount,
          style: TextStyle(fontWeight: FontWeight.bold, color: amountColor, fontSize: 15),
        ),
      ),
    );
  }
}
