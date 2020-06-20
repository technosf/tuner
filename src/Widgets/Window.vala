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

using Gee;

public class Tuner.Window : Gtk.ApplicationWindow {
    public GLib.Settings settings;
    public Gtk.Stack stack { get; set; }

    private PlayerController _player;
    private DirectoryController _directory;
    private HeaderBar headerbar;
    private Granite.Widgets.SourceList source_list;
    
    public const string ACTION_PREFIX = "win.";
    public const string ACTION_PAUSE = "action_pause";
    public const string ACTION_QUIT = "action_quit";

    private const ActionEntry[] ACTION_ENTRIES = {
        { ACTION_PAUSE, handle_stop_playback },
        { ACTION_QUIT, action_quit }
    };

    public Window (Application app, PlayerController player) {
        Object (application: app);

        application.set_accels_for_action (ACTION_PREFIX + ACTION_PAUSE, {"<Control>5"});
        application.set_accels_for_action (ACTION_PREFIX + ACTION_QUIT, {"<Control>q", "<Control>w"});

        _player = player;
        _player.state_changed.connect (handle_player_state_changed);
        _player.station_changed.connect (headerbar.update_from_station);
    }

    static construct {
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("com/github/louis77/tuner/Application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider,                 Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    construct {
        add_action_entries (ACTION_ENTRIES, this);

        window_position = Gtk.WindowPosition.CENTER;
        set_default_size (1040, 640);
        settings = Application.instance.settings;
        move (settings.get_int ("pos-x"), settings.get_int ("pos-y"));

        set_geometry_hints (null, Gdk.Geometry() {min_height = 440, min_width = 1040}, Gdk.WindowHints.MIN_SIZE);
        resize (settings.get_int ("window-width"), settings.get_int ("window-height"));

        delete_event.connect (e => {
            return before_destroy ();
        });

        var stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.CROSSFADE;

        headerbar = new HeaderBar (this);
        headerbar.stop_clicked.connect ( () => {
            handle_stop_playback ();
        });


        set_titlebar (headerbar);

        _directory = new DirectoryController (new RadioBrowser.Client ());

        var primary_box = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);


        var selections_category = new Granite.Widgets.SourceList.ExpandableItem ("Selections");
        selections_category.collapsible = false;
        selections_category.expanded = true;

        var searched_category = new Granite.Widgets.SourceList.ExpandableItem ("Search");
        searched_category.collapsible = false;
        searched_category.expanded = true;

        var genres_category = new Granite.Widgets.SourceList.ExpandableItem ("Genres");
        genres_category.collapsible = true;
        genres_category.expanded = true;
        
        source_list = new Granite.Widgets.SourceList ();


        var c1 = create_content_box ("discover", "Discover", "face-smile",
                            "Discover Stations", "media-playlist-shuffle-symbolic",
                            "Discover more stations",
                            stack, selections_category, source_list);
        var s1 = _directory.load_random_stations(10);
        c1.realize.connect (() => {
            c1.stations = s1.next ();
        });
        c1.action_activated.connect (() => {
            c1.stations = s1.next ();
        });

        var c2 = create_content_box ("trending", "Trending", "playlist-queue",
                            "Trending in the last 24 hours", null, null,
                            stack, selections_category, source_list);
        var s2 = _directory.load_trending_stations(40);
        c2.realize.connect (() => {
            c2.stations = s2.next ();
        });
        
        var c3 = create_content_box ("popular", "Popular", "playlist-similar",
                            "Most-listened over 24 hours", null, null,
                            stack, selections_category, source_list);
        var s3 = _directory.load_popular_stations(40);
        c3.realize.connect (() => {
            c3.stations = s3.next ();
        });

        var c4 = create_content_box ("starred", "Starred by You", "starred",
                            "Starred by You", null, null,
                            stack, selections_category, source_list, true);
        
        c4.realize.connect (() => {
            var s4 = _directory.load_favourite_stations(1000);
            c4.stations = s4.next ();
        });

        var c5 = create_content_box ("searched", "Search Result", "folder-saved-search",
                            "Search", null, null,
                            stack, searched_category, source_list, true);
        var s5 = _directory.load_search_stations("", 100);


        foreach (var genre in Model.genres ()) {
            var cb = create_content_box (genre.name, genre.name, "playlist", 
                genre.name, null, null, stack, genres_category, source_list);
            var ds = _directory.load_by_tags (genre.tags);
            cb.realize.connect (() => {
                cb.stations = ds.next ();
            });
        }

        headerbar.star_clicked.connect ( (starred) => {
            _directory.star_station (_player.station, starred);
            c4.clear_content ();
            var s = _directory.load_favourite_stations(1000);
            c4.stations = s.next ();
        });

        source_list.root.add (selections_category);
        source_list.root.add (searched_category);
        source_list.root.add (genres_category);

        source_list.set_size_request (180, -1);
        source_list.selected = source_list.get_first_child (selections_category);
        source_list.item_selected.connect  ((item) => {
            var selected_item = item.get_data<string> ("stack_child");
            debug (@"selected $selected_item");
            stack.visible_child_name = selected_item;
        });

        headerbar.searched_for.connect ( (text) => {
            if (text.length > 0) {
                c5.clear_content ();
                s5 = _directory.load_search_stations (text, 100); 
                c5.stations = s5.next ();
            }
        });

        headerbar.search_focused.connect (() => {
            stack.visible_child_name = "searched";
        });

        stack.visible_child_name = "discover";
        primary_box.pack1 (source_list, true, false);
        primary_box.pack2 (stack, true, false);
        add (primary_box);
        show_all ();
    }

    private ContentBox create_content_box (
             string name,
             string list_title,
             string list_icon_name,
             string full_title,
             string? action_icon_name,
             string? action_tooltip_text,
             Gtk.Stack stack,
             Granite.Widgets.SourceList.ExpandableItem category_item,
             Granite.Widgets.SourceList source_list,
             bool enable_count = false) {
        var item = new Granite.Widgets.SourceList.Item (list_title);
        item.icon = new ThemedIcon (list_icon_name);
        item.set_data<string> ("stack_child", name);
        category_item.add (item);
        var c = new ContentBox (
            null,
            full_title,
            action_icon_name,
            action_tooltip_text
        );
        c.selection_changed.connect (handle_station_click);
        c.map.connect (() => {
            source_list.selected = item;
        });
        if (enable_count) {
            c.station_count_changed.connect ((count) => {
                var badge = @"$count";
                if (count == 100) {
                    badge = "99+";
                }
                item.badge = badge;
            });
        }
        stack.add_named (c, name);

        return c;
    }

    private void action_quit () {
        close ();
    }

    public void handle_station_click(Tuner.Model.StationModel station) {
        info (@"handle station click for $(station.title)");
        _directory.count_station_click (station);
        _player.station = station;
    }

    public void handle_stop_playback() {
        info ("Stop Playback requested");
        _player.play_pause ();
    }

    public void handle_player_state_changed (Gst.PlayerState state) {
        switch (state) {
            case Gst.PlayerState.BUFFERING:
                debug ("player state changed to Buffering");
                Gdk.threads_add_idle (() => {
                    headerbar.subtitle = "Buffering";
                    headerbar.set_playstate (headerbar.PAUSE_ACTIVE);
                    return false;
                });
                break;;
            case Gst.PlayerState.PAUSED:
                debug ("player state changed to Paused");
                Gdk.threads_add_idle (() => {
                    headerbar.subtitle = "Paused";
                    if (_player.can_play()) {
                        headerbar.set_playstate (headerbar.PLAY_ACTIVE);
                    } else {
                        headerbar.set_playstate (headerbar.PLAY_INACTIVE);
                    }
                    return false;
                });
                break;;
            case Gst.PlayerState.PLAYING:
                debug ("player state changed to Playing");
                Gdk.threads_add_idle (() => {
                    headerbar.subtitle = _("Playing");
                    headerbar.set_playstate (headerbar.PAUSE_ACTIVE);
                    return false;
                });
                break;;
            case Gst.PlayerState.STOPPED:
                debug ("player state changed to Stopped");
                Gdk.threads_add_idle (() => {
                    headerbar.subtitle = _("Stopped");
                    if (_player.can_play()) {
                        headerbar.set_playstate (headerbar.PLAY_ACTIVE);
                    } else {
                        headerbar.set_playstate (headerbar.PLAY_INACTIVE);
                    }
                    return false;
                });
                break;
        }

        return;
    }

    public bool before_destroy () {
        int width, height, x, y;

        get_size (out width, out height);
        get_position (out x, out y);

        settings.set_int ("pos-x", x);
        settings.set_int ("pos-y", y);
        settings.set_int ("window-height", height);
        settings.set_int ("window-width", width);

        return false;
    }

}
