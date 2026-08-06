# PokeMini — Spec técnico y modo de trabajo

Spec para construir **PokeMini**, una Pokédex iOS (lista + detalle + favoritos) en SwiftUI, con arquitectura Clean + MVVM y persistencia local. El desarrollador viene de Android (Kotlin, Jetpack Compose, Clean Architecture, MVVM, Room, DataStore) y su objetivo principal es **aprender iOS**, no solo tener la app terminada.

---

## Modo de trabajo (IMPORTANTE — leer antes de escribir código)

Actúa como **tutor técnico**, no como generador de código en bloque:

1. Trabaja **una fase a la vez** (ver Fases abajo). No avances a la siguiente fase hasta que el desarrollador lo confirme.
2. En cada fase: explica primero el **concepto iOS** y su **equivalente en Android** (ej. `@Observable` ≈ `StateFlow`, SwiftData ≈ Room, `@AppStorage` ≈ DataStore Preferences), luego muestra el código.
3. El desarrollador escribirá parte del código a mano. Cuando te comparta su versión, **revísala como code review**: señala errores, código no idiomático en Swift, y sugiere la forma idiomática con explicación breve.
4. Al cerrar cada fase, haz 2-3 preguntas rápidas tipo entrevista sobre lo construido (ej. "¿por qué `Pokemon` es struct y no class?", "¿qué pasa si no usas `weak self` aquí?").
5. Compila y corre después de cada fase (`xcodebuild` o desde Xcode). Nunca dejes el proyecto en estado que no compila entre fases.
6. Commits pequeños por fase con mensajes convencionales (`feat:`, `refactor:`, `test:`).

---

## Objetivos

- Aprender Swift y SwiftUI aprovechando la experiencia previa en Kotlin/Compose.
- Practicar Clean Architecture + MVVM idiomáticos en iOS.
- Cubrir el stack que preguntan en entrevistas: networking con `async/await`, manejo de estado, navegación, persistencia (SwiftData + UserDefaults), inyección de dependencias manual y tests unitarios.
- Terminar con un proyecto compilable y presentable en GitHub.

## No-objetivos

- UIKit (solo SwiftUI en esta versión).
- Backend propio, autenticación o push notifications.
- Publicación en App Store / firma de código.
- Librerías de terceros (todo con frameworks del sistema: URLSession, SwiftData, Observation). Excepción permitida: ninguna en v1.
- Paginación infinita perfecta ni prefetching (v1 usa paginado simple por botón o `onAppear` del último ítem).

## Stack y requisitos técnicos

- **Swift 5.10+**, **SwiftUI**, target **iOS 17+** (necesario para `@Observable` y SwiftData).
- **Observation framework** (`@Observable`) para los ViewModels — NO usar `ObservableObject`/`@Published` salvo para explicar la diferencia en comentarios.
- **URLSession + async/await + Codable** para networking (sin Alamofire).
- **SwiftData** para persistencia estructurada (equivalente de Room).
- **UserDefaults vía `@AppStorage`** para preferencias simples (equivalente de DataStore Preferences).
- **Swift Testing** (`import Testing`, macro `@Test`) para tests unitarios; si el toolchain no lo soporta, XCTest.
- API: **PokeAPI** (`https://pokeapi.co/api/v2/`), sin API key.

## Arquitectura

```
PokeMini/
├── Domain/
│   ├── Entities/            # Pokemon, PokemonDetail (structs puros)
│   ├── Repositories/        # protocols
│   └── UseCases/
├── Data/
│   ├── DTOs/                # Codable + mappers toDomain()
│   ├── Network/             # NetworkService genérico
│   ├── Local/               # SwiftData models + LocalDataSource
│   └── Repositories/        # implementaciones
├── Presentation/
│   ├── PokemonList/
│   ├── PokemonDetail/
│   └── Favorites/
└── App/
    ├── PokeMiniApp.swift
    └── AppDependencies.swift   # composition root (DI manual)
```

Reglas:
- Domain no importa SwiftUI, SwiftData ni Foundation más allá de lo básico. Sin dependencias hacia afuera.
- Los DTOs y los modelos de SwiftData nunca cruzan a Presentation: siempre se mapean a entidades de dominio.
- DI manual por constructor desde un composition root (`AppDependencies`). Explicar por qué en iOS no se suele necesitar un Hilt.
- Estado de UI con `enum ViewState { loading, loaded, error }` (equivalente del sealed class UiState).

## Fases

### Fase 0 — Setup
Crear proyecto Xcode (SwiftUI, iOS 17), estructura de carpetas, git init, `.gitignore` de Xcode. Verificar que compila y corre en simulador.
- [ ] El proyecto compila y muestra pantalla inicial.

### Fase 1 — Domain
Entidades `Pokemon` y `PokemonDetail`, protocol `PokemonRepository`, use cases `GetPokemonListUseCase` y `GetPokemonDetailUseCase`.
- [ ] Domain compila sin imports de UI ni de Data.

### Fase 2 — Networking (Data remota)
`NetworkService` genérico con `async throws`, enum `NetworkError`, DTOs `Decodable` con mappers `toDomain()`, `PokemonRepositoryImpl` (solo remoto por ahora).
- [ ] Dado un endpoint válido, el repositorio devuelve `[Pokemon]` mapeados.
- [ ] Dado un status ≠ 2xx, lanza `NetworkError.invalidResponse`.

### Fase 3 — Lista (Presentation)
`PokemonListViewModel` (`@Observable`, `@MainActor`) con `ViewState`, `PokemonListView` con `List`, `AsyncImage`, `.task`, estados de carga/error con retry, `NavigationStack`.
- [ ] Al abrir la app se ven los primeros 20 pokémon con imagen y nombre.
- [ ] Sin red, se muestra error con botón Reintentar que funciona.

### Fase 4 — Detalle + navegación
Endpoint de detalle (`/pokemon/{id}`: tipos, peso, altura, stats base), `PokemonDetailView` + ViewModel, navegación con `navigationDestination(for:)`.
- [ ] Tap en un ítem navega al detalle y carga sus datos.

### Fase 5 — Persistencia: SwiftData (el "Room" de iOS)
- Modelo `@Model FavoritePokemon` y `@Model CachedPokemon`.
- **Favoritos**: botón en el detalle para marcar/desmarcar; pantalla `FavoritesView` (tab o toolbar) que lista favoritos offline.
- **Caché de lista**: al cargar la lista con éxito, guardarla; si falla la red, mostrar caché con un banner "modo offline".
- Acceso a SwiftData encapsulado en un `LocalDataSource` dentro de Data — las Views NO usan `@Query` directamente (explicar el trade-off: `@Query` es cómodo pero acopla la UI a la persistencia, como si un Composable usara un DAO de Room).
- Explicar mapeo mental: `@Model` ≈ `@Entity`, `ModelContext` ≈ DAO + transacciones, `ModelContainer` ≈ Database.
- [ ] Marcar favorito, cerrar y reabrir la app: el favorito persiste.
- [ ] Con red apagada tras una primera carga exitosa, la lista se muestra desde caché.

### Fase 6 — Persistencia simple: `@AppStorage` (el "DataStore Preferences" de iOS)
Pantalla o menú de ajustes mínimo con 2 preferencias: orden de la lista (por id / por nombre) y toggle de "mostrar sprites shiny". Guardadas con `@AppStorage`.
- [ ] Cambiar una preferencia, matar la app y reabrir: se conserva y se aplica.

### Fase 7 — Tests
Tests unitarios de: mappers DTO→Domain, `GetPokemonListUseCase` con un repositorio fake (protocol → fake, igual que en Android), y transiciones de `ViewState` del ViewModel de lista (éxito y error).
- [ ] Suite de tests en verde desde línea de comandos.

### Fase 8 — Pulido y README
Estados vacíos, accesibilidad básica (`accessibilityLabel`), README en inglés con screenshot, descripción de arquitectura y decisiones (material para la entrevista).
- [ ] README explica arquitectura y el mapeo Android↔iOS aprendido.

## Preguntas abiertas (resolver con el desarrollador durante las fases)

- ¿Favoritos como tercer tab (`TabView`) o como pantalla desde toolbar? (decidir en Fase 5)
- ¿Paginación en v1 o dejar los primeros 151? (decidir en Fase 3; si se corta, va a parking lot)

## Parking lot (v2, no construir ahora)

- Búsqueda con `.searchable`
- Widgets (WidgetKit)
- Migración de una pantalla a UIKit para practicar interop
- Localización es/en
