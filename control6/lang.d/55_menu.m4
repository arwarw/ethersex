dnl
dnl  Copyright (c) 2009 by Stefan Siegl <stesie@brokenpipe.de>
dnl
dnl  This program is free software; you can redistribute it and/or modify
dnl  it under the terms of the GNU General Public License as published by
dnl  the Free Software Foundation; either version 3 of the License, or
dnl  (at your option) any later version.
dnl
dnl  This program is distributed in the hope that it will be useful,
dnl  but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl  GNU General Public License for more details.
dnl
dnl  You should have received a copy of the GNU General Public License
dnl  along with this program; if not, write to the Free Software
dnl  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
dnl
dnl  For more information on the GPL, please go to:
dnl  http://www.gnu.org/copyleft/gpl.html
dnl


dnl Print the message $1 to the ``parent line'' of the menu.  $1 is a PGM_P
dnl to the message.
define(`_MENU_PRINT_PARENT', `dnl
	TTY_SELECT(menu)
	TTY_CLEAR()
	TTY_USED()waddstr_P(c6win,$1);
')


dnl Print the message $1 to the ``main line'' of the menu.  $1 is a PGM_P
dnl to the message.
define(`_MENU_PRINT_MAIN', `dnl
	TTY_SELECT(menu)
	TTY_GOTO(1,0)
	TTY_USED()waddstr_P(c6win,$1);
	TTY_CLRTOEOL()
')


dnl Exit the menu.
define(`_MENU_EXIT', `dnl
	TTY_SELECT(menu)
	TTY_CLEAR()
	THREAD_EXIT()
')


dnl Menuitem helper macro.  Probably you want to derive your menuitem
dnl implementations from this one.
define(`_MENUITEM', `
define(`thismenu', `menu'__line__)thismenu:
	_MENU_PRINT_MAIN($1)

	{ uint8_t ch;
	PT_WAIT_UNTIL(pt, (ch = TTY_GETCH()));
	switch (ch) {
	case 106: 	/* j -> down */
		break;	/* we just wanna fall through to the next menuitem ... */

	case 107: 	/* k -> up */
		goto prevmenu;	/* jump up to the previous item ... */

	case 10: 	/* return -> action */
		{ $2 }
		_MENU_EXIT()

	default:	/* invalid response -> ignore */
		goto thismenu;	/* jump to current item -> try next char */
	}}
define(`prevmenu', thismenu) /* end of prevmenu ($1) */
')


dnl ==========================================================================
dnl MENUITEM(NAME, ACTIONS)
dnl ==========================================================================
define(`MENUITEM', `_MENUITEM(PSTR ($1), $2)')


dnl ==========================================================================
dnl MENU(WIDTH, Y, X, NAME, ITEMS)
dnl ==========================================================================
define(`prevmenu', `rootmenu')
define(`MENU', `
define(`old_divert', divnum)dnl
divert(init_divert)dnl
        TTY_CREATE_WINDOW_NOSEL(menu, 2, $1, $2, $3)

divert(globals_divert)dnl
	`const char PROGMEM parent_menu_name'__line__[] = $4;
divert(old_divert)dnl

	THREAD(menu)
rootmenu:
	{
		_MENU_PRINT_PARENT(`parent_menu_name'__line__)

		/* Items of menu $4 */
		$5
		/* End of menu $4 */
		goto prevmenu;
	}
	THREAD_END(menu)
')


dnl ==========================================================================
dnl MENU_START()
dnl ==========================================================================
define(`MENU_START', `THREAD_START(menu)')


dnl ==========================================================================
dnl MENU_STARTED()
dnl ==========================================================================
define(`MENU_STARTED', `THREAD_STARTED(menu)')
