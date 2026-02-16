/*
 * SPDX-FileCopyrightText: Copyright © 2026 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file Languages.vala
 *
 * @brief Language names for various language codes related to available translations
 * 
 */

using Gee;

/*
    Language names for various language codes related to available translations. 

    ISO 3166-1 alpha-2 codes are two-letter country codes defined in ISO 3166-1, 
    part of the ISO 3166 standard[1] published by the International Organization for Standardization (ISO), 
    to represent countries, dependent territories, and special areas of geographical interest.

    BCP 47 language tags are a standardized code used to identify human languages. 
    They are defined by the Internet Engineering Task Force (IETF) in RFC 5646,

    Language code look up references:
        https://stringcatalog.com/languages/es/es-419

*/
namespace Tuner.Model {

    public class Languages {
        
        public static HashMap<string, string> _map = null;

        public static HashMap<string, string> map {
            get {
                if (_map == null) {
                    _map = new HashMap<string, string> ();
                    _map["ar"] = NC_("Languages","Arabic");
                    _map["bg"] = NC_("Languages","Bulgarian");
                    _map["cs"] = NC_("Languages","Czech");
                    _map["da"] = NC_("Languages","Danish");
                    _map["de"] = NC_("Languages","German");
                    _map["en"] = NC_("Languages","English");
                    _map["es_419"] = NC_("Languages","Spanish (Latin America)");
                    _map["es"] = NC_("Languages","Spanish");
                    _map["et"] = NC_("Languages","Estonian");
                    _map["fa"] = NC_("Languages","Persian");
                    _map["fr"] = NC_("Languages","French");
                    _map["gu"] = NC_("Languages","Gujarati");
                    _map["hu"] = NC_("Languages","Hungarian");
                    _map["id"] = NC_("Languages","Indonesian");
                    _map["is"] = NC_("Languages","Icelandic");
                    _map["it"] = NC_("Languages","Italian");
                    _map["ja"] = NC_("Languages","Japanese");
                    _map["ko"] = NC_("Languages","Korean");
                    _map["lt"] = NC_("Languages","Lithuanian");
                    _map["lv"] = NC_("Languages","Latvian");
                    _map["ms"] = NC_("Languages","Malay");
                    _map["nb_NO"] = NC_("Languages","Norwegian (Bokmal)");
                    _map["nl"] = NC_("Languages","Dutch");
                    _map["pt_BR"] = NC_("Languages","Portuguese (Brazil)");
                    _map["ro"] = NC_("Languages","Romanian");
                    _map["ru"] = NC_("Languages","Russian");
                    _map["sk"] = NC_("Languages","Slovak");
                    _map["sl"] = NC_("Languages","Slovenian");
                    _map["sr"] = NC_("Languages","Serbian");
                    _map["sw"] = NC_("Languages","Swahili");
                    _map["ta"] = NC_("Languages","Tamil");
                    _map["th"] = NC_("Languages","Thai");
                    _map["tr"] = NC_("Languages","Turkish");
                    _map["uk"] = NC_("Languages","Ukrainian");
                    _map["vi"] = NC_("Languages","Vietnamese");
                    _map["zh_Hant"] = NC_("Languages","Traditional Chinese");
                }
                return _map;
            }
        }

        public static string get_by_code(string code, string fallback = "") {
            var my_code = code.strip ();
            if (my_code == "") return fallback;
            if (map.has_key (my_code)) return dpgettext2(null, "Languages", map.get(my_code));
            return my_code;
        } 
   }
}
