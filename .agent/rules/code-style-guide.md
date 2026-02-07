---
trigger: always_on
---

1. Architecture: Feature-First & Layered
We do not organize by file type (e.g., lib/blocs). We organize by Business Domain.

Structure: Use very_good_cli standards.

lib/features/: One folder per feature.

packages/: Local packages for extracted logic (e.g., api_client, local_storage, domain_repository).

Layer Responsibilities:

Data Layer: API clients, Data Providers, and DTOs.

Domain Layer: Pure Dart. Entities, Repository Interfaces, and Failure models. No framework dependencies.

Presentation Layer: BLoCs, Widgets, and UI logic.

2. Code Quality & Standards
"The best code is boringly predictable."

Linting: package:very_good_analysis is mandatory. Zero warnings allowed. No // ignore.

Immutability: Use const constructors whenever possible. If a widget can be const, it must be const.

Documentation: All public members must be documented using triple-slash /// comments.

Naming: Strictly follow . Use descriptive names; avoid abbreviations (e.g., use userRepository, not userRepo).

3. State Management: The BLoC Pattern
We are a BLoC-centric shop. Use the library as intended.

4. Testing: The "Road to 100%"
In VGV, untested code is broken code.

Unit Tests: Mandatory for every BLoC, Repository, and Data Provider.

Widget Tests: Test every widget in the presentation layer. Ensure it reacts correctly to different BLoC states.

Mocking: Use package:mocktail. We avoid code-generation for mocks (no mockito).

Golden Tests: Highly recommended to prevent visual regressions.

Coverage: 100% code coverage is the goal and the standard.

5. Errors, i18n, & Navigation
Error Handling: Never leak raw exceptions to the UI. Repositories must catch exceptions and return controlled Failure objects or an Either type.

Internationalization (i18n): Use .arb files. Hardcoded strings like Text('Hello') are strictly prohibited. Use context.l10n.helloWorld.

Atomic Widgets: Break down large build methods. If a widget has more than 60 lines or deep nesting, extract it into smaller, private sub-widgets.

Navigation: Use go_router or declarative routing. Keep routes typed and decoupled from the UI.

6. Automation (CI/CD)
The machine must verify what the human misses.

Workflow: Every project must include a .github/workflows/main.yml.

Mandatory Checks:

Format: dart format --set-exit-if-changed .

Analyze: flutter analyze

Test: flutter test --coverage (The build must fail if the coverage threshold is not met).