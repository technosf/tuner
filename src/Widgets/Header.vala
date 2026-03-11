/**
 * SPDX-FileCopyrightText: Copyright © 2020-2024 Louis Brauer <louis@brauer.family>
 * SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file HeaderBox.vala
 *
 * @brief HeaderBox classes
 *
 */

using Gtk;
using Tuner.Controllers;
using Tuner.Models;
using Gee;
using Tuner.Services;

/*
 * @class Tuner.HeaderBox
 *
 * @brief Custom header bar that centrally displays station info and
 * packs app controls either side.
 *
 * This class extends HeaderBox to create a specialized header bar
 * with play/pause controls, volume control, station information display,
 * search functionality, and preferences menu.
 *
 * @extends HeaderBox
 */
public class Tuner.Widgets.Header : Gtk.Box
{

    /* Constants    */

    // Default icon name for stations without a custom favicon
    private const string DEFAULT_ICON_NAME = "tuner:internet-radio-symbolic";

	// Reveal animation delay in milliseconds
	private const uint REVEAL_DELAY = 400u;
	public const uint STATION_CHANGE_SETTLE_DELAY_MS = 1200u;
	public const uint SHUFFLE_ERROR_RETRY_DELAY_MS = 1500u;


    /* Public */


    // Public properties

    // Signals
    public signal void searching_for_sig (string text);
    public signal void search_has_focus_sig ();


    /*
        Private 
    */

	private SearchEntry _search_entry = new SearchEntry ();

	/*
		secondary display assets
	*/


	private Application _app;
	private PlayerController _player;
	private DataProvider.API _provider;


	private Revealer revealer = new Revealer();
	private HeaderBar _headerbar;
		

    /**
     * @brief Construct block for initializing the header bar components.
     *
     * This method sets up all the UI elements of the header bar, including
     * station info display, play button, preferences button, search entry,
     * star button, and volume button.
     *
     * @param app Application context for connectivity and app-level events.
     * @param window Parent window that owns this header bar.
     * @param player Player controller used for playback state and volume.
     * @param provider Data provider used for provider statistics tooltip text.
     */
    public Header(Application app, Window window, PlayerController player, DataProvider.API provider)
    {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 0
        );
		_app = app;
		_player = player;
		_provider = provider;

		revealer.set_transition_type(RevealerTransitionType.SLIDE_UP);
		revealer.reveal_child = false;

		_search_entry.placeholder_text = _("Station Search");
		_search_entry.set_margin_start(0);
		_search_entry.set_margin_end(0);
		_search_entry.set_margin_top(0);
		_search_entry.set_margin_bottom(0);
		_search_entry.valign = Align.CENTER;
		_search_entry.hexpand = true;
		_search_entry.activate.connect (() => {
			_search_entry.text = "";
			revealer.set_reveal_child(false);
		});
		_search_entry.changed.connect (() => {
			searching_for_sig(_search_entry.text);
		});
		_search_entry.focus_in_event.connect ((e) => {
			search_has_focus_sig ();
			return true;
		});

		var panel = new Box(Orientation.HORIZONTAL, 0);
		panel.margin = 0;
		panel.hexpand = true;
		revealer.hexpand = true;
		panel.vexpand = true;
		panel.valign = Align.FILL;
		panel.halign = Align.FILL;
		panel.get_style_context().add_class("search-revealer-bg");
		revealer.get_style_context().add_class("search-revealer-bg");

		var search_wrap = new Box(Orientation.HORIZONTAL, 0);
		search_wrap.hexpand = true;
		search_wrap.halign = Align.CENTER;
		_search_entry.halign = Align.CENTER;
		_search_entry.hexpand = false;
		search_wrap.add(_search_entry);
		panel.add(search_wrap);
		revealer.add(panel);

		revealer.size_allocate.connect((allocation) => {
			int target_width = (int)(allocation.width / 3);
			if (target_width > 0)
				_search_entry.set_size_request(target_width, -1);
		});

		_headerbar = new HeaderBar(app, window, player, provider);
		_headerbar.search_toggle_sig.connect(() => {
			var should_show = !revealer.reveal_child;
			if (should_show)
				_search_entry.text = "";
			revealer.set_reveal_child(should_show);
			if (revealer.reveal_child)
				_search_entry.grab_focus();
		});
		pack_start (_headerbar, false, false, 0);
		pack_start (revealer, false, false, 0);

	} // HeaderBox

	
    /* 
        Public 
    */

	public void stream_info(bool show)
	{
		_headerbar.stream_info(show);
	}

	public void stream_info_fast(bool fast)
	{
		_headerbar.stream_info_fast(fast);
	}

	public bool update_playing_station(Station station)
	{
		return _headerbar.update_playing_station(station);
	}

	public Gee.List<string> get_hearted_titles()
	{
		return _headerbar.get_hearted_titles();
	}

	public Gee.List<string> get_hearted_history_lines_without_hearts()
	{
		return _headerbar.get_hearted_history_lines_without_hearts();
	}


} // Tuner.HeaderBox
