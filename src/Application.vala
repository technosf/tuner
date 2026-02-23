/**
 * SPDX-FileCopyrightText: Copyright © 2020-2024 Louis Brauer <louis@brauer.family>
 * SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file Application.vala
 *
 * @brief Main application class and namespace assets for the Tuner radio application
 */

 using GLib;

/**
 * @namespace Tuner
 * @brief Main namespace for the Tuner application
 */
namespace Tuner {


    /*
        Namespace Assets and Methods
    */
    private static Application _instance;

    private static string[] APP_ARGV; 

    //  /**
    //  * @brief Available themes
    //  *
    //  */
    //  public enum THEME
    //  {
    //      SYSTEM,
    //      LIGHT,
    //      DARK;

    //      public unowned string get_name ()
    //      {
    //          switch (this) {
    //              case SYSTEM:
    //                  return "system";

    //              case LIGHT:
    //                  return "light";

    //              case DARK:
    //                  return "dark";

    //              default:
    //                  assert_not_reached();
    //          }
    //      }
    //  } // THEME


    //  /**
    //  * @brief Applys the given theme to the app
    //  *
    //  * @return The Application instance
    //  */
    //  public static void apply_theme(THEME requested_theme)
    //  {
    //      apply_theme_name( requested_theme.get_name() );
    //  }


    //  public static void apply_theme_name(string requested_theme)
    //  {
    //      if ( requested_theme == THEME.LIGHT.get_name() )
    //      {
    //          debug(@"Applying theme: light");           
    //          Gtk.Settings.get_default().set_property("gtk-theme-name", "Adwaita");
    //          return;
    //      }

    //      if ( requested_theme == THEME.DARK.get_name() )
    //      {
    //          debug(@"Applying theme: dark");            
    //          Gtk.Settings.get_default().set_property("gtk-theme-name", "Adwaita-dark");
    //          return;
    //      }

    //      if ( requested_theme == THEME.SYSTEM.get_name() )
    //      {
    //          debug(@"System theme X: $(Application.SYSTEM_THEME())");       
    //          Gtk.Settings.get_default().set_property("gtk-theme-name", Application.SYSTEM_THEME());
    //          return;
    //      }
    //      assert_not_reached();
    //  } // apply_theme

    //  // Fade duration used for window and image transitions (milliseconds)
    //  public const uint WINDOW_FADE_MS = 400;


    /**
    * @brief Getter for the singleton instance
    *
    * @return The Application instance
    */
    public static Application app() {
            return _instance;
    } // app


    //  /**
    //  * @brief Send the calling method for a nap
    //  *
    //  * @param interval the time to nap
    //  * @param priority priority of chacking nap is over
    //  */
    //  public static async void nap (uint interval) {
    //      Timeout.add (interval, () => {
    //          nap.callback ();
    //          return Source.REMOVE;
    //      }, Priority.LOW);
    //      yield;
    //  } // nap


    //  /**
    //  * @brief Asynchronously transitions the image with a fade effect.
    //  * 
    //  * @param {Gtk.Image} image - The image to transition.
    //  * @param {uint} duration_ms - Duration of the fade effect in milliseconds.
    //  * @param {Closure} callback - Optional callback function to execute after fading.
    //  */
    //  public static async void fade(Gtk.Image image, uint duration_ms, bool fading_in) 
    //  {
    //      double step = 0.05; // Adjust opacity in 5% increments
    //      uint interval = (uint) (duration_ms / (1.0 / step)); // Interval based on duration

    //      while ( ( !fading_in && image.opacity != 0 ) || (fading_in && image.opacity != 1) ) 
    //      {      
    //          double op = image.opacity + (fading_in ? step : -step); 
    //          image.opacity = op.clamp(0, 1); 
    //          yield nap (interval);
    //      }
    //  } // fade

    //  /**
    //   * Fade the entire toplevel window by adjusting its `opacity` property.
    //   */
    //  public static async void fade_window(Gtk.Window window, uint duration_ms, bool fading_in)
    //  {
    //      double step = 0.05;
    //      uint interval = (uint) (duration_ms / (1.0 / step));

    //      while (( !fading_in && window.opacity != 0 ) || (fading_in && window.opacity != 1))
    //      {
    //          double op = window.opacity + (fading_in ? step : -step);
    //          window.opacity = op.clamp(0, 1);
    //          yield nap(interval);
    //      }
    //  }


    //  public static unowned string safestrip( string? text )
    //  {
    //      if ( text == null ) return "";
    //      if ( text.length == 0 ) return "";
    //      return text._strip();
    //  } // safestrip

    //-------------------------------------

    /*
    
        Application

    */

    /**
    * @class Application
    * @brief Main application class implementing core functionality
    * @ingroup Tuner
    * 
    * The Application class serves as the primary entry point and controller for the Tuner
    * application. It manages:
    * - Window creation and presentation
    * - Settings management
    * - Player control
    * - Directory structure
    * - DBus initialization
    * 
    * @note This class follows the singleton pattern, accessible via Application.instance
    */
    public class Application : Gtk.Application 
    {

        /** @brief Signal emitted when the shuffle mode changes   */
        public signal void shuffle_mode_sig(bool shuffle);

        private static Gtk.Settings GTK_SETTINGS;
        private static string GTK_SYSTEM_THEME = "unset";
        private static string ENV_LANG = "LANGUAGE";

        /** @brief Application version */
        public const string APP_VERSION = VERSION;
        
        /** @brief Application ID */
        public const string APP_ID = "com.github.louis77.tuner";
        
        /** @brief Unicode character for starred items ★ */
        public const string STAR_CHAR = "\u2605 ";

        /** @brief Unicode character for unstarred items ☆ */ 
        public const string UNSTAR_CHAR = "\u2606 ";

        /** @brief Unicode character for out-of-date items ⚠ */ 
        public const string EXCLAIM_CHAR = "\u26A0 ";
    
        /** @brief File name for starred station sore */
        public const string STARRED = "starred.json";

        public static Gee.Collection<string> LANGUAGES = new Gee.TreeSet<string>();

        /** @brief Connectivity monitoring*/
        private static NetworkMonitor NETMON = NetworkMonitor.get_default ();

        private static Gtk.CssProvider CSSPROVIDER = new Gtk.CssProvider();

        public static string SYSTEM_THEME() { return GTK_SYSTEM_THEME; }

        static construct 
        {
            // Interntionalization
            Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
            Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
            Intl.textdomain (GETTEXT_PACKAGE);
            LANGUAGES.add("en");    // App core language - no .po created for it, but should always be available as fallback
            try {
                // Add translations
                var dir = File.new_for_path(LOCALEDIR);
                var enumerator = dir.enumerate_children("standard::*", FileQueryInfoFlags.NONE);
                FileInfo info;
                while ((info = enumerator.next_file()) != null) 
                {
                    if (info.get_file_type() == FileType.DIRECTORY && info.get_name() != "C") 
                    {
                        var lang_dir = dir.get_child(info.get_name());
                        var mo_file = lang_dir.get_child("LC_MESSAGES").get_child(GETTEXT_PACKAGE + ".mo");
                        if (mo_file.query_exists()) LANGUAGES.add(info.get_name());
                    }
                } //  while
            } catch (Error e) {
                warning(@"Error reading locale path: $(e.message)");
            }            
        }

        // -------------------------------------

        public string language { 
            get { return GLib.Environment.get_variable(ENV_LANG); }
            set { 
                if ( GLib.Environment.get_variable(ENV_LANG) == value 
                || ( value != "" && !LANGUAGES.contains(value )) ) return;

                if ( settings.language != value ) 
                {
                    settings.language = value;

                    // Defer save and restart to give the WM/compositor a short
                    // moment to finalize the resize/move. We still flush
                    // pending GTK events right before saving inside the
                    // timeout callback.
                    Idle.add(() => {
                        // Start a fade-out using the shared fade constant and
                        // hide the window after the fade so opacity doesn't revert.
                        uint fade_ms = WINDOW_FADE_MS;
                        fade_window.begin(app().window, fade_ms, false, () => { });

                        GLib.Timeout.add((uint) (fade_ms + 80), () => {
                            while (Gtk.events_pending()) Gtk.main_iteration();
                            settings.save();
                            app().window.hide();
                            // Stop GTK main loop cleanly
                            spawn_restart();
                            quit();
                            return false; // one-shot
                        });
                        return Source.REMOVE;
                    });
                }

                GLib.Environment.set_variable(ENV_LANG, value, true);
            }
        }

        public string theme_name { 
            get { return settings.theme_mode; }
            set { 
                if ( settings.theme_mode == value ) return;
                settings.theme_mode = value;
                apply_theme_name(value);
            }
        }

        /** @brief Application settings */
        public Settings settings { get; construct; }  
        
        /** @brief Player controller */
        public PlayerController player { get; construct; }  

        /** @brief Player controller */
        public DirectoryController directory { get; construct; }

        /** @brief Player controller */
        public StarStore stars { get; construct; }
        
        /** @brief API DataProvider */
        public DataProvider.API provider { get; construct; }
        
        /** @brief Cache directory path */
        public string? cache_dir { get; construct; }
        
        /** @brief Data directory path */
        public string? data_dir { get; construct; }

        /** @brief provide a Cancellable for online processes */
        public Cancellable offline_cancel { get; construct; }

        /** @brief Are we online */
        public bool is_offline { get; private set; default = true;}   
        private bool _is_online = false;
        public bool is_online { 
            get { return _is_online; } 
            private set {   
                if ( value == _is_online ) return;     
                if ( value ) 
                { 
                    _offline_cancel.reset (); 
                }
                else 
                { 
                    _offline_cancel.cancel (); 
                }
                _is_online = value;
                is_offline = !value;
            }
        }   

        /** @brief Run the application with the given command line arguments */
        public new int run ( string[]? argv = null)
        {
            APP_ARGV = argv;     // Keep a copy of the args for rerunning the app from the RestartManager
            return base.run (argv); 
        }

        /** @brief Main application window */
        public Window window { get; private set; }


        /** @brief Action entries for the application */
        private const ActionEntry[] ACTION_ENTRIES = {
            { "resume-window", on_resume_window }
        };

        private uint _monitor_changed_id = 0;
        private bool _has_started = false;


        /**
        * @brief Constructor for the Application
        */
        private Application () {
            Object (
                application_id: APP_ID,
                flags: ApplicationFlags.FLAGS_NONE
            );
        }


        /**
        * @brief Construct block for initializing the application
        */
        construct 
        {           
            // Create required directories and files

            cache_dir = stat_dir(Environment.get_user_cache_dir ());
            data_dir = stat_dir(Environment.get_user_data_dir ());


            /* 
                Starred file and migration of favorites
            */
            var _favorites_file =  File.new_build_filename (data_dir, "favorites.json"); // v1 file
            var _starred_file =  File.new_build_filename (data_dir, Application.STARRED);   // v2 file

            /* Migration not possible with renamed app */
            try {
                _favorites_file.open_readwrite().close ();   // Try to open, if succeeds it exists, if not err - no migration
                _starred_file.create(NONE); // Try to create, if fails starred already exists, if not ok to migrate
                _favorites_file.copy (_starred_file, FileCopyFlags.NONE);  // Copy
                warning(@"Migrated v1 Favorites to v2 Starred");
            }     
            catch (Error e) {
                // Peconditions not met
            }

            /* 
                Create the cancellable.
                Wrap network monitoring into a bool property 
            */
            offline_cancel = new Cancellable();
            is_online = NETMON.get_network_available ();   
            NETMON.network_changed.connect((monitor) => {      
                check_online_status();
            });        


            /* 
                Init Tuner assets 
            */
            settings = new Settings ();
            provider = new DataProvider.RadioBrowser(null);
            player = new PlayerController ();
            stars = new StarStore(_starred_file);
            directory = new DirectoryController(provider, stars);

            add_action_entries(ACTION_ENTRIES, this);

            /*
                Hook up voting and counting
            */
            player.state_changed_sig.connect ((station, state) => 
            // Do a provider click when starting to play a sation
            {
                if ( !settings.do_not_vote  && state == PlayerController.Is.PLAYING )
                {
                    provider.click(station.stationuuid);                
                    station.clickcount++;
                    station.clicktrend++;
                }
            });

            player.tape_counter_sig.connect((station) =>
            // Every ten minutes of continuous playing tape counter sigs are emitted
            // Vote and click the station each time as appropriate
            {     
                if ( settings.do_not_vote ) return;
                if ( station.starred ) 
                { 
                    provider.vote(station.stationuuid); 
                    station.votes++;
                }
                provider.click(station.stationuuid);
                station.clickcount++;
                station.clicktrend++;
            });

            // Add application actions
            add_action_entries(ACTION_ENTRIES, this);

            // Add set-theme-name action
            var set_theme_action = new SimpleAction("set-theme-name", VariantType.STRING);
            set_theme_action.activate.connect((parameter) => {
                if (parameter != null) {
                    theme_name = parameter.get_string();
                }
            });
            add_action(set_theme_action);

            // Add set-language action
            var set_language_action = new SimpleAction("set-language", VariantType.STRING);
            set_language_action.activate.connect((parameter) => {
                if (parameter != null) {
                    language = parameter.get_string();
                }
            });
            add_action(set_language_action);

        } // construct


        /**
        * @brief Getter for the singleton instance
        *
        * @return The Application instance
        */
        public static Application instance 
        {
            get {
                    if (Tuner._instance == null) {  
                    Tuner._instance = new Application ();  
                }
                return Tuner._instance;
            }
        } // instance


        /**
        * @brief Activates the application
        *
        * This method is called when the application is activated. It creates
        * or presents the main window and initializes the DBus connection.
        */
        protected override void activate() 
        {
            if (window == null) { 
                DBus.initialize (); 

                GTK_SETTINGS = Gtk.Settings.get_default();
                GTK_SYSTEM_THEME = GTK_SETTINGS.gtk_theme_name;
                CSSPROVIDER.load_from_resource ("/com/github/louis77/tuner/css/Tuner-system.css");
                Gtk.StyleContext.add_provider_for_screen(
                    Gdk.Screen.get_default(),
                    CSSPROVIDER,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                );

                apply_theme_name( settings.theme_mode);    
                language = settings.language;  
                     
                window = new Window (this, player, settings, directory); 
                //app().window.resize(1000, 625);    // Screenshot sizing - round corners 80, ds op 1

                add_window (window);
            } else {
                window.present ();
            }
        } // activate
        
        
        /**
        * @brief Resumes the window
        *
        * This method is called to bring the main window to the foreground.
        */
        private void on_resume_window() {
            window.present();
        }


        /**
        * @brief Create directory structure quietly
        *
        */
        private string? stat_dir (string dir)
        {
            var _dir = File.new_build_filename (dir, application_id);
            try {
                _dir.make_directory_with_parents ();
            } catch (IOError.EXISTS e) {
            } catch (Error e) {
                warning(@"Stat Directory failed $(e.message)");
                return null;
            }
            return _dir.get_path ();

        } // stat_dir


        /**
        * @brief Set the network availability
        *
        * If going offline, set immediately.
        * Going online - wait a second to allow network to stabilize
        * This method removes any existing timeout and sets a new one 
        * reduces network state bouncyness
        */
        private void check_online_status()
        {
            if(_monitor_changed_id > 0) 
            {
                Source.remove(_monitor_changed_id);
                _monitor_changed_id = 0;
            }

            /*
                If change to online from offline state
                wait 1 seconds before setting to online status
                to whatever the state is at that time
            */
            if ( is_offline && NETMON.get_network_available ()  )
            {
                _monitor_changed_id = Timeout.add_seconds( (uint)_has_started+1, () => 
                {           
                    _monitor_changed_id = 0; // Reset timeout ID after scheduling  
                    is_online = NETMON.get_network_available ();
                    _has_started = true;
                    return Source.REMOVE;
                });

                return;
            }
            // network is unavailable 
            is_online = false;
        } // check_online_status


        /** @brief Spawns a new instance of the application */
        private void spawn_restart() 
        {
            try {
                Pid pid;

                string[] argv = build_restart_argv();

                Process.spawn_async(
                    null,
                    argv,
                    null, // inherit environment (LANGUAGE already set)
                    SpawnFlags.SEARCH_PATH,
                    null,
                    out pid
                );

            } catch (SpawnError e) {
                warning(@"Restart failed: $(e.message)");
            }
        } // spawn_restart


        /** @brief Build the correct argv for restarting the application, handling Flatpak and Meson cases */   
        private string[] build_restart_argv() 
        {
            string exe = Environment.get_prgname();

            // Prefer stored argv (Meson, Flatpak, debugging correctness)
            if (APP_ARGV != null && APP_ARGV.length > 0)
                exe = APP_ARGV[0];

            // Flatpak requires host spawn
            if (FileUtils.test("/run/.flatpak-info", FileTest.EXISTS) ) 
            // Is a flatpak
            {
                return { "flatpak-spawn", "--host", exe };
            }

            return { exe };
        }

    } // Application
} // namespace Tuner