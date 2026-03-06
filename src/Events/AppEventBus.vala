/**
 * SPDX-FileCopyrightText: Copyright © 2026 <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file AppEventBus.vala
 */

namespace Tuner.Events {

	/**
	 * @brief Typed event hub for application-level cross-component events.
	 */
	public class AppEventBus : GLib.Object
	{
		/** @brief Fired when connectivity state changes. */
		public signal void connectivity_changed (bool is_online, bool is_offline);
	}
}
