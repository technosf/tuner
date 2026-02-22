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
        
        private static string? current_locale = null;

        private static SortedMap<string,string>? cached_map = null;

        private static SortedMap<string, string> _map = null;

        public static Map<string, string> map {
            get {
                if (_map == null) {
                    _map = new TreeMap<string, string> ();
                    _map["aa"] = NC_("Languages","Afar");
                    _map["ab"] = NC_("Languages","Abkhazian");
                    _map["ae"] = NC_("Languages","Avestan");
                    _map["af"] = NC_("Languages","Afrikaans");
                    _map["ak"] = NC_("Languages","Akan");
                    _map["am"] = NC_("Languages","Amharic");
                    _map["an"] = NC_("Languages","Aragonese");
                    _map["ar"] = NC_("Languages","Arabic");
                    _map["as"] = NC_("Languages","Assamese");
                    _map["av"] = NC_("Languages","Avaric");
                    _map["ay"] = NC_("Languages","Aymara");
                    _map["az"] = NC_("Languages","Azerbaijani");

                    _map["ba"] = NC_("Languages","Bashkir");
                    _map["be"] = NC_("Languages","Belarusian");
                    _map["bg"] = NC_("Languages","Bulgarian");
                    _map["bh"] = NC_("Languages","Bihari");
                    _map["bi"] = NC_("Languages","Bislama");
                    _map["bm"] = NC_("Languages","Bambara");
                    _map["bn"] = NC_("Languages","Bengali");
                    _map["bo"] = NC_("Languages","Tibetan");
                    _map["br"] = NC_("Languages","Breton");
                    _map["bs"] = NC_("Languages","Bosnian");

                    _map["ca"] = NC_("Languages","Catalan");
                    _map["ce"] = NC_("Languages","Chechen");
                    _map["ch"] = NC_("Languages","Chamorro");
                    _map["co"] = NC_("Languages","Corsican");
                    _map["cr"] = NC_("Languages","Cree");
                    _map["cs"] = NC_("Languages","Czech");
                    _map["cu"] = NC_("Languages","Church Slavic");
                    _map["cv"] = NC_("Languages","Chuvash");
                    _map["cy"] = NC_("Languages","Welsh");

                    _map["da"] = NC_("Languages","Danish");
                    _map["de"] = NC_("Languages","German");
                    _map["dv"] = NC_("Languages","Divehi");
                    _map["dz"] = NC_("Languages","Dzongkha");

                    _map["ee"] = NC_("Languages","Ewe");
                    _map["el"] = NC_("Languages","Greek");
                    _map["en"] = NC_("Languages","English");
                    _map["eo"] = NC_("Languages","Esperanto");
                    _map["es"] = NC_("Languages","Spanish");
                    _map["es_419"] = NC_("Languages","Spanish (Latin America)");
                    _map["et"] = NC_("Languages","Estonian");
                    _map["eu"] = NC_("Languages","Basque");

                    _map["fa"] = NC_("Languages","Persian");
                    _map["ff"] = NC_("Languages","Fulah");
                    _map["fi"] = NC_("Languages","Finnish");
                    _map["fj"] = NC_("Languages","Fijian");
                    _map["fo"] = NC_("Languages","Faroese");
                    _map["fr"] = NC_("Languages","French");
                    _map["fy"] = NC_("Languages","Western Frisian");

                    _map["ga"] = NC_("Languages","Irish");
                    _map["gd"] = NC_("Languages","Scottish Gaelic");
                    _map["gl"] = NC_("Languages","Galician");
                    _map["gn"] = NC_("Languages","Guarani");
                    _map["gu"] = NC_("Languages","Gujarati");
                    _map["gv"] = NC_("Languages","Manx");

                    _map["ha"] = NC_("Languages","Hausa");
                    _map["he"] = NC_("Languages","Hebrew");
                    _map["hi"] = NC_("Languages","Hindi");
                    _map["ho"] = NC_("Languages","Hiri Motu");
                    _map["hr"] = NC_("Languages","Croatian");
                    _map["ht"] = NC_("Languages","Haitian");
                    _map["hu"] = NC_("Languages","Hungarian");
                    _map["hy"] = NC_("Languages","Armenian");
                    _map["hz"] = NC_("Languages","Herero");

                    _map["ia"] = NC_("Languages","Interlingua");
                    _map["id"] = NC_("Languages","Indonesian");
                    _map["ie"] = NC_("Languages","Interlingue");
                    _map["ig"] = NC_("Languages","Igbo");
                    _map["ii"] = NC_("Languages","Sichuan Yi");
                    _map["ik"] = NC_("Languages","Inupiaq");
                    _map["io"] = NC_("Languages","Ido");
                    _map["is"] = NC_("Languages","Icelandic");
                    _map["it"] = NC_("Languages","Italian");
                    _map["iu"] = NC_("Languages","Inuktitut");

                    _map["ja"] = NC_("Languages","Japanese");
                    _map["jv"] = NC_("Languages","Javanese");

                    _map["ka"] = NC_("Languages","Georgian");
                    _map["kg"] = NC_("Languages","Kongo");
                    _map["ki"] = NC_("Languages","Kikuyu");
                    _map["kj"] = NC_("Languages","Kwanyama");
                    _map["kk"] = NC_("Languages","Kazakh");
                    _map["kl"] = NC_("Languages","Kalaallisut");
                    _map["km"] = NC_("Languages","Khmer");
                    _map["kn"] = NC_("Languages","Kannada");
                    _map["ko"] = NC_("Languages","Korean");
                    _map["kr"] = NC_("Languages","Kanuri");
                    _map["ks"] = NC_("Languages","Kashmiri");
                    _map["ku"] = NC_("Languages","Kurdish");
                    _map["kv"] = NC_("Languages","Komi");
                    _map["kw"] = NC_("Languages","Cornish");
                    _map["ky"] = NC_("Languages","Kirghiz");

                    _map["la"] = NC_("Languages","Latin");
                    _map["lb"] = NC_("Languages","Luxembourgish");
                    _map["lg"] = NC_("Languages","Ganda");
                    _map["li"] = NC_("Languages","Limburgish");
                    _map["ln"] = NC_("Languages","Lingala");
                    _map["lo"] = NC_("Languages","Lao");
                    _map["lt"] = NC_("Languages","Lithuanian");
                    _map["lv"] = NC_("Languages","Latvian");

                    _map["mg"] = NC_("Languages","Malagasy");
                    _map["mh"] = NC_("Languages","Marshallese");
                    _map["mi"] = NC_("Languages","Maori");
                    _map["mk"] = NC_("Languages","Macedonian");
                    _map["ml"] = NC_("Languages","Malayalam");
                    _map["mn"] = NC_("Languages","Mongolian");
                    _map["mr"] = NC_("Languages","Marathi");
                    _map["ms"] = NC_("Languages","Malay");
                    _map["mt"] = NC_("Languages","Maltese");
                    _map["my"] = NC_("Languages","Burmese");

                    _map["na"] = NC_("Languages","Nauru");
                    _map["nb"] = NC_("Languages","Norwegian Bokmal");
                    _map["nb_NO"] = NC_("Languages","Norwegian (Bokmal)");
                    _map["nd"] = NC_("Languages","North Ndebele");
                    _map["ne"] = NC_("Languages","Nepali");
                    _map["ng"] = NC_("Languages","Ndonga");
                    _map["nl"] = NC_("Languages","Dutch");
                    _map["nn"] = NC_("Languages","Norwegian Nynorsk");
                    _map["no"] = NC_("Languages","Norwegian");
                    _map["nr"] = NC_("Languages","South Ndebele");
                    _map["nv"] = NC_("Languages","Navajo");
                    _map["ny"] = NC_("Languages","Chichewa");

                    _map["oc"] = NC_("Languages","Occitan");
                    _map["oj"] = NC_("Languages","Ojibwa");
                    _map["om"] = NC_("Languages","Oromo");
                    _map["or"] = NC_("Languages","Oriya");
                    _map["os"] = NC_("Languages","Ossetian");

                    _map["pa"] = NC_("Languages","Punjabi");
                    _map["pi"] = NC_("Languages","Pali");
                    _map["pl"] = NC_("Languages","Polish");
                    _map["ps"] = NC_("Languages","Pashto");
                    _map["pt"] = NC_("Languages","Portuguese");
                    _map["pt_BR"] = NC_("Languages","Portuguese (Brazil)");

                    _map["qu"] = NC_("Languages","Quechua");

                    _map["rm"] = NC_("Languages","Romansh");
                    _map["rn"] = NC_("Languages","Rundi");
                    _map["ro"] = NC_("Languages","Romanian");
                    _map["ru"] = NC_("Languages","Russian");
                    _map["rw"] = NC_("Languages","Kinyarwanda");

                    _map["sa"] = NC_("Languages","Sanskrit");
                    _map["sc"] = NC_("Languages","Sardinian");
                    _map["sd"] = NC_("Languages","Sindhi");
                    _map["se"] = NC_("Languages","Northern Sami");
                    _map["sg"] = NC_("Languages","Sango");
                    _map["si"] = NC_("Languages","Sinhala");
                    _map["sk"] = NC_("Languages","Slovak");
                    _map["sl"] = NC_("Languages","Slovenian");
                    _map["sm"] = NC_("Languages","Samoan");
                    _map["sn"] = NC_("Languages","Shona");
                    _map["so"] = NC_("Languages","Somali");
                    _map["sq"] = NC_("Languages","Albanian");
                    _map["sr"] = NC_("Languages","Serbian");
                    _map["ss"] = NC_("Languages","Swati");
                    _map["st"] = NC_("Languages","Southern Sotho");
                    _map["su"] = NC_("Languages","Sundanese");
                    _map["sv"] = NC_("Languages","Swedish");
                    _map["sw"] = NC_("Languages","Swahili");

                    _map["ta"] = NC_("Languages","Tamil");
                    _map["te"] = NC_("Languages","Telugu");
                    _map["tg"] = NC_("Languages","Tajik");
                    _map["th"] = NC_("Languages","Thai");
                    _map["ti"] = NC_("Languages","Tigrinya");
                    _map["tk"] = NC_("Languages","Turkmen");
                    _map["tl"] = NC_("Languages","Tagalog");
                    _map["tn"] = NC_("Languages","Tswana");
                    _map["to"] = NC_("Languages","Tonga");
                    _map["tr"] = NC_("Languages","Turkish");
                    _map["ts"] = NC_("Languages","Tsonga");
                    _map["tt"] = NC_("Languages","Tatar");
                    _map["tw"] = NC_("Languages","Twi");
                    _map["ty"] = NC_("Languages","Tahitian");

                    _map["ug"] = NC_("Languages","Uighur");
                    _map["uk"] = NC_("Languages","Ukrainian");
                    _map["ur"] = NC_("Languages","Urdu");
                    _map["uz"] = NC_("Languages","Uzbek");

                    _map["ve"] = NC_("Languages","Venda");
                    _map["vi"] = NC_("Languages","Vietnamese");
                    _map["vo"] = NC_("Languages","Volapuk");

                    _map["wa"] = NC_("Languages","Walloon");
                    _map["wo"] = NC_("Languages","Wolof");

                    _map["xh"] = NC_("Languages","Xhosa");

                    _map["yi"] = NC_("Languages","Yiddish");
                    _map["yo"] = NC_("Languages","Yoruba");

                    _map["za"] = NC_("Languages","Zhuang");
                    _map["zh"] = NC_("Languages","Chinese");
                    _map["zh_Hant"] = NC_("Languages","Traditional Chinese");
                    _map["zu"] = NC_("Languages","Zulu");

                }
                return _map;
            }
        }


        /**
         * @brief Returns the translated name for a given language code.
         * @param code The language code to look up.
         * @param fallback The fallback string if the code is not found.
         * @return The translated name of the language or the fallback string.
         */
        public static string get_by_code(string code, string fallback = "") 
        {
            var my_code = code.strip ();
            if (my_code == "") return fallback;
            if (map.has_key (my_code)) return dpgettext2(null, "Languages", map.get(my_code));
            if (map.has_key (my_code.down())) return dpgettext2(null, "Languages", map.get(my_code.down()));
            return my_code;
        } 


        /**
         * @brief Returns a map of language codes to their translated names.
         * @return Map of language codes to translated names.
         */
        public static Map<string,string> get_language_map () 
        {
            ensure_locale ();
            return cached_map;
        }

        
        /**
        * @brief Rebuilds the cached map of language codes to their translated names based on the current locale.
         */
        private static void rebuild_language_cache () 
        {
            cached_map = new TreeMap<string,string> ();

            foreach (string id in Application.LANGUAGES) {
                cached_map[id] = dpgettext2(null, "Languages", map.get(id));
            }
        }


        /**
        * @brief Ensures that the language map is built for the current locale, rebuilding it if the locale has changed.
         */
        private static void ensure_locale () 
        {
            string loc = Intl.get_language_names ()[0];

            if (current_locale == loc && cached_map != null)
                return;

            current_locale = loc;
            rebuild_language_cache ();
        }
   }
}
