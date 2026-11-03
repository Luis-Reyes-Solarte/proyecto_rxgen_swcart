import 'package:flutter/material.dart';

class AddItemModal extends StatefulWidget {
  final Function(String name, int quantity, String unit) onAddItem;

  const AddItemModal({
    super.key,
    required this.onAddItem, // 👈 Asignación directa a la variable final
  });

  @override
  State<AddItemModal> createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  String _selectedUnit = 'pieza(s)';
  final List<String> _unitOptions = ['litro(s)', 'pieza(s)', 'paquete(s)'];

  void _submit() {
    final name = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    if (name.isEmpty) return;

    // Llamada a la función pasada por parámetro desde la pantalla principal
    widget.onAddItem(name, quantity, _selectedUnit);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Añadir producto',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Nombre del producto',
              hintText: 'Ej. Leche deslactosada',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedUnit,
                  decoration: InputDecoration(
                    labelText: 'Unidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _unitOptions
                      .map(
                        (unit) =>
                            DropdownMenuItem(value: unit, child: Text(unit)),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedUnit = val ?? _selectedUnit),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Agregar a la lista',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
