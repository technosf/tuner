/**
 * SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file PlayButton.vala
 * @author technosf
 * @date 2024-12-01
 * @since 2.0.0
 * @brief Player 'PLAY' button
 */

using Gtk;
using Tuner.Controllers;

/**
 * @class PlayButton
 *
 * @brief A custom widget that shows player state.
 *
 * PlayButton can control the player and does so by an ActionEvent linkage defined in the HeaderBar
 *
 * @extends Gtk.Button
 */
public class Tuner.Widgets.FilterButton : Gtk.Button
{

private static bool FILTER_ALL = false;

private bool _active = false;
private FilterPopover _popover;

/* Public */

/**
 * @class PlayButton
 *
 * @brief Create the play button and hook it up to the PlayerController
 *
 */
	public FilterButton()
	{
		Object();

		image     = new Gtk.Image.from_icon_name (
			"view-more-horizontal",
			IconSize.LARGE_TOOLBAR
			);
		sensitive = true;
		relief  = ReliefStyle.NONE;
		valign = Align.CENTER;
		opacity = 0.4;
		

		event.connect ((e) => {
			if (e.type == Gdk.EventType.BUTTON_PRESS && e.button.button == 1) 
			{
				if (_popover == null) {
					_popover = new FilterPopover();
				}
				if (_active) {
					opacity = 0.3;
					_active = false;
					relief  = ReliefStyle.NONE;
					_popover.hide();
				} else {
					opacity = 0.7;
					_active = true;
					relief  = ReliefStyle.HALF;
					_popover.show();
				}
				warning ("FilterButton clicked, active: %s", _active ? "true" : "false");
				return true;
			} // if
			return false;
        }); // event.connect
	} //  FilterButton
} //  FilterButton
