/*
* Copyright (c) 2020 Louis Brauer (https://github.com/louis77)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Louis Brauer <louis@brauer.family>
*/

public class Tuner.HeaderBar : Gtk.HeaderBar {

    public enum PlayState {
        PAUSE_ACTIVE,
        PAUSE_INACTIVE,
        PLAY_ACTIVE,
        PLAY_INACTIVE
    }

    public Tuner.Window main_window { get; construct; }
    public Gtk.Button play_button { get; set; }

    private Gtk.Button star_button;
    private bool _starred = false;
    private Model.StationModel _station;
    private Gtk.Label _title_label;
    private Gtk.Label _subtitle_label;
    private Gtk.Image _favicon_image;

    public signal void stop_clicked ();
    public signal void star_clicked (bool starred);
    public signal void searched_for (string text);
    public signal void search_focused ();

    public HeaderBar (Tuner.Window window) {
        Object (
            main_window: window
        );
    }

    construct {
        show_close_button = true;

        var station_info = new Gtk.Grid ();
        station_info.column_spacing = 10;

        _title_label = new Gtk.Label ("Choose a station");
        _title_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
        _subtitle_label = new Gtk.Label ("Paused");
        _favicon_image = new Gtk.Image.from_icon_name ("multimedia-player", Gtk.IconSize.DIALOG);

        station_info.attach (_favicon_image, 0, 0, 1, 2);
        station_info.attach (_title_label, 1, 0, 1, 1);
        station_info.attach (_subtitle_label, 1, 1, 1, 1);

        custom_title = station_info;
        play_button = new Gtk.Button ();
        play_button.valign = Gtk.Align.CENTER;
        play_button.clicked.connect (() => { stop_clicked (); });
        set_playstate (PlayState.PAUSE_INACTIVE);
        pack_start (play_button);

        var searchentry = new Gtk.SearchEntry ();
        searchentry.valign = Gtk.Align.CENTER;
        searchentry.placeholder_text = "Station name";
        searchentry.search_changed.connect (() => {
            searched_for (searchentry.text);
        });
        searchentry.focus_in_event.connect ((e) => {
            search_focused ();
        });
        pack_end (searchentry);

        star_button = new Gtk.Button.from_icon_name (
            "non-starred",
            Gtk.IconSize.LARGE_TOOLBAR
        );
        star_button.valign = Gtk.Align.CENTER;
        star_button.sensitive = true;
        star_button.tooltip_text = "Star this station";
        star_button.clicked.connect (() => {
            starred = !starred;
            star_clicked (starred);
        });

        pack_start (star_button);

    }

    public new string title {
        get {
            return _title_label.label;
        }
        set {
            _title_label.label = value;
        }
    }

    public new string subtitle {
        get {
            return _subtitle_label.label;
        }
        set {
            _subtitle_label.label = value;
        }
    }

    public Gtk.Image favicon {
        get {
            return _favicon_image;
        }
        set {
            _favicon_image = value;
        }
    }


    public void update_from_station (Model.StationModel station) {
        _station = station;
        var short_title = station.title;
        if (short_title.length > 50) {
            short_title = short_title[0:30] + "...";
        }
        title = short_title;
        subtitle = "Connecting";
        load_favicon (station.favicon_url);
        starred = station.starred;
    }

    private bool starred {
        get {
            return _starred;
        }

        set {
            _starred = value;
            if (!_starred) {
                star_button.image = new Gtk.Image.from_icon_name ("non-starred",    Gtk.IconSize.LARGE_TOOLBAR);
            } else {
                star_button.image = new Gtk.Image.from_icon_name ("starred",    Gtk.IconSize.LARGE_TOOLBAR);
            }
        }
    }

    private void load_favicon (string url) {
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", url);

        session.queue_message (message, (sess, mess) => {
            if (mess.status_code != 200) {
                warning (@"Unexpected status code: $(mess.status_code), will not render $(url)");
                favicon.clear ();
                return;
            }

            var data_stream = new MemoryInputStream.from_data (mess.response_body.data);
            Gdk.Pixbuf pxbuf;

            try {
                pxbuf = new Gdk.Pixbuf.from_stream_at_scale (data_stream, 48, 48, true, null);
            } catch (Error e) {
                warning ("Couldn't render favicon: %s (%s)",
                    url ?? "unknown url",
                    e.message);
                favicon.clear ();
                return;
            }

            favicon.set_from_pixbuf (pxbuf);
        });
    }

    public void set_playstate (PlayState state) {
        switch (state) {
            case PlayState.PLAY_ACTIVE:
                play_button.image = new Gtk.Image.from_icon_name (
                    "media-playback-start-symbolic",
                    Gtk.IconSize.LARGE_TOOLBAR
                );
                play_button.sensitive = true;
                break;
            case PlayState.PLAY_INACTIVE:
                play_button.image = new Gtk.Image.from_icon_name (
                    "media-playback-start-symbolic",
                    Gtk.IconSize.LARGE_TOOLBAR
                );
                play_button.sensitive = false;
                break;
            case PlayState.PAUSE_ACTIVE:
                play_button.image = new Gtk.Image.from_icon_name (
                    "media-playback-pause-symbolic",
                    Gtk.IconSize.LARGE_TOOLBAR
                );
                play_button.sensitive = true;
                break;
            case PlayState.PAUSE_INACTIVE:
                play_button.image = new Gtk.Image.from_icon_name (
                    "media-playback-pause-symbolic",
                    Gtk.IconSize.LARGE_TOOLBAR
                );
                play_button.sensitive = false;
                break;
        }
    }

}
