/**
 * SPDX-FileCopyrightText: Copyright © 2020-2024 Louis Brauer <louis@brauer.family>
 * SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file PlayerInfo.vala
 *
 * @brief PlayerInfo widget
 *
 */


using Gtk;
using Tuner.Controllers;
using Tuner.Models;

/** 
 * PlayerInfo widget for displaying station and track information.
 */
public class Tuner.Widgets.Base.PlayerInfo : Revealer
{
    private const string DEFAULT_ICON_NAME = "tuner:internet-radio-symbolic";
    private const uint REVEAL_DELAY = 400u;
    private const uint STATION_CHANGE_SETTLE_DELAY_MS = 1200u;
    private const string STREAM_METADATA = _("Stream Metadata");

    public Label station_label { get; private set; }
    public CyclingRevealLabel title_label { get; private set; }
    //public StationContextMenu menu { get; private set; }

    public Image favicon_image = new Image.from_icon_name(DEFAULT_ICON_NAME, IconSize.DIALOG);

    public string metadata {
        get { return _metadata; }
        internal set { _metadata = value; }
    }

    private string _metadata;
    private Station _station;
    private uint grid_min_width = 0;

    internal signal void info_changed_completed_sig();

    /**
     * Creates a new PlayerInfo widget.
     *
     * @param window Parent window
     * @param player Player controller
     */
    public PlayerInfo(Window window, PlayerController player)
    {
        Object();

        transition_duration = REVEAL_DELAY;
        transition_type     = RevealerTransitionType.CROSSFADE;

        station_label = new Label("Tuner");
        station_label.get_style_context().add_class("station-label");
        station_label.ellipsize = Pango.EllipsizeMode.MIDDLE;

        title_label = new CyclingRevealLabel(window, 100);
        title_label.get_style_context().add_class("track-info");
        title_label.halign = Align.CENTER;
        title_label.valign = Align.CENTER;
        title_label.show_metadata = window.settings.stream_info;
        title_label.metadata_fast_cycle = window.settings.stream_info_fast;

        var station_grid = new Grid();
        station_grid.column_spacing = 10;
        station_grid.set_halign(Align.FILL);
        station_grid.set_valign(Align.CENTER);

        station_grid.attach(favicon_image, 0, 0, 1, 2);
        station_grid.attach(station_label, 1, 0, 1, 1);
        station_grid.attach(title_label, 1, 1, 1, 1);

        station_grid.size_allocate.connect((allocate) =>
        {
            if (grid_min_width == 0)
                grid_min_width = allocate.width;
        });

        add(station_grid);
        reveal_child = false;

        metadata = STREAM_METADATA;

        /*
		    Hook up title to metadata as tooltip
		 */
		tooltip_text = STREAM_METADATA;
		query_tooltip.connect((x, y, keyboard_tooltip, tooltip) =>
		{
			if (_station == null)
				return false;
			tooltip.set_text(@"$(_station.popularity())\n\n$(metadata)");
			return true;
		});

        //player.metadata_changed_sig.connect(handle_metadata_changed);
    }

    /**
     * Handles display transition when station changes.
     */
    internal async void change_station(Station station)
    {
        reveal_child = false;

        Idle.add(() =>
        {
            Timeout.add(5 * REVEAL_DELAY / 3, () =>
            {
                favicon_image.clear();
                title_label.clear();
                station_label.label = "";
                _metadata = STREAM_METADATA;
                return Source.REMOVE;
            });

            Timeout.add(STATION_CHANGE_SETTLE_DELAY_MS, () =>
            {
                station.update_favicon_image.begin(
                    favicon_image,
                    true,
                    DEFAULT_ICON_NAME,
                    () =>
                    {
                        _station = station;
                        station_label.label = station.name;

                        reveal_child = true;
                        title_label.cycle();

                        info_changed_completed_sig();
                    }
                );

                return Source.REMOVE;
            });

            return Source.REMOVE;
        }, Priority.HIGH_IDLE);
    }

    /**
     * Handles metadata updates from the player.
     */
    public void handle_metadata_changed(Station station, Metadata metadata)
    {
        if (_metadata == metadata.pretty_print)
            return;

        _metadata = metadata.pretty_print;

        if (_metadata == "")
        {
            _metadata = STREAM_METADATA;
            return;
        }

        title_label.add_sublabel(1, metadata.genre, metadata.homepage);
        title_label.add_sublabel(2, metadata.audio_info);
        title_label.add_sublabel(3, metadata.org_loc);

        if (!title_label.set_text(metadata.title))
        {
            Timeout.add_seconds(3, () =>
            {
                title_label.set_text(metadata.title);
                return Source.REMOVE;
            });
        }
    }

}