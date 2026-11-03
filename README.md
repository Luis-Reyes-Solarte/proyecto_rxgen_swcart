# 🛒 RxGen SWCart

**RxGen SWCart** es una aplicación móvil de gestión de finanzas personales y seguimiento de listas de compras para supermercado, desarrollada en **Flutter**. El proyecto integra análisis dinámico de ingresos y gastos, metas de ahorro y espacios modulares para asistentes y motores de recomendación basados en Inteligencia Artificial.

---

## 🚀 Características Principales

-   📊 **Dashboard Financiero:** Visualización en tiempo real del balance general, ingresos y desglose de gastos por categoría (Comida, Transporte, Hogar, etc.).
-   🛒 **Mi Carrito (Lista de Compras):** Control de productos pendientes y completados para el supermercado.
-   📈 **Reportes y Análisis:** Seguimiento del ahorro mensual, tasa de ahorro e histórico mes a mes frente a metas.
-   🤖 **Integración de Inteligencia Artificial (IA Slots):**
    -   **Alertas Inteligentes (VIA):** Detección de incrementos o patrones anómalos de gastos.
    -   **Sugerencias por Ciclo de Consumo:** Recomendación automática de productos para la lista de compras según hábitos del usuario.
    -   **Coach Financiero Interactivo:** Interfaz conversacional (LLM) para consultas financieras en tiempo real.

---

## 📁 Estructura del Proyecto

El proyecto sigue una arquitectura modular y limpia en Flutter:

```text
lib/
├── main.dart             # Scaffold principal con navegación superior e inferior fija
└── screens/              # Módulos de pantalla de la aplicación
    ├── home_screen.dart           # Pantalla de Inicio / Dashboard
    ├── shopping_cart_screen.dart  # Pantalla de Lista de Compras / Carrito
    └── reports_screen.dart        # Pantalla de Análisis Financiero y Coach IA

```

## 🛠️ Tecnologías Utilizadas

-   Framework: Flutter (Dart)

-   Diseño UI: Material Design 3

-   Estándar de Commits: Conventional Commits

## 💻 Instalación y Ejecución

### Clonar el repositorio

```Bash
git clone [https://github.com/tu-usuario/rxgen-swcart.git](https://github.com/tu-usuario/rxgen-swcart.git)
cd rxgen-swcart
```

### Instalar dependencias

```Bash
flutter pub get
```

### Ejecutar en un dispositivo o emulador

```Bash
flutter run
```
