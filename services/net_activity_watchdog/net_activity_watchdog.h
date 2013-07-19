/*
 *
 * Copyright (c) 2013 by Alexander Wuerstlein <arw@arw.name>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License (either version 2 or
 * version 3) as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * For more information on the GPL, please go to:
 * http://www.gnu.org/copyleft/gpl.html
 */

#ifndef _NET_ACTIVITY_WATCHDOG_H
#define _NET_ACTIVITY_WATCHDOG_H
#include <stdbool.h>

/* State variable for net activity, set to 'true' when receiving a packet. Set
 * to 'false' by our cronjob if previously 'true', else cronjob initiates
 * reboot. Initialized to true to prevent race condition on bootup. */
extern volatile bool net_activity_detected = true;

/* periodically called by static cron entry */
void net_activity_watchdog_periodic(void);

#endif /* _NET_ACTIVITY_WATCHDOG_H */
