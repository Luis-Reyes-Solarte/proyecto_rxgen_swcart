import 'package:flutter/material.dart';

class ReportsCoachCard extends StatelessWidget {
  final bool hasHistory;
  final bool isLoadingCoach;
  final String? coachResponse;
  final TextEditingController controller;
  final List<String> quickPrompts;
  final ValueChanged<String> onSend;

  const ReportsCoachCard({
    super.key,
    required this.hasHistory,
    required this.isLoadingCoach,
    required this.coachResponse,
    required this.controller,
    required this.quickPrompts,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Row(
            children: [
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
              children: quickPrompts.map((prompt) {
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
                  onPressed: isLoadingCoach ? null : () => onSend(prompt),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              onSubmitted: onSend,
              decoration: InputDecoration(
                hintText:
                    "O escribe tu pregunta: '¿Me alcanza para unos tenis hoy?'",
                hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: isLoadingCoach
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_upward, color: Colors.purple),
                  onPressed:
                      isLoadingCoach ? null : () => onSend(controller.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (coachResponse != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  coachResponse!,
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
    );
  }
}
