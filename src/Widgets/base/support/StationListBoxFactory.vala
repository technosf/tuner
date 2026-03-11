/*
 * SPDX-FileCopyrightText: 2020-2022 Louis Brauer <louis@brauer.family>
 * SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Gee;
using Gtk;
using Tuner.Models;
using Tuner.Widgets.Granite;

namespace Tuner.Widgets.Base.Support
{
    /**
    * @class StationListBoxFactory
    * @brief Factory for StationListBox instances.
    */
    public class StationListBoxFactory
    {
        public static StationListBox create(StationListBoxConfig cfg)
        {
            var prepopulated = cfg.stations != null;
            var slb = new StationListBox(
                cfg.stack,
                cfg.source_list,
                cfg.category,
                cfg.name,
                cfg.icon,
                cfg.title,
                cfg.subtitle,
                prepopulated,
                cfg.station_set,
                cfg.action_tooltip_text,
                cfg.action_icon_name
            );

            cfg.stack.add_named (slb, cfg.name);

            if (cfg.stations != null)
            {
                var slist = StationList.with_stations (cfg.stations);
                if (cfg.station_list_hookup != null)
                {
                    slb.attach_station_list (cfg.station_list_hookup, slist);
                }
                else
                {
                    slb.content = slist;
                }
            }

            return slb;
        }
    } // StationListBoxFactory
} // Tuner
