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

- `src/Application.vala`
  - Owns the shared `events` bus instance.
  - Emits `connectivity_changed` when `is_online`/`is_offline` changes.
  - Instantiates and starts `StartupCoordinator` after creating the main window.

- `src/Widgets/Window.vala`
  - Consumes app-level connectivity events to update interactive window state.
  - No longer owns autoplay orchestration.

- `src/Widgets/HeaderBar.vala`
  - Consumes app-level connectivity events for restart-after-outage behavior.
  - Keeps playback restart logic local to header bar UI behavior.

- `src/meson.build`
  - Registers the new event/coordinator source files in build inputs.

## Event Flow (Connectivity)

1. `Application` detects network change.
2. `Application` updates `is_online` and `is_offline`.
3. `Application` emits `events.connectivity_changed(...)`.
4. Subscribers react:
   - `Window` updates active UI state.
   - `HeaderBar` manages restart-after-outage behavior.
   - `StartupCoordinator` tries deferred autoplay when online.

## Design Notes

- Keep local widget events in widget files.
- Use `AppEventBus` for cross-component events that otherwise create tight coupling.
- Use coordinators for workflows that span UI + services + application state.
