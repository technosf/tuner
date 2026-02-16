/**
 * SPDX-FileCopyrightText: Copyright © 2020-2024 Louis Brauer <louis@brauer.family>
 * SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * @file Main.vala
 *
 * @brief Tuner application entry point
 * 
 */
 
using GLib;
using Posix;

void on_signal (int sig) {
    GLib.stderr.printf ("Tuner abending with Signal %d\n", sig);
    GLib.stderr.flush ();
    Posix._exit (128 + sig);
}

public static int main (string[] args) 
{
    Posix.signal (Posix.Signal.SEGV, on_signal);
    Posix.signal (Posix.Signal.ABRT, on_signal);
    Posix.signal (Posix.Signal.BUS,  on_signal);

    Intl.setlocale (LocaleCategory.ALL, "");
    Gst.init (ref args);
    var app = Tuner.Application.instance;
    return app.run (args);
}
