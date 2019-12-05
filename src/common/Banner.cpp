/*
 * Copyright (C) 2008-2017 TrinityCore <http://www.trinitycore.org/>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "Banner.h"
#include "GitRevision.h"
#include "StringFormat.h"

void Trinity::Banner::Show(char const* applicationName, void(*log)(char const* text), void(*logExtraInfo)())
{
    log(Trinity::StringFormat("%s (%s)", GitRevision::GetFullVersion(), applicationName).c_str());
    log("<Ctrl-C> to stop.\\n");
    log(R"(
     _________  ________  ___  ________   ___  _________    ___    ___ _________  ________  ________     
    |\___   ___\\   __  \|\  \|\   ___  \|\  \|\___   ___\ |\  \  /  /|\___   ___\\   __  \|\   ____\    
    \|___ \  \_\ \  \|\  \ \  \ \  \\ \  \ \  \|___ \  \_| \ \  \/  / ||___ \  \_\ \  \|\ /\ \  \___|    
         \ \  \ \ \   _  _\ \  \ \  \\ \  \ \  \   \ \  \   \ \    / /     \ \  \ \ \   __  \ \  \       
          \ \  \ \ \  \\  \\ \  \ \  \\ \  \ \  \   \ \  \   \/  /  /       \ \  \ \ \  \|\  \ \  \____  
           \ \__\ \ \__\\ _\\ \__\ \__\\ \__\ \__\   \ \__\__/  / /          \ \__\ \ \_______\ \_______\
            \|__|  \|__|\|__|\|__|\|__| \|__|\|__|    \|__|\___/ /            \|__|  \|_______|\|_______|
                                                          \|___|/                                        
    )");
    log(" ");

    if (logExtraInfo)
        logExtraInfo();
}
