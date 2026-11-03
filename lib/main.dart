import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/incomes_screen.dart';
import 'screens/expenses_screen.dart';
import 'screens/shopping_cart_screen.dart';
import 'screens/reports_screen.dart';

void main() {
  runApp(const RxGenSWCartApp());
}

class RxGenSWCartApp extends StatelessWidget {
  const RxGenSWCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxGen SWCart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    IncomesScreen(), // Nueva pantalla: Ingresos
    ExpensesScreen(), // Nueva pantalla: Gastos
    ShoppingCartScreen(),
    ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header superior permanente
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RxGen SWCart',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tu dinero, en orden',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                ],
              ),
            ),

            // Cuerpo dinámico por pantalla
            Expanded(
              child: IndexedStack(index: _currentIndex, children: _screens),
            ),
          ],
        ),
      ),

      // Barra de navegación de 5 destinos
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.south_west_outlined),
            selectedIcon: Icon(Icons.south_west),
            label: 'Ingresos',
          ),
          NavigationDestination(
            icon: Icon(Icons.north_east_outlined),
            selectedIcon: Icon(Icons.north_east),
            label: 'Gastos',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Compras',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reportes',
          ),
        ],
      ),
    );
  }
}
