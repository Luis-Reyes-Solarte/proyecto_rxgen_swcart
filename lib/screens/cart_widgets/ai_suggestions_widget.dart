import 'package:flutter/material.dart';

class AiSuggestionsWidget extends StatelessWidget {
  const AiSuggestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ===============================================================
    // TODO: [ESPACIO RESERVADO PARA IA]
    // Módulo de sugerencias por ciclo de consumo inteligente.[cite: 3]
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.auto_awesome, size: 16, color: Colors.purple),
            SizedBox(width: 6),
            Text(
              'Sugeridos por tu ciclo de consumo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildAiSuggestionChip('Café', 'Comprado hace 18 días'),
              const SizedBox(width: 8),
              _buildAiSuggestionChip(
                'Detergente',
                'Suele agotarse esta semana',
              ),
            ],
          ),
        ),
      ],
    );
    // ===============================================================
  }

  Widget _buildAiSuggestionChip(String title, String reason) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                reason,
                style: TextStyle(fontSize: 11, color: Colors.purple.shade700),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.add_circle_outline, color: Colors.purple, size: 20),
        ],
      ),
    );
  }
}
