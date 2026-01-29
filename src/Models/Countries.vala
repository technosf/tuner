/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020-2022 Louis Brauer <louis@brauer.family>
 */

using Gee;

/*
    ISO 3166-1 alpha-2 codes are two-letter country codes defined in ISO 3166-1, 
    part of the ISO 3166 standard[1] published by the 
    International Organization for Standardization (ISO), 
    to represent countries, dependent territories, 
    and special areas of geographical interest.
*/
namespace Tuner.Model {

    public class Countries {
        
        public static HashMap<string, string> _map = null;

        public static HashMap<string, string> map {
            get {
                if (_map == null) {
                    _map = new HashMap<string, string> ();
                    _map["AF"] = N_("Afghanistan");
                    _map["AX"] = N_("Åland Islands");
                    _map["AL"] = N_("Albania");
                    _map["DZ"] = N_("Algeria");
                    _map["AS"] = N_("American Samoa");
                    _map["AD"] = N_("Andorra");
                    _map["AO"] = N_("Angola");
                    _map["AI"] = N_("Anguilla");
                    _map["AQ"] = N_("Antarctica");
                    _map["AG"] = N_("Antigua and Barbuda");
                    _map["AR"] = N_("Argentina");
                    _map["AM"] = N_("Armenia");
                    _map["AW"] = N_("Aruba");
                    _map["AU"] = N_("Australia");
                    _map["AT"] = N_("Austria");
                    _map["AZ"] = N_("Azerbaijan");
                    _map["BS"] = N_("Bahamas");
                    _map["BH"] = N_("Bahrain");
                    _map["BD"] = N_("Bangladesh");
                    _map["BB"] = N_("Barbados");
                    _map["BY"] = N_("Belarus");
                    _map["BE"] = N_("Belgium");
                    _map["BZ"] = N_("Belize");
                    _map["BJ"] = N_("Benin");
                    _map["BM"] = N_("Bermuda");
                    _map["BT"] = N_("Bhutan");
                    _map["BO"] = N_("Bolivia");
                    _map["BQ"] = N_("Bonaire, Sint Eustatius and Saba");
                    _map["BA"] = N_("Bosnia and Herzegovina");
                    _map["BW"] = N_("Botswana");
                    _map["BV"] = N_("Bouvet Island");
                    _map["BR"] = N_("Brazil");
                    _map["IO"] = N_("British Indian Ocean Territory");
                    _map["BN"] = N_("Brunei Darussalam");
                    _map["BG"] = N_("Bulgaria");
                    _map["BF"] = N_("Burkina Faso");
                    _map["BI"] = N_("Burundi");
                    _map["CV"] = N_("Cabo Verde");
                    _map["KH"] = N_("Cambodia");
                    _map["CM"] = N_("Cameroon");
                    _map["CA"] = N_("Canada");
                    _map["KY"] = N_("Cayman Islands");
                    _map["CF"] = N_("Central African Republic");
                    _map["TD"] = N_("Chad");
                    _map["CL"] = N_("Chile");
                    _map["CN"] = N_("China");
                    _map["CX"] = N_("Christmas Island");
                    _map["CC"] = N_("Cocos (Keeling) Islands");
                    _map["CO"] = N_("Colombia");
                    _map["KM"] = N_("Comoros");
                    _map["CG"] = N_("Congo");
                    _map["CD"] = N_("Congo, Democratic Republic of the");
                    _map["CK"] = N_("Cook Islands");
                    _map["CR"] = N_("Costa Rica");
                    _map["CI"] = N_("Côte d'Ivoire");
                    _map["HR"] = N_("Croatia");
                    _map["CU"] = N_("Cuba");
                    _map["CW"] = N_("Curaçao");
                    _map["CY"] = N_("Cyprus");
                    _map["CZ"] = N_("Czechia");
                    _map["DK"] = N_("Denmark");
                    _map["DJ"] = N_("Djibouti");
                    _map["DM"] = N_("Dominica");
                    _map["DO"] = N_("Dominican Republic");
                    _map["EC"] = N_("Ecuador");
                    _map["EG"] = N_("Egypt");
                    _map["SV"] = N_("El Salvador");
                    _map["GQ"] = N_("Equatorial Guinea");
                    _map["ER"] = N_("Eritrea");
                    _map["EE"] = N_("Estonia");
                    _map["SZ"] = N_("Eswatini");
                    _map["ET"] = N_("Ethiopia");
                    _map["FK"] = N_("Falkland Islands (Malvinas)");
                    _map["FO"] = N_("Faroe Islands");
                    _map["FJ"] = N_("Fiji");
                    _map["FI"] = N_("Finland");
                    _map["FR"] = N_("France");
                    _map["GF"] = N_("French Guiana");
                    _map["PF"] = N_("French Polynesia");
                    _map["TF"] = N_("French Southern Territories");
                    _map["GA"] = N_("Gabon");
                    _map["GM"] = N_("Gambia");
                    _map["GE"] = N_("Georgia");
                    _map["DE"] = N_("Germany");
                    _map["GH"] = N_("Ghana");
                    _map["GI"] = N_("Gibraltar");
                    _map["GR"] = N_("Greece");
                    _map["GL"] = N_("Greenland");
                    _map["GD"] = N_("Grenada");
                    _map["GP"] = N_("Guadeloupe");
                    _map["GU"] = N_("Guam");
                    _map["GT"] = N_("Guatemala");
                    _map["GG"] = N_("Guernsey");
                    _map["GN"] = N_("Guinea");
                    _map["GW"] = N_("Guinea-Bissau");
                    _map["GY"] = N_("Guyana");
                    _map["HT"] = N_("Haiti");
                    _map["HM"] = N_("Heard Island and McDonald Islands");
                    _map["VA"] = N_("Holy See");
                    _map["HN"] = N_("Honduras");
                    _map["HK"] = N_("Hong Kong");
                    _map["HU"] = N_("Hungary");
                    _map["IS"] = N_("Iceland");
                    _map["IN"] = N_("India");
                    _map["ID"] = N_("Indonesia");
                    _map["IR"] = N_("Iran");
                    _map["IQ"] = N_("Iraq");
                    _map["IE"] = N_("Ireland");
                    _map["IM"] = N_("Isle of Man");
                    _map["IL"] = N_("Israel");
                    _map["IT"] = N_("Italy");
                    _map["JM"] = N_("Jamaica");
                    _map["JP"] = N_("Japan");
                    _map["JE"] = N_("Jersey");
                    _map["JO"] = N_("Jordan");
                    _map["KZ"] = N_("Kazakhstan");
                    _map["KE"] = N_("Kenya");
                    _map["KI"] = N_("Kiribati");
                    _map["KP"] = N_("Korea (Democratic People's Republic of)");
                    _map["KR"] = N_("Korea, Republic of");
                    _map["KW"] = N_("Kuwait");
                    _map["KG"] = N_("Kyrgyzstan");
                    _map["LA"] = N_("Lao People's Democratic Republic");
                    _map["LV"] = N_("Latvia");
                    _map["LB"] = N_("Lebanon");
                    _map["LS"] = N_("Lesotho");
                    _map["LR"] = N_("Liberia");
                    _map["LY"] = N_("Libya");
                    _map["LI"] = N_("Liechtenstein");
                    _map["LT"] = N_("Lithuania");
                    _map["LU"] = N_("Luxembourg");
                    _map["MO"] = N_("Macao");
                    _map["MG"] = N_("Madagascar");
                    _map["MW"] = N_("Malawi");
                    _map["MY"] = N_("Malaysia");
                    _map["MV"] = N_("Maldives");
                    _map["ML"] = N_("Mali");
                    _map["MT"] = N_("Malta");
                    _map["MH"] = N_("Marshall Islands");
                    _map["MQ"] = N_("Martinique");
                    _map["MR"] = N_("Mauritania");
                    _map["MU"] = N_("Mauritius");
                    _map["YT"] = N_("Mayotte");
                    _map["MX"] = N_("Mexico");
                    _map["FM"] = N_("Micronesia");
                    _map["MD"] = N_("Moldova");
                    _map["MC"] = N_("Monaco");
                    _map["MN"] = N_("Mongolia");
                    _map["ME"] = N_("Montenegro");
                    _map["MS"] = N_("Montserrat");
                    _map["MA"] = N_("Morocco");
                    _map["MZ"] = N_("Mozambique");
                    _map["MM"] = N_("Myanmar");
                    _map["NA"] = N_("Namibia");
                    _map["NR"] = N_("Nauru");
                    _map["NP"] = N_("Nepal");
                    _map["NL"] = N_("Netherlands");
                    _map["NC"] = N_("New Caledonia");
                    _map["NZ"] = N_("New Zealand");
                    _map["NI"] = N_("Nicaragua");
                    _map["NE"] = N_("Niger");
                    _map["NG"] = N_("Nigeria");
                    _map["NU"] = N_("Niue");
                    _map["NF"] = N_("Norfolk Island");
                    _map["MK"] = N_("North Macedonia");
                    _map["MP"] = N_("Northern Mariana Islands");
                    _map["NO"] = N_("Norway");
                    _map["OM"] = N_("Oman");
                    _map["PK"] = N_("Pakistan");
                    _map["PW"] = N_("Palau");
                    _map["PS"] = N_("Palestine");
                    _map["PA"] = N_("Panama");
                    _map["PG"] = N_("Papua New Guinea");
                    _map["PY"] = N_("Paraguay");
                    _map["PE"] = N_("Peru");
                    _map["PH"] = N_("Philippines");
                    _map["PN"] = N_("Pitcairn");
                    _map["PL"] = N_("Poland");
                    _map["PT"] = N_("Portugal");
                    _map["PR"] = N_("Puerto Rico");
                    _map["QA"] = N_("Qatar");
                    _map["RE"] = N_("Réunion");
                    _map["RO"] = N_("Romania");
                    _map["RU"] = N_("Russian Federation");
                    _map["RW"] = N_("Rwanda");
                    _map["BL"] = N_("Saint Barthélemy");
                    _map["SH"] = N_("Saint Helena, Ascension and Tristan da Cunha");
                    _map["KN"] = N_("Saint Kitts and Nevis");
                    _map["LC"] = N_("Saint Lucia");
                    _map["MF"] = N_("Saint Martin");
                    _map["PM"] = N_("Saint Pierre and Miquelon");
                    _map["VC"] = N_("Saint Vincent and the Grenadines");
                    _map["WS"] = N_("Samoa");
                    _map["SM"] = N_("San Marino");
                    _map["ST"] = N_("Sao Tome and Principe");
                    _map["SA"] = N_("Saudi Arabia");
                    _map["SN"] = N_("Senegal");
                    _map["RS"] = N_("Serbia");
                    _map["SC"] = N_("Seychelles");
                    _map["SL"] = N_("Sierra Leone");
                    _map["SG"] = N_("Singapore");
                    _map["SX"] = N_("Sint Maarten");
                    _map["SK"] = N_("Slovakia");
                    _map["SI"] = N_("Slovenia");
                    _map["SB"] = N_("Solomon Islands");
                    _map["SO"] = N_("Somalia");
                    _map["ZA"] = N_("South Africa");
                    _map["GS"] = N_("South Georgia and the South Sandwich Islands");
                    _map["SS"] = N_("South Sudan");
                    _map["ES"] = N_("Spain");
                    _map["LK"] = N_("Sri Lanka");
                    _map["SD"] = N_("Sudan");
                    _map["SR"] = N_("Suriname");
                    _map["SJ"] = N_("Svalbard and Jan Mayen");
                    _map["SE"] = N_("Sweden");
                    _map["CH"] = N_("Switzerland");
                    _map["SY"] = N_("Syrian Arab Republic");
                    _map["TW"] = N_("Taiwan");
                    _map["TJ"] = N_("Tajikistan");
                    _map["TZ"] = N_("Tanzania");
                    _map["TH"] = N_("Thailand");
                    _map["TL"] = N_("Timor-Leste");
                    _map["TG"] = N_("Togo");
                    _map["TK"] = N_("Tokelau");
                    _map["TO"] = N_("Tonga");
                    _map["TT"] = N_("Trinidad and Tobago");
                    _map["TN"] = N_("Tunisia");
                    _map["TR"] = N_("Turkey");
                    _map["TM"] = N_("Turkmenistan");
                    _map["TC"] = N_("Turks and Caicos Islands");
                    _map["TV"] = N_("Tuvalu");
                    _map["UG"] = N_("Uganda");
                    _map["UA"] = N_("Ukraine");
                    _map["AE"] = N_("United Arab Emirates");
                    _map["GB"] = N_("United Kingdom of Great Britain and Northern Ireland");
                    _map["US"] = N_("United States of America");
                    _map["UM"] = N_("United States Minor Outlying Islands");
                    _map["UY"] = N_("Uruguay");
                    _map["UZ"] = N_("Uzbekistan");
                    _map["VU"] = N_("Vanuatu");
                    _map["VE"] = N_("Venezuela");
                    _map["VN"] = N_("Vietnam");
                    _map["VG"] = N_("Virgin Islands (UK)");
                    _map["VI"] = N_("Virgin Islands (US)");
                    _map["WF"] = N_("Wallis and Futuna");
                    _map["EH"] = N_("Western Sahara");
                    _map["YE"] = N_("Yemen");
                    _map["ZM"] = N_("Zambia");
                    _map["ZW"] = N_("Zimbabwe");
                    _map["XK"] = N_("Kosovo");
                }
                return _map;
            }
        }

        public static string get_by_code(string code, string fallback = "") {
            var my_code = code.strip ();
            if (my_code == "") return fallback;
            if (map.has_key (my_code)) return map.get (my_code);
            return my_code;
        } 
   }
}
