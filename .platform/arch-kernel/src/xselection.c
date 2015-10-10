#ifndef lint
static char rcsid[] = "$Header$";
#endif !lint

/*
 * Copyright 1990 Richard Hesketh / rlh2@ukc.ac.uk
 *                Computing Lab. University of Kent at Canterbury, UK
 *
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the names of Richard Hesketh and The University of
 * Kent at Canterbury not be used in advertising or publicity pertaining to
 * distribution of the software without specific, written prior permission.
 * Richard Hesketh and The University of Kent at Canterbury make no
 * representations about the suitability of this software for any purpose.
 * It is provided "as is" without express or implied warranty.
 *
 * RICHARD HESKETH AND THE UNIVERSITY OF KENT AT CANTERBURY DISCLAIMS ALL
 * WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL RICHARD HESKETH OR THE
 * UNIVERSITY OF KENT AT CANTERBURY BE LIABLE FOR ANY SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
 * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
 * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
 * OF THIS SOFTWARE.
 *
 * Author:  Richard Hesketh / rlh2@ukc.ac.uk,
 *                Computing Lab. University of Kent at Canterbury, UK
 */

#include <stdio.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/types.h>
#include <X11/Xlib.h>
#include <X11/X.h>
#include <X11/Xatom.h>
#include <X11/Xproto.h>
#include <X11/Xresource.h>

#define PROG_NAME "xselection"

#define CHUNK 1000

static void send_selection();
static void own_selection();

static Atom selection_atom = NULL;
static unsigned char *current_selection = NULL;

static XrmOptionDescRec options[] = {
	{ "-display", ".display", XrmoptionSepArg, (caddr_t)NULL },
};

static unsigned char *get_selection();

static void
usage()
{
	fprintf(stderr, "usage: %s property [- | [--] new_value]\n",
								PROG_NAME);
	exit (-1);
}


static char *
emalloc(size)
int size;
{
	extern char *malloc();
	char *ret;

	if (size == 0)
		size = 1;
	ret = malloc((unsigned)size);

	if (ret == NULL) {
		fprintf(stderr, "%s: malloc failed\n", PROG_NAME);
		exit (-2);
	}
	return (ret);
}


static char *
erealloc(str, size)
char *str;
int size;
{
	extern char *realloc();
	char *ret;

	if (str == NULL)
		return (emalloc(size));
	if (size == 0)
		size = 1;
	ret = realloc(str, (unsigned)size);

	if (ret == NULL) {
		fprintf(stderr, "%s: realloc failed\n", PROG_NAME);
		exit (-2);
	}
	return (ret);
}


static unsigned char *
get_value_from_stdin()
{
	unsigned char *str;
	int count = 0, num_chunks = 1;
	int ch;

	str = (unsigned char *)emalloc(CHUNK);
	*str = '\0';

	ch = getchar();
	while (ch != EOF) {
		if (count % CHUNK == (CHUNK-3))
			str = (unsigned char *)erealloc(str,
						(++num_chunks * CHUNK));
		str[count++] = ch;
		ch = getchar();
	}
	str[count] = '\0';
	return (str);
}


main(argc, argv)
int argc;
char *argv[];
{
	Display *dpy;
	XEvent ev;
	char resource[100];
	char *blank, *display;
	XrmDatabase db = NULL;
	XrmValue value;
	Window window;
	int want_to_own = 0;

	XrmParseCommand(&db, options, 1, PROG_NAME, &argc, argv);

	(void)sprintf(resource, "%s.display", PROG_NAME);
	if (XrmGetResource(db, resource, "", &blank, &value))
		display = (char *)value.addr;
	else
		display = NULL;

	if ((dpy = XOpenDisplay(display)) == NULL) {
		fprintf(stderr, "%s: Couldn't open display %s\n",
				PROG_NAME, XDisplayName(display));
		exit (-1);
	}

	if (argc < 2 || argc > 4)
		usage();

	selection_atom = XInternAtom(dpy, argv[1], argc == 2);

	if (selection_atom == NULL) {
		fprintf(stderr, "%s: %s not a name of a known selection property\n",
					PROG_NAME, argv[1]);
		exit (-2);
	}

	if (argc == 3) {
		/* we want to set a property .. find the new value */
		if (strcmp(argv[2], "-") == 0)
			current_selection = get_value_from_stdin();
		else
			current_selection = (unsigned char *)argv[2];
		want_to_own = 1;
	} else if (argc == 4) {
		/* set a property to a value that is the same as a flag */
		if (strcmp(argv[2], "--") == 0)
			/* I bet this will never get used! .. but be safe */
			current_selection = (unsigned char *)argv[3];
		else
			usage();
		want_to_own = 1;
	}

	/* this window never gets mapped - its simply used as an ID */
	window = XCreateSimpleWindow(dpy, DefaultRootWindow(dpy),
							0, 0, 1, 1, 0, 0, 0);

	if (want_to_own)
		/* set the selection and wait for someone to take it */
		own_selection(dpy, window, selection_atom);
	else {
		/* get the selection */
		current_selection = get_selection(dpy, window, selection_atom);
		if (current_selection != NULL)
			printf("%s", current_selection);
		XCloseDisplay(dpy);
		exit (0);
	}

	switch (fork()) {
		case -1:
			fprintf(stderr, "%s: fork failed\n", PROG_NAME);
			break;
		case 0:
			/* child */
			XSelectInput(dpy, window, 0l);

			/* wait here 'til we lose the selection.
			 * respond to any SelectionRequests
			 */
			while (1) {
				XNextEvent(dpy, &ev);
				if (ev.type == SelectionClear &&
				    ev.xselectionclear.selection
				    == selection_atom)
					break;
				if (ev.type == SelectionRequest &&
				    ev.xselectionrequest.selection
				    == selection_atom)
					send_selection(dpy, &ev);
			}
			XCloseDisplay(dpy);
			exit (0);
			break; /* NOTREACHED */
	}
}


/* Send a copy of the our owned selection to the requestor.
 * We do this by changing the contents of the property given in the
 * SelectionRequest event.
 */
static void
send_selection(dpy, ptr_event)
Display *dpy;
XEvent *ptr_event;
{
        XSelectionEvent notify_event;
        XSelectionRequestEvent  *req_event;
        unsigned char *data;

        data = current_selection;

        XChangeProperty(ptr_event->xselectionrequest.display,
                        ptr_event->xselectionrequest.requestor,
                        ptr_event->xselectionrequest.property,
                        ptr_event->xselectionrequest.target,
                        8, PropModeReplace, data,
                        (current_selection == NULL) ?
			0 : strlen(current_selection));

        req_event = &(ptr_event->xselectionrequest);

        notify_event.type      = SelectionNotify;
        notify_event.display   = req_event->display;
        notify_event.requestor = req_event->requestor;
        notify_event.selection = req_event->selection;
        notify_event.target    = req_event->target;
        notify_event.time      = req_event->time;

        if (req_event->property == None)
                notify_event.property = req_event->target;
        else
                notify_event.property = req_event->property;

	/* tell the requestor he has a copy of the selection */
        (void) XSendEvent(req_event->display, req_event->requestor,
					False, 0, (XEvent *)&notify_event);
	XFlush(dpy);
}


/* Request and retrieve a copy of the current selection property */
static unsigned char *
get_selection(dpy, window, atom)
Display *dpy;
Window window;
Atom atom;
{
	XEvent  event;
        static struct   timeval timeout = {3, 0};
        int     server_fd_mask;
        extern int      errno;
        Atom    actual_type;
        int     actual_format;
        unsigned long   nitems, bytes_after;
        unsigned char    *data;
        int     old_inmode;

	/* tell the server we want a copy of the selection */
        XConvertSelection(dpy, atom, XA_STRING, XA_STRING, window, CurrentTime);
        server_fd_mask = (1 << ConnectionNumber(dpy));

        do {
                int     result;

                do {
                        if (XPending(dpy) > 0)
                                result = 1;
                        else {
                                result = select(32, &server_fd_mask,
						(int *)NULL, (int *)NULL,
						&timeout);
                                if (result == -1 && errno != EINTR) {
                                        fprintf(stderr, "%s: select failed in get_selection (errno:%d)\n",
							PROG_NAME, errno);
					exit (-1);
                                }
                        }
                } while (result == -1);

                if (result == 0)
                        return NULL;

                XNextEvent(dpy, &event);
                if (event.type == SelectionRequest)
			send_selection(dpy, window, atom, &event);
        } while (event.type != SelectionNotify);

        if (event.xselection.property == None)
                return NULL;

        XGetWindowProperty(dpy,
                event.xselection.requestor,
                event.xselection.property,
                0L, 10240L,
                False,
                AnyPropertyType,
                &actual_type,
                &actual_format,
                &nitems,
                &bytes_after,
                (unsigned char **)&data);

	return data;
}


/* tell the server we want to own the selection */
static void
own_selection(dpy, window, atom)
Display *dpy;
Window window;
Atom atom;
{
        XSetSelectionOwner(dpy, atom, window, CurrentTime);
	XFlush(dpy);
}
