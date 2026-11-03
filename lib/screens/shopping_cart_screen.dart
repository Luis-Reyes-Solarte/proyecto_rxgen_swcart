import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mi carrito', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lista de compras',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),

              // Campo para añadir producto
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Añadir un producto...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Contador de items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('4 pendientes', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('1 de 5 completado', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),

              // Lista de productos
              Expanded(
                child: ListView(
                  children: [
                    _buildItemTile('Leche deslactosada', '1 litro', true),
                    _buildItemTile('Aguacates', '4 piezas', false),
                    _buildItemTile('Pan integral', '1 paquete', false),
                    _buildItemTile('Huevos', '12 piezas', false),
                    _buildItemTile('Yogurt natural', '6 piezas', false),
                  ],
                ),
              ),

              // ===============================================================
              // TODO: [ESPACIO RESERVADO PARA IA]
              // Módulo de sugerencias por ciclo de consumo inteligente.
              // La IA analiza las compras pasadas y genera recomendaciones dinámicas.
              Column(
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
                        // AQUÍ SE GENERAN DINÁMICAMENTE LOS ELEMENTOS SUGERIDOS POR LA IA
                        _buildAiSuggestionChip('Café', 'Comprado hace 18 días'),
                        const SizedBox(width: 8),
                        _buildAiSuggestionChip('Detergente', 'Suele agotarse esta semana'),
                      ],
                    ),
                  ),
                ],
              ),
              // ===============================================================
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemTile(String title, String subtitle, bool isDone) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (val) {},
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.drag_indicator, color: Colors.grey),
      ),
    );
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(reason, style: TextStyle(fontSize: 11, color: Colors.purple.shade700)),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.add_circle_outline, color: Colors.purple, size: 20),
        ],
      ),
    );
  }
}
