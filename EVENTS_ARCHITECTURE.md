# Event Architecture

This document tracks the event orchestration introduced in the 2026 refactor.

## Files and Responsibilities

- `src/Events/AppEventBus.vala`
  - Defines typed cross-component application signals.
  - Current signals:
    - `connectivity_changed(bool is_online, bool is_offline)`

- `src/Coordinators/StartupCoordinator.vala`
  - Owns startup workflow orchestration.
  - Current workflow:
    - deferred autoplay of last station
    - waits for online connectivity before autoplay attempt
    - attempts autoplay once per app start

- `src/Coordinators/PlaybackRecoveryCoordinator.vala`
  - Owns restart-after-outage playback behavior.
  - Tracks whether playback was active before loss of connectivity.
  - Restarts playback on reconnect when `settings.play_restart` is enabled.

- `src/Application.vala`
  - Owns the shared `events` bus instance.
  - Emits `connectivity_changed` when `is_online`/`is_offline` changes.
  - Instantiates coordinators:
    - `PlaybackRecoveryCoordinator` during app construction.
    - `StartupCoordinator` after creating the main window.

- `src/Widgets/Window.vala`
  - Consumes app-level connectivity events to update interactive window state.
  - No longer owns autoplay orchestration.

- `src/Widgets/HeaderBar.vala`
  - Consumes app-level connectivity and player-state events for control-state updates.
  - No longer owns restart-after-outage orchestration.

- `src/meson.build`
  - Registers the new event/coordinator source files in build inputs.

## Event Flow (Connectivity)

1. `Application` detects network change.
2. `Application` updates `is_online` and `is_offline`.
3. `Application` emits `events.connectivity_changed(...)`.
4. Subscribers react:
   - `Window` updates active UI state.
   - `HeaderBar` updates visual controls.
   - `PlaybackRecoveryCoordinator` manages restart-after-outage behavior.
   - `StartupCoordinator` tries deferred autoplay when online.

## Design Notes

- Keep local widget events in widget files.
- Use `AppEventBus` for cross-component events that otherwise create tight coupling.
- Use coordinators for workflows that span UI + services + application state.

## Window Action Handling

- `src/Widgets/Window.vala` now centralizes action-state initialization with:
  - `sync_action_states_from_settings()`
- Boolean toggle actions now use a shared path:
  - `toggle_setting_action(...)`
- This reduces copy/paste logic across action handlers and lowers the chance of mismatched setting/action wiring.

## Search Debounce Ownership

- `src/Widgets/HeaderBar.vala`
  - Emits `searching_for_sig` immediately on text change.
  - No longer owns debounce timers.
- `src/Controllers/SearchController.vala`
  - Owns debounce and pending-search cancellation.
  - Uses configured `_max_search_results` instead of a hardcoded limit.
