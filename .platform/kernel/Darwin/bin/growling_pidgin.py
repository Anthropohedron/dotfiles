#!/usr/bin/env python

"""Growl notifications for Finch/Pidgin events

This Python script uses D-Bus to detect when a message is received,
and shows a Growl notification with the message (like Adium).
"""

import Growl
import dbus,gobject

# D-Bus globals
from dbus.mainloop.glib import DBusGMainLoop
dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
bus = dbus.SessionBus()

# Growl globals
g = Growl.GrowlNotifier(applicationName="finch-notify",
                        notifications = ["Received IM message", "Received Chat message"],
                        applicationIcon = Growl.Image.imageFromPath("pidgin.ico"))
g.register()

# Main starts here
def main():
    
    bus.add_signal_receiver(announce_signal,
                            #dbus_interface="im.pidgin.purple.PurpleInterface",
                            interface_keyword='dbus_interface',
                            member_keyword="member")

    bus.add_signal_receiver(received_msg,
                            dbus_interface="im.pidgin.purple.PurpleInterface",
                            signal_name="ReceivedImMsg")

    bus.add_signal_receiver(received_msg,
                            dbus_interface="im.pidgin.purple.PurpleInterface",
                            signal_name="ReceivedChatMsg")

    loop = gobject.MainLoop()
    loop.run()
            
def received_msg(account, sender, message, conv, flags):
    """Show Growl notification when a message is received"""

    obj = bus.get_object("im.pidgin.purple.PurpleService", "/im/pidgin/purple/PurpleObject")
    purple = dbus.Interface(obj, "im.pidgin.purple.PurpleInterface")

    pmesg = purple.PurpleMarkupStripHtml(message)
    unread = purple.PurpleConversationGetData(conv, "unseen-count")

    type = purple.PurpleConversationGetType(conv)

    if unread or True:
        if type == 1: # That's PURPLE_CONV_TYPE_IM
            g.notify("Received IM message", purple.PurpleConversationGetTitle(conv), pmesg)
        else:
            g.notify("Received Chat message", sender, pmesg)
#    else:
#        s = "Ignored IM message: unread ="
#        t = "                    "
#        print s, unread
#        print t, purple.PurpleConversationGetTitle(conv), ": ", pmesg

def announce_signal(*args, **kwargs):
    signalName = kwargs['member']

    wellknownSignals = [ "CipherAdded", ]

    knownSignals = [
        "SendingImMsg", "SentImMsg", "ReceivingImMsg", "ReceivedImMsg", 
        "JabberSendingText", "JabberSendingXmlnode", "JabberReceivingXmlnode",
        "WritingImMsg", "WroteImMsg",
        "LogTimestamp", 
        "ConversationUpdated", "DeletingConversation", "ConversationCreated",
        "BuddyTyping", "BuddyTypingStopped", "BuddyTyped",
        "BuddySignedOn", "BuddySignedOff", "BuddyStatusChanged", "BuddyIconChanged",
        "UpdateIdle", "SavedstatusChanged", "SavedstatusAdded", "SavedstatusModified",
        "AccountConnecting", "AccountConnected", "AccountStatusCreated", "AccountStatusChanged",
        "Quitting", "SigningOn", "SignedOn", "SigningOff", "SignedOff",
        "CipherAdded", "CipherRemoved", "PluginLoad", "PluginUnload", "PlayingSoundEvent",
        "BuddyAdded", "BuddyPrivacyChanged", "AccountAdded", "AccountAliasChanged",
        "BlistNodeAliased", "DisplayingEmailNotification",
        "ConversationTimestamp", "AccountErrorChanged", "ConnectionError",
        "GtkblistUnhiding", "GtkblistCreated", "DrawingTooltip",
        "ConversationSwitched", "ConversationExtendedMenu", "BlistNodeExtendedMenu",
        "DisplayingImMsg", "DisplayedImMsg", "ConversationHiding", "ConversationDisplayed",
        "DisplayedChatMsg", "DisplayingChatMsg", "WroteChatMsg", "WritingChatMsg",
        "ReceivingChatMsg", "SendingChatMsg", "SentChatMsg",
        "ConversationDragging", "BuddyIdleChanged", "AccountDisabled",
        ]

    if signalName in knownSignals:
        return

#    print "Got signal " + kwargs['member'] + " in " + kwargs["dbus_interface"]
#    t  =  "           "
#    for arg in args:
#        print t, arg
#    for k in kwargs:
#        if k != 'member' and k != 'dbus_interface':
#            print t, "Also: ", k, "is", kwargs[k]
#    print " "

if __name__ == "__main__":
    main()
