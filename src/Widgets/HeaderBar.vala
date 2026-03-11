/**
 * SPDX-FileCopyrightText: Copyright © 2020-2024 Louis Brauer <louis@brauer.family>
 * SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file HeaderBar.vala
 *
 * @brief HeaderBar classes
 *
 */

using Gtk;
using Tuner.Controllers;
using Tuner.Models;
using Tuner.Services;

/*
 * @class Tuner.HeaderBar
 *
 * @brief Custom header bar that centrally displays station info and
 * packs app controls either side.
 *
 * This class extends HeaderBar to create a specialized header bar
 * with play/pause controls, volume control, station information display,
 * search functionality, and preferences menu.
 *
 * @extends HeaderBar
 */
public class Tuner.Widgets.HeaderBar : Gtk.HeaderBar
{

    /* Constants    */

    // Default icon name for stations without a custom favicon
    private const string DEFAULT_ICON_NAME = "tuner:internet-radio-symbolic";

	// Reveal animation delay in milliseconds
	private const uint REVEAL_DELAY = 400u;
	public const uint STATION_CHANGE_SETTLE_DELAY_MS = 1200u;
	public const uint SHUFFLE_ERROR_RETRY_DELAY_MS = 1500u;

	private static Image STAR   = new Image.from_icon_name ("starred", IconSize.LARGE_TOOLBAR);
	private static Image UNSTAR = new Image.from_icon_name ("non-starred", IconSize.LARGE_TOOLBAR);


    /* Public */


    // Public properties

    // Signals
    public signal void searching_for_sig (string text);
    public signal void search_has_focus_sig ();


    /*
        Private 
    */

	protected static Image FAVICON_IMAGE = new Image.from_icon_name (DEFAULT_ICON_NAME, IconSize.DIALOG);


	/*
		main display assets
	*/
	private Base.TunerStatus _tuner_status;
	private Button _star_button = new Button.from_icon_name (
		"non-starred",
		IconSize.LARGE_TOOLBAR
		);
	private PlayButton _play_button  = new PlayButton ();
	private MenuButton _prefs_button = new MenuButton ();
	private SearchEntry _search_entry = new SearchEntry ();
	private ListButton _list_button  = new ListButton.from_icon_name ("mark-location-symbolic", IconSize.LARGE_TOOLBAR);

	/*
		secondary display assets
	*/

    // data and state variables

	private Station _station;
	private Mutex _station_update_lock = Mutex();       // Lock out concurrent updates
	private bool _station_locked       = false;
	private ulong _station_handler_id  = 0;
	private Application _app;
	private PlayerController _player;
	private DataProvider.API _provider;

    private VolumeButton _volume_button = new VolumeButton();
    
	private Base.PlayerInfo _player_info;

	/** @property {bool} starred - Station starred. */
	private bool _starred = false;
	private bool starred {
		get { return _starred; }
		set {
			_starred = value;
			if (!_starred)
			{
				_star_button.image = UNSTAR;
			}
			else
			{
				_star_button.image = STAR;
			}
		}
	} // starred


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
    public HeaderBar(Application app, Window window, PlayerController player, DataProvider.API provider)
    {
        Object();
		_app = app;
		_player = player;
		_provider = provider;

		get_style_context ().add_class ("header-bar");

        /*
            LHS Controls
        */        

        // Tuner Status icon
		_tuner_status =new Base.TunerStatus(app, window, provider);

		
		// Volume
		_volume_button.set_valign(Align.CENTER);
		_volume_button.value_changed.connect ((value) => {
			_player.volume = value;
		});
		_player.volume_changed_sig.connect((value) => {
			_volume_button.value =  value;
		});


		// Star button
		_star_button.valign       = Align.CENTER;
		_star_button.sensitive    = true;
		_star_button.tooltip_text = _("Star this station");
		_star_button.clicked.connect (() => 
		{
			if (_station == null)
				return;			
			starred = _station.toggle_starred();
		});


		//
		// Create and configure play button
		//
		_play_button.valign      = Align.CENTER;
		_play_button.action_name = Window.ACTION_PREFIX + Window.ACTION_PAUSE; // Toggles player state

       
        /*
            RHS Controls
        */     

		// Search entry
			_search_entry.placeholder_text = _("Station Search");
			_search_entry.set_margin_start(5);   // 5 pixels padding on the left
			_search_entry.valign           = Align.CENTER;

			_search_entry.changed.connect (() => {
				searching_for_sig(_search_entry.text);
			});

		_search_entry.focus_in_event.connect ((e) => {
			search_has_focus_sig ();
			return true;
		});

		// Preferences button
		_prefs_button.image  = new Image.from_icon_name ("open-menu", IconSize.LARGE_TOOLBAR);
		_prefs_button.valign = Align.CENTER;
		_prefs_button.tooltip_text = _("Preferences");
		_prefs_button.popover      = new PreferencesPopover();

		_list_button.valign       = Align.CENTER;
		_list_button.tooltip_text = _("History");

       /*
            Layout
        */

       // pack LHS
        //pack_start (_tuner);
        pack_start (_tuner_status );
        pack_start (_volume_button);
        pack_start (_star_button);
        pack_start (_play_button);

	    _player_info = new Base.PlayerInfo(window, _player);
        custom_title = _player_info; // Station display

		// pack RHS
		pack_end (_prefs_button);
		pack_end (_list_button);

		/* Test fixture */
		//  private Button _off_button       = new Button.from_icon_name ("list-add", IconSize.LARGE_TOOLBAR);
		//  pack_end (_off_button);
		//  _off_button.clicked.connect (() => {
		//  	app().is_online = !app().is_online;
		//  });

		pack_end (_search_entry);
		show_close_button = true;


		/*
		    Tuner icon and online/offline behavior
		 */
		// HeaderBar reacts to app-level connectivity changes for visual state updates.
		_app.events.connectivity_changed_sig.connect((is_online) =>
		{
			update_controls_state();
		});

		_player.state_changed_sig.connect ((station, state) =>
		{
			update_controls_state();
		});

	    update_controls_state();

		_player_info.info_changed_completed_sig.connect(() =>
		// _player_info is going to signal when it has completed and the lock can be released
		{
			if (!_station_locked)
				return;
			_station_update_lock.unlock();
			_station_locked = false;
		});


		_player.metadata_changed_sig.connect ((station, metadata) =>
		{
			_list_button.append_station_title_pair(station, metadata.title);
		});

		_list_button.item_station_selected_sig.connect((station) =>
		{
			window.handle_play_station(station);
		});

	} // HeaderBar


    /* 
        Public 
    */


	/**
	* @brief Update the header bar with information from a new station.
	*
	* Requires a lock so that too many clicks do not cause a race condition
	*
	* @param station The new station to display information for.
	*/
	public bool update_playing_station(Station station)
	{
		if ( _app.is_offline || ( _station != null && _station == station && _player.player_state != Tuner.Controllers.PlayerController.Is.STOPPED_ERROR ) )
			return false;

		if (_station_update_lock.trylock())
		// Lock while changing the station to ensure single threading.
		// Lock is released when the info is updated on emit of info_changed_completed_sig
		{
			_station_locked       = true;
			//_player_info.metadata = STREAM_METADATA;

			Idle.add (() =>
			          // Initiate the fade out on a non-UI thread
			{

				if (_station_handler_id > 0)
				// Disconnect the old station starred handler
				{
					_station.disconnect(_station_handler_id);
					_station_handler_id = 0;
				}

				_player_info.change_station.begin(station, () =>
				{
					_station            = station;
					starred             = _station.starred;
					_station_handler_id = _station.station_star_changed_sig.connect((starred) => 
					{
						this.starred = starred;
					});
				});

				return Source.REMOVE;
			},Priority.HIGH_IDLE);

			return true;
		} // if
		return false;
	} // update_playing_station


	/**
	* @brief Override of the realize method from Widget for an initial animation
	*
	* Called when the widget is being realized (created and prepared for display).
	* This happens before the widget is actually shown on screen.
	*/
	public override void realize()
	{
		base.realize();

		_player_info.transition_type = RevealerTransitionType.SLIDE_UP; // Optional: add animation
		_player_info.set_transition_duration(REVEAL_DELAY*3);

		// Use Timeout to delay the reveal animation
		Timeout.add(REVEAL_DELAY*3, () => {
			_player_info.set_reveal_child(true);
			return Source.REMOVE;
		});
	} // realize


    /**
     */
    public void stream_info(bool show)
    {
        _player_info.title_label.show_metadata = show;        
    } // stream_info


    /**
     */
    public void stream_info_fast(bool fast)
    {
        _player_info.title_label.metadata_fast_cycle = fast;          
    } // stream_info_fast


	/*
		Private
	*/
	
	/**
	* @brief Checks and sets per the online status
	*
	* Desensitive when off-line
	*/
	private void update_controls_state()
	{
		bool is_playing_now = _player.player_state == PlayerController.Is.PLAYING
			|| _player.player_state == PlayerController.Is.BUFFERING;

		if (_app.is_offline)
		{
			_player_info.favicon_image.opacity = 0.5;
			_tuner_status.online               = false;
			_star_button.sensitive             = false;
			_play_button.sensitive             = is_playing_now;
			_play_button.opacity               = is_playing_now ? 1.0 : 0.5;
			_volume_button.sensitive           = false;
			_list_button.sensitive             = true;
			_search_entry.sensitive             = false;

		}
		else
		// Online - restore full functionality
		{
			_player_info.favicon_image.opacity = 1.0;
			_tuner_status.online               = true;
			_star_button.sensitive             = true;
			_play_button.sensitive             = true;
			_play_button.opacity               = 1.0;
			_volume_button.sensitive           = true;
			_list_button.sensitive             = true;
			_search_entry.sensitive             = true;
		}
	} // update_controls_state
} // Tuner.HeaderBar
