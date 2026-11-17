import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
import 'package:proyecto_rxgen_swcart/screens/cart_widgets/shopping_item_model.dart';

class FinanceState extends ChangeNotifier {
  static final FinanceState instance = FinanceState._internal();
  factory FinanceState() => instance;
  FinanceState._internal();

  late Box _transactionsBox;
  late Box _shoppingListBox;
  late Box _purchaseHistoryBox;
  late Box _settingsBox;

  List<TransactionModel> _transactions = [];
  List<ShoppingItem> _shoppingItems = [];
  Map<String, Map<String, dynamic>> _purchaseHistory = {};
  double _monthlyGoal = 0.0;

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  List<ShoppingItem> get shoppingItems => List.unmodifiable(_shoppingItems);
  double get monthlyGoal => _monthlyGoal;

  // Guardias de historial para IA
  bool get hasTransactionHistory => _transactions.isNotEmpty;
  bool get hasPurchaseHistory => _purchaseHistory.isNotEmpty;

  Future<void> init() async {
    await Hive.initFlutter();
    _transactionsBox = await Hive.openBox('transactions_box');
    _shoppingListBox = await Hive.openBox('shopping_list_box');
    _purchaseHistoryBox = await Hive.openBox('purchase_history_box');
    _settingsBox = await Hive.openBox('settings_box');

    _loadFromHive();
  }

  void _loadFromHive() {
    _transactions = _transactionsBox.values
        .map((e) => TransactionModel.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    _shoppingItems = _shoppingListBox.values
        .map((e) => ShoppingItem.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();

    _purchaseHistory = {};
    for (final key in _purchaseHistoryBox.keys) {
      final val = _purchaseHistoryBox.get(key);
      if (val is Map) {
        _purchaseHistory[key.toString()] = Map<String, dynamic>.from(val);
      }
    }

    _monthlyGoal = (_settingsBox.get('monthly_goal', defaultValue: 0.0) as num)
        .toDouble();
  }

  // --- MÉTODOS DE TRANSACCIONES ---
  Future<void> addTransaction(TransactionModel tx) async {
    await _transactionsBox.put(tx.id, tx.toMap());
    _transactions.insert(0, tx);
    notifyListeners();
  }

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  Map<String, double> get expensesByCategory {
    final Map<String, double> totals = {};
    for (final tx in _transactions.where((t) => t.type == TransactionType.expense)) {
      totals[tx.category] = (totals[tx.category] ?? 0.0) + tx.amount;
    }
    return totals;
  }

  // --- MÉTODOS DE META MENSUAL ---
  Future<void> setMonthlyGoal(double goal) async {
    _monthlyGoal = goal;
    await _settingsBox.put('monthly_goal', goal);
    notifyListeners();
  }

  // --- MÉTODOS DE LISTA DE COMPRAS E HISTORIAL DE CICLO ---
  Future<void> addShoppingItem(ShoppingItem item) async {
    await _shoppingListBox.put(item.id, item.toMap());
    _shoppingItems.add(item);
    notifyListeners();
  }

  Future<void> toggleShoppingItem(String id, bool isDone) async {
    final index = _shoppingItems.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final item = _shoppingItems[index];
    item.isDone = isDone;
    await _shoppingListBox.put(item.id, item.toMap());

    // Al marcar como comprado, alimentamos el historial de ciclo de consumo
    if (isDone) {
      final key = item.name.trim().toLowerCase();
      final existing = _purchaseHistory[key];
      final count = (existing?['count'] as int? ?? 0) + 1;
      final record = {
        'name': item.name.trim(),
        'unit': item.unit,
        'quantity': item.quantity,
        'count': count,
        'lastBought': DateTime.now().toIso8601String(),
      };
      _purchaseHistory[key] = record;
      await _purchaseHistoryBox.put(key, record);
    }

    notifyListeners();
  }

  Future<void> removeShoppingItem(String id) async {
    await _shoppingListBox.delete(id);
    _shoppingItems.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Devuelve sugerencias basadas únicamente en productos previamente comprados
  /// que no estén actualmente en la lista activa.
  List> List<dynamic> getConsumptionSuggestions() {
    if (!hasPurchaseHistory) return [];

    final activeNames =
        _shoppingItems.map((e) => e.name.trim().toLowerCase()).toSet();

    final suggestions = _purchaseHistory.entries
        .where((entry) => !activeNames.contains(entry.key))
        .map((entry) => entry.value)
        .toList();

    suggestions.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
    return suggestions.take(5).toList();
  }
}
