import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';
import 'package:proyecto_rxgen_swcart/utils/currency_formatter.dart';

class AiFinanceService {
  static final AiFinanceService instance = AiFinanceService._internal();
  factory AiFinanceService() => instance;
  AiFinanceService._internal();

  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  // Lista ordenada por prioridad: si el principal da 503, pasa al siguiente
  static const List<String> _fallbackModels = [
    'gemini-3.8-flash',
    'gemini-3.8-flash-lite',
    'gemini-2.5-flash-lite',
  ];

  /// Ejecuta la consulta probando los modelos en cascada ante saturación (503)
  Future<String?> _generateWithFallback(String prompt) async {
    if (_apiKey.isEmpty) return null;

    for (final modelName in _fallbackModels) {
      try {
        final model = GenerativeModel(model: modelName, apiKey: _apiKey);
        final response = await model.generateContent([Content.text(prompt)]);
        final text = response.text?.trim();
        if (text != null && text.isNotEmpty) {
          return text;
        }
      } catch (e) {
        debugPrint('Aviso Gemini ($modelName): $e');
        // Si es 503 o sobrecarga, continúa al siguiente modelo de la lista
        continue;
      }
    }
    throw Exception('Todos los modelos están temporalmente congestionados.');
  }

  String _buildFinancialContext(FinanceState state) {
    final topCategories = state.expensesByCategory.entries
        .map((e) => '${e.key}: ${e.value.toColombianCurrency()}')
        .join(', ');

    final recent = state.transactions
        .take(5)
        .map(
          (t) =>
              '${t.type == TransactionType.income ? "+" : "-"}${t.amount.toColombianCurrency()} (${t.concept} - ${t.category})',
        )
        .join('; ');

    return '''
Contexto financiero actual del usuario:
- Balance general: ${state.balance.toColombianCurrency()}
- Ingresos totales: ${state.totalIncome.toColombianCurrency()}
- Gastos totales: ${state.totalExpense.toColombianCurrency()}
- Meta de ahorro mensual: ${state.monthlyGoal.toColombianCurrency()}
- Gastos por categoría: ${topCategories.isEmpty ? 'Sin gastos aún' : topCategories}
- Últimos movimientos: $recent
''';
  }

  /// 1. HomeScreen (Opción 2): Diagnóstico breve bajo demanda
  Future<String> analyzeFinancialStatus(FinanceState state) async {
    if (!state.hasTransactionHistory) {
      return 'Aún no hay historial suficiente para analizar tus finanzas.';
    }

    if (_apiKey.isEmpty) {
      final ratio = state.totalIncome > 0
          ? (state.totalExpense / state.totalIncome * 100).toStringAsFixed(0)
          : '100';
      return 'Has gastado el $ratio% de tus ingresos registrados. Tu balance actual es de ${state.balance.toColombianCurrency()}.';
    }

    try {
      final prompt =
          '''
${_buildFinancialContext(state)}
Actúa como VIA, un asistente financiero conciso. Da un diagnóstico objetivo en máximo 2 oraciones cortas (menos de 35 palabras) destacando el estado del balance o la categoría con mayor gasto y una acción concreta. Sin saludos.
''';
      final result = await _generateWithFallback(prompt);
      return result ?? 'No se pudo generar el análisis en este momento.';
    } catch (_) {
      return 'Balance actual de ${state.balance.toColombianCurrency()}. Revisa tus categorías principales para optimizar tu ahorro.';
    }
  }

  /// 2. Expenses / IncomesScreen (Opción 1): Autoclasificación basada en historial real
  String? predictCategoryFromHistory({
    required FinanceState state,
    required String conceptInput,
    required TransactionType type,
  }) {
    if (!state.hasTransactionHistory) return null;

    final query = conceptInput.trim().toLowerCase();
    if (query.length < 2) return null;

    for (final tx in state.transactions) {
      if (tx.type != type) continue;
      final historicalConcept = tx.concept.trim().toLowerCase();
      if (historicalConcept.contains(query) ||
          query.contains(historicalConcept)) {
        return tx.category;
      }
    }
    return null;
  }

  /// 3. ReportsScreen (Opción 2): Coach Financiero con preguntas rápidas
  Future<String> askFinancialCoach({
    required FinanceState state,
    required String question,
  }) async {
    if (!state.hasTransactionHistory) {
      return 'Registra al menos un ingreso o gasto para activar el Coach Financiero.';
    }

    if (_apiKey.isEmpty) {
      final ahorro = state.balance > 0 ? state.balance : 0.0;
      return 'Con tu historial actual tienes un saldo neto de ${ahorro.toColombianCurrency()}. Configura tu GEMINI_API_KEY para respuestas personalizadas con IA.';
    }

    try {
      final prompt =
          '''
${_buildFinancialContext(state)}
Pregunta del usuario al Coach Financiero: "$question"
Responde en español, de forma práctica, empática y directa en máximo 3 oraciones usando exclusivamente los datos reales proporcionados.
''';
      final result = await _generateWithFallback(prompt);
      return result ?? 'No se obtuvo respuesta del Coach Financiero.';
    } catch (_) {
      return 'Los servidores de IA tienen alta demanda en este momento. Intenta de nuevo en unos segundos.';
    }
  }
}
