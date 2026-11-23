import 'package:flutter/material.dart';

class ExpenseCategorySelector extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final bool autoClassifiedByAi;
  final ValueChanged<String> onSelected;

  const ExpenseCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.autoClassifiedByAi,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categoría',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (autoClassifiedByAi)
              const Row(
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: Colors.purple),
                  SizedBox(width: 4),
                  Text(
                    'Autoclasificado por historial',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final isSelected = selectedCategory == cat['name'];
            return ChoiceChip(
              avatar: Icon(
                cat['icon'] as IconData,
                size: 18,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              label: Text(cat['name'] as String),
              selected: isSelected,
              selectedColor: Colors.blue.shade700,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
              onSelected: (selected) {
                if (selected) onSelected(cat['name'] as String);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
