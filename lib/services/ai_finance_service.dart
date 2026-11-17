import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:proyecto_rxgen_swcart/models/transaction_model.dart';
import 'package:proyecto_rxgen_swcart/services/finance_state.dart';

class AiFinanceService {
  static final AiFinanceService instance = AiFinanceService._internal();
  factory AiFinanceService() => instance;
  AiFinanceService._internal();

  // Pasa tu API key ejecutando: flutter run --dart-define=GEMINI_API_KEY=tu_clave
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  GenerativeModel? _getModel() {
    if (_apiKey.isEmpty) return null;
    return GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
  }

  String _buildFinancialContext(FinanceState state) {
    final topCategories = state.expensesByCategory.entries
        .map((e) => '${e.key}: \$${e.value.toStringAsFixed(2)}')
        .join(', ');

    final recent = state.transactions
        .take(5)
        .map(
          (t) =>
              '${t.type == TransactionType.income ? "+" : "-"}\$${t.amount.toStringAsFixed(2)} (${t.concept} - ${t.category})',
        )
        .join('; ');

    return '''
Contexto financiero actual del usuario:
- Balance general: \$${state.balance.toStringAsFixed(2)}
- Ingresos totales: \$${state.totalIncome.toStringAsFixed(2)}
- Gastos totales: \$${state.totalExpense.toStringAsFixed(2)}
- Meta de ahorro mensual: \$${state.monthlyGoal.toStringAsFixed(2)}
- Gastos por categoría: ${topCategories.isEmpty ? 'Sin gastos aún' : topCategories}
- Últimos movimientos: $recent
''';
  }

  /// 1. HomeScreen (Opción 2): Diagnóstico breve bajo demanda
  Future<String> analyzeFinancialStatus(FinanceState state) async {
    if (!state.hasTransactionHistory) {
      return 'Aún no hay historial suficiente para analizar tus finanzas.';
    }

    final model = _getModel();
    if (model == null) {
      // Respaldo inteligente local si no se configuró GEMINI_API_KEY
      final ratio = state.totalIncome > 0
          ? (state.totalExpense / state.totalIncome * 100).toStringAsFixed(0)
          : '100';
      return 'Has gastado el $ratio% de tus ingresos registrados. Tu balance actual es de \$${state.balance.toStringAsFixed(2)}.';
    }

    try {
      final prompt =
          '''
${_buildFinancialContext(state)}
Actúa como VIA, un asistente financiero conciso. Da un diagnóstico objetivo en máximo 2 oraciones cortas (menos de 35 palabras) destacando el estado del balance o la categoría con mayor gasto y una acción concreta. Sin saludos.
''';
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text?.trim() ??
          'No se pudo generar el análisis en este momento.';
    } catch (_) {
      return 'Balance actual de \$${state.balance.toStringAsFixed(2)}. Revisa tus categorías principales para optimizar tu ahorro.';
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

    // Busca en las transacciones históricas del mismo tipo
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

    final model = _getModel();
    if (model == null) {
      final ahorro = state.balance > 0 ? state.balance : 0.0;
      return 'Con tu historial actual tienes un saldo neto de \$${ahorro.toStringAsFixed(2)}. Configura tu GEMINI_API_KEY para respuestas personalizadas con IA.';
    }

    try {
      final prompt =
          '''
${_buildFinancialContext(state)}
Pregunta del usuario al Coach Financiero: "$question"
Responde en español, de forma práctica, empática y directa en máximo 3 oraciones usando exclusivamente los datos reales proporcionados.
''';
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text?.trim() ??
          'No se obtuvo respuesta del Coach Financiero.';
    } catch (_) {
      return 'Ocurrió un error al consultar al Coach Financiero. Verifica tu conexión.';
    }
  }
}
