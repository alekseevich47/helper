# TASKS_start — Phase 1: UI + локальное ядро (без AI и PocketBase)

Цель: заменить шаблон Flutter (counter demo) на рабочий offline-first каркас CallMemo — навигация, Hive, детекция звонков, плеер, заглушки AI — **без единого сетевого запроса**.

Решения, принятые до этого файла (не пересматривать без явной причины):

1. **Phase 1 = только локально.** Whisper, DeepSeek, PocketBase, `dio`, `flutter_dotenv`, `ffmpeg_kit_flutter_audio` — ни пакета, ни кода.
2. **State — Riverpod**, навигация — **go_router**, локальная БД — **Hive** (схема — `.cursor/rules/stack.mdc`, раздел «Локальная БД»).
3. **Запись звонков** — не через API линии, а через файлы системной автозаписи «Телефон» + MediaStore fallback (см. `stack.mdc` «Запись звонков»).
4. **Hive-модели и адаптеры** — plain Dart-классы + `@GenerateAdapters` в `hive_adapters.dart` (см. `stack.mdc` «Локальная БД»); агент **не меняет поля/typeId** без согласования. Задача 4 — **выполнена**.
5. **Качество:** после каждой задачи — `flutter analyze` без errors; Phase 1 завершается только когда приложение собирается и все табы работают офлайн.
6. **Архитектурный ориентир:** `.cursor/rules/stack.mdc` (актуализирован под этот репозиторий); эталон планирования — `Tasks/TASKS_100.md` (структура задач, не домен).

---

## Архитектурная схема (Phase 1)

```
main.dart
  → WidgetsFlutterBinding + Hive.initFlutter + registerHiveAdapters() + initHive()
  → CallDetectionService.init()   // telephony + scan, Phase 1
  → ProviderScope → CallMemoApp (app.dart)
       → settingsProvider (theme, locale)
       → MaterialApp.router(routerConfig: appRouter)

appRouter (ShellRoute, 4 таба)
  /              → CallsListScreen      → callsBoxProvider
  /calendar      → CalendarScreen       → eventsBoxProvider
  /notes         → NotesListScreen      → notesBoxProvider
  /profile       → ProfileScreen        → заглушка тарифа
  /call/:id      → CallDetailScreen     → just_audio + заглушки AI
  /notes/:id     → NoteEditorScreen
  /settings      → SettingsScreen       → settingsBox (read/write)

CallDetectionService
  CALL_STATE_IDLE → _scanForNewRecording()
    → brand path / MediaStore
    → dedupe by audioFilePath
    → callsBox.put → CallRecord(status: 'new')
    → flutter_local_notifications (инфо о новом звонке)
```

**Phase 1 не включает:** sync, auth, транскрипцию, онбординг, FAB загрузки файла с диска (достаточно debug-кнопки «тестовый звонок»).

---

## БД (Hive) — Задача 4 ✓

Plain Dart-классы в `data/local/models/`, адаптеры через `@GenerateAdapters` в `data/local/adapters/hive_adapters.dart` → `hive_adapters.g.dart`, `hive_registrar.g.dart`, `hive_adapters.g.yaml`. **Не** использовать `@HiveType` + `part '../adapters/…'` на моделях — генератор кладёт `*.g.dart` рядом с `part`.

`hive_provider.dart`: `registerHiveAdapters()`, `initHive()`, box-провайдеры, `settingsProvider`. Агент в задачах 5–12:

- вызывает `initHive()` из `main.dart` (регистрация адаптеров уже внутри);
- импортирует провайдеры в экранах;
- не меняет typeId и имена полей.

Схема полей — `.cursor/rules/stack.mdc` («Локальная БД»). Кратко:

| typeId | Класс | Box |
|--------|-------|-----|
| 0 | `CallRecord` | `calls` |
| 1 | `CallEvent` | `events` |
| 2 | `Note` | `notes` |
| 3 | `AppSettings` | `settings` |

Генерация: `flutter pub run build_runner build` (на Windows `dart run build_runner` может падать).

---

## Задача 0 — Починка `pubspec.yaml` + baseline

**Читать:**
- `pubspec.yaml` (сейчас **дублируются** секции `dev_dependencies` и `flutter` — строки ~48–115)
- `.cursor/rules/stack.mdc` — «Зависимости по фазам» / Phase 1

**Править:** `pubspec.yaml`

**Шаги:**
1. Оставить **одну** секцию `dependencies`, **одну** `dev_dependencies`, **одну** `flutter:`.
2. Итоговый `dependencies` (Phase 1):

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.6.1
  go_router: ^15.1.3
  hive_ce: ^2.19.3
  hive_ce_flutter: ^2.3.4
  just_audio: ^0.9.46
  permission_handler: ^11.4.0
  table_calendar: ^3.1.3
  uuid: ^4.5.1
  intl: ^0.19.0
  flutter_local_notifications: ^18.0.1
  path_provider: ^2.1.5
  device_info_plus: ^11.3.3
  share_plus: ^10.1.4
```

3. `dev_dependencies`: `flutter_test`, `flutter_lints: ^6.0.0`, `hive_ce_generator: ^1.11.2`, `build_runner: ^2.4.14`.
4. В `flutter:` — `uses-material-design: true`, `generate: true`.
5. `flutter pub get` → `flutter analyze` — зафиксировать текущие issues (counter demo ожидаем).

---

## Задача 1 — Структура каталогов `lib/`

**Читать:** `.cursor/rules/stack.mdc` — «Структура lib/»

**Создать** пустые директории (файлы — в следующих задачах):

```
lib/
  app.dart
  router/app_router.dart
  core/constants/
  core/theme/
  core/l10n/
  core/utils/
  data/local/models/          ← plain Dart-классы (Задача 4 ✓)
  data/local/adapters/        ← hive_adapters.dart + *.g.dart (Задача 4 ✓)
  data/local/hive_provider.dart
  domain/services/
  features/calls/screens/
  features/calls/widgets/
  features/calendar/screens/
  features/notes/screens/
  features/profile/screens/
  features/settings/screens/
  shared/widgets/
```

**Не удалять** `lib/main.dart` — переписать в Задаче 6.

---

## Задача 2 — Core: константы, тема, утилиты

**Читать:** `stack.mdc` — «Запись звонков», «Локализация и тема», PocketBase лимиты (для констант тарифов)

**Создать:**

### `lib/core/constants/app_constants.dart`

- `BrandPaths` — samsung / xiaomi / oppo + комментарий про MediaStore fallback.
- `TariffLimits` — `free = 60`, `basic = 300` (pro — безлимит, комментарий).

### `lib/core/theme/app_theme.dart`

- `lightTheme()` / `darkTheme()` — Material 3, `ColorScheme.fromSeed(seedColor: Colors.deepPurple)`.

### `lib/core/utils/format_utils.dart`

- `formatDuration` (секунды или `Duration` → `мм:сс` / `чч:мм:сс`).
- `formatDateTime`, `formatDate` — через `intl`, локаль из контекста или параметр.
- `formatFileSize(int bytes)`.

---

## Задача 3 — l10n (`ru` + `en`)

**Читать:** `stack.mdc` — l10n; `pubspec.yaml` → `generate: true`

**Создать:**

- `lib/core/l10n/app_ru.arb` — ключи минимум: `appTitle`, `tabCalls`, `tabCalendar`, `tabNotes`, `tabProfile`, `noCalls`, `noSummary`, `noTranscription`, `noEvents`, `noNotes`, `summary`, `transcription`, `events`, `settings`, `theme`, `language`, `autoTranscribe`, `notifyBeforeTranscribe`, `darkTheme`, `lightTheme`, `systemTheme`, `play`, `pause`, `retry`, `save`, `delete`, `cancel`, `newNote`, `editNote`, `profile`, `tariff`, `minutesUsed`, `free`, `upgrade`, `addFile`, `pullToRefresh`, `processingFailed`, `unknown`, `comingSoon`, `audioNotFound`, `newCallRecorded`.
- `lib/core/l10n/app_en.arb` — те же ключи, английские значения.
- `l10n.yaml` в **корне** проекта:

```yaml
arb-dir: lib/core/l10n
template-arb-file: app_ru.arb
output-localization-file: app_localizations.dart
```

**Шаги:** `flutter gen-l10n` (или `flutter pub get` при `generate: true`) — убедиться, что `.dart_tool/flutter_gen/gen_l10n/` создаётся.

---

## Задача 4 — Hive ✓

**Создано:**

| Файл | Назначение |
|------|------------|
| `data/local/models/call_record.dart` | plain class, typeId 0 (через `@GenerateAdapters`) |
| `data/local/models/call_event.dart` | typeId 1 |
| `data/local/models/note.dart` | typeId 2 |
| `data/local/models/app_settings.dart` | typeId 3, defaults: autoTranscribe false, notifyBeforeTranscribe true |
| `data/local/adapters/hive_adapters.dart` | `@GenerateAdapters([AdapterSpec<…>(), …])`, `part 'hive_adapters.g.dart'` |
| `data/local/hive_provider.dart` | `registerHiveAdapters()`, `initHive()`, box-провайдеры, `settingsProvider` |

**Проверка:** `flutter pub run build_runner build` без ошибок; `dart analyze lib/data/local` — 0 issues.

---

## Задача 5 — `main.dart` + `app.dart`

**Читать:** `stack.mdc` — «Правила кода», Phase 1 границы

**Править:** `lib/main.dart` — полная замена:

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `await Hive.initFlutter()`
3. `await initHive()` из `hive_provider.dart` (внутри — `registerHiveAdapters()` → `Hive.registerAdapters()`)
4. `await CallDetectionService().init()` (если Задача 11 уже готова — иначе временно закомментировать с TODO)
5. `runApp(const ProviderScope(child: CallMemoApp()))`

**Создать:** `lib/app.dart` — `CallMemoApp extends ConsumerWidget`:

- `ref.watch(settingsProvider)` → `themeMode`, `language`
- `MaterialApp.router`: `theme`/`darkTheme` из `app_theme.dart`, `locale: Locale(language)`, delegates + supportedLocales из `AppLocalizations`, `routerConfig: appRouter`

---

## Задача 6 — Роутер (`go_router`)

**Читать:** `stack.mdc` — «Экраны и маршруты»

**Создать:** `lib/router/app_router.dart`

- `StatefulShellRoute.indexedStack` — 4 ветки: `/`, `/calendar`, `/notes`, `/profile`.
- `NavigationBar` (Material 3): `Icons.phone`, `calendar_month`, `notes`, `person`; labels из l10n.
- Доп. маршруты **вне** shell (или nested): `/call/:id`, `/notes/:id`, `/settings`.
- Экспорт: `final appRouter = GoRouter(...)`.

---

## Задача 7 — Звонки: список и tile ✓

**Читать:** `stack.mdc` — статусы звонка, Phase 1 FAB

**Создать:**

### `features/calls/screens/calls_list_screen.dart`

- `ConsumerWidget`, данные из `callsBoxProvider`, сортировка `dateTime` desc.
- AppBar: заголовок + иконка settings → `/settings`.
- `RefreshIndicator` — перечитать box / invalidate provider.
- Пусто → `EmptyStateWidget`.
- `ListView.builder` + `CallListTile`.
- FAB: debug — `showDialog` «Выбор файла позже» + кнопка «Добавить тестовый звонок» (создаёт `CallRecord` с uuid, status `new`, без audio — для UI-теста).

### `features/calls/widgets/call_list_tile.dart`

- Аватар (первая буква), title, subtitle (дата + длительность), trailing — chip статуса (цвета: new/pending/processing/done/error).
- Tap → `context.push('/call/${call.id}')`.

---

## Задача 8 — Детали звонка + плеер

**Создать:** `features/calls/screens/call_detail_screen.dart`

- `callId` из `GoRouterState.pathParameters`.
- AppBar: contactName ?? phoneNumber ?? l10n.unknown.
- **Плеер:** если `audioFilePath != null` — `AudioPlayer` (`just_audio`), play/pause, slider; иначе — l10n.audioNotFound.
- `DefaultTabController` + 3 вкладки (l10n.summary / transcription / events):
  - текст из Hive или `EmptyStateWidget`;
  - кнопка retry — **disabled**, tooltip/subtitle l10n.comingSoon.

**Важно:** `dispose()` плеера в `State.dispose`.

---

## Задача 9 — Календарь + EmptyState

**Создать:**

### `shared/widgets/empty_state_widget.dart`

- Центр: `Icon` + `message` + optional `action`.

### `features/calendar/screens/calendar_screen.dart`

- `eventsBoxProvider`, `TableCalendar`, маркеры на днях с событиями.
- Список событий выбранного дня под календарём.
- Пусто → `EmptyStateWidget`.

---

## Задача 10 — Заметки, профиль, настройки

### `features/notes/screens/notes_list_screen.dart`

- Список из `notesBoxProvider`, sort `updatedAt` desc, FAB → `/notes/new`.

### `features/notes/screens/note_editor_screen.dart`

- `id == 'new'` — создание; иначе load из box.
- Save → `notesBox.put`, pop; Delete → `notesBox.delete`, pop.

### `features/profile/screens/profile_screen.dart`

- Карточка тарифа Free, прогресс 0 / `TariffLimits.free`, кнопка upgrade **disabled**.

### `features/settings/screens/settings_screen.dart`

- Тема: system / light / dark → запись в settings box, немедленное применение.
- Язык: ru / en → запись в settings box.
- `autoTranscribe`, `notifyBeforeTranscribe`, модель Whisper — **SwitchListTile/ListTile disabled** + subtitle l10n.comingSoon.

---

## Задача 11 — CallDetectionService

**Читать:** `stack.mdc` — «Запись звонков», `AndroidManifest.xml`, `BrandPaths`

**Создать:** `lib/domain/services/call_detection_service.dart`

**Шаги:**
1. Выбрать пакет telephony (`telephony` на pub.dev или аналог с phone state stream) — **добавить в pubspec только этот пакет**, если нужен; иначе stub + ручной scan из FAB.
2. `init()`: `device_info_plus` → brand; `permission_handler` → READ_PHONE_STATE, READ_MEDIA_AUDIO, POST_NOTIFICATIONS (с обработкой denied).
3. На `CALL_STATE_IDLE` → `_scanForNewRecording()`: путь по бренду → последний файл → dedupe → `CallRecord(status: 'new')` → `callsBox`.
4. `flutter_local_notifications` — канал «Новый звонок», текст из l10n.newCallRecorded.
5. Вызов `init()` из `main.dart` после Hive.

**Тест:** только на **реальном** устройстве с включённой автозаписью; эмулятор — UI-only.

---

## Задача 12 — Финализация и качество ✓

**Читать:** все файлы Phase 1; `stack.mdc` — «Ограничения»

**Шаги:**
1. Порядок init в `main.dart` (см. Задача 5) — проверить на cold start. ✓
2. `flutter analyze` / `dart analyze` — **0 errors**. ✓
3. Обновить `test/widget_test.dart` — smoke: pump `ProviderScope(child: CallMemoApp())`, найти элемент нижней навигации (например tabCalls), без counter. ✓
4. `flutter test` — pass. ✓
5. Ручной прогон: 4 таба, settings (theme/lang), notes CRUD, call detail tabs, debug test call в списке. (на устройстве/эмуляторе)
6. **grep по `lib/`:** нет импортов `dio`, `pocketbase`, `flutter_dotenv` — Phase 1 чист. ✓

---

## Порядок реализации

1. **Задача 0** (pubspec) — первой, иначе `pub get` может падать.
2. **Задачи 1–3** (структура, core, l10n) — параллельно допустимо.
3. **Задача 4** (Hive) — **выполнена**; блокер снят для задач 5–11.
4. **Задачи 5–6** (entry + router) — сразу после Hive.
5. **Задачи 7–10** (экраны) — любой порядок, независимы после router.
6. **Задача 11** (detection) — после Hive и calls list; можно параллельно с 7–10.
7. **Задача 12** — последней.

---

## Сводка: читать / править

| Задача | Читать | Создать | Редактировать |
|--------|--------|---------|---------------|
| 0 | `pubspec.yaml`, stack.mdc | — | `pubspec.yaml` |
| 1 | stack.mdc структура | каталоги `lib/` | — |
| 2 | stack.mdc тема/константы | `core/constants`, `theme`, `utils` | — |
| 3 | stack.mdc l10n | arb, `l10n.yaml` | — |
| 4 | stack.mdc Hive | models, hive_adapters, hive_provider | — ✓ |
| 5 | stack.mdc Phase 1 | `app.dart` | `main.dart` |
| 6 | stack.mdc маршруты | `router/app_router.dart` | — |
| 7–8 | stack.mdc calls | `features/calls/` | — |
| 9 | stack.mdc calendar | `calendar/`, `empty_state_widget` | — |
| 10 | stack.mdc notes/profile/settings | `features/notes`, `profile`, `settings` | — |
| 11 | stack.mdc Android recording | `call_detection_service.dart` | `main.dart`, maybe `pubspec.yaml` |
| 12 | — | — | `test/widget_test.dart`, финальный review ✓ |

---

## После Phase 1

Следующий план (не в этом файле): Phase 2 — AI pipeline + PocketBase по разделам `stack.mdc` «AI pipeline», «PocketBase», «Phase 2+». Перед стартом Phase 2 — новый `Tasks/TASKS_phase2.md` по образцу `TASKS_100.md`.

---

## Обновление `.cursor/rules/stack.mdc`

Раздел «Текущее состояние репозитория» обновлять по мере выполнения задач (галочки: структура создана, main переписан, Hive подключён, analyze clean). Phase 1 complete → убрать пометки «не создано» / «counter demo».
