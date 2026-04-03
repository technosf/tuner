/**
 * SPDX-FileCopyrightText: Copyright © 2026 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file FilterPopover.vala
 */



/**
 *
 * @brief Tuner preferences and selections.
 */
public class Tuner.Widgets.FilterPopover : Gtk.Popover
{

	 construct
    {

		var about_menuitem = new Gtk.ModelButton ();
		about_menuitem.text        = _("About");
		about_menuitem.show_all ();
		this.add (about_menuitem);
	
	}     // 




} // class FilterPopover
