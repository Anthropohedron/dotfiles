#!/usr/bin/env ruby

require 'rubygems'
require 'dbus'
require 'real_growl'

IconFile = File.join(ENV["HOME"], "pidgin.ico")
AppName = "finch-notify"
Notifier = RealGrowl::Application.new(AppName);
#GrowlCmdPrefix = [ "growlnotify", "-w", "--image", IconFile, "-n", AppName, "-d" ]

sleep 3
bus = DBus::SessionBus.instance
pidgin_service = bus.service("im.pidgin.purple.PurpleService")
pidgin_object = pidgin_service.object("/im/pidgin/purple/PurpleObject")
pidgin_object.introspect
pidgin = pidgin_object["im.pidgin.purple.PurpleInterface"]

def notify(type, account, msg)
  #cmd = GrowlCmdPrefix + [ type, "-m", msg, account ]
  #system(*cmd)
  Notifier.notify(
    :icon => IconFile,
    :title => account,
    :description => msg
  )
end

pidgin.on_signal(bus, "ReceivedImMsg") do |account, from, msg, conv, flags|
  msg = pidgin.PurpleMarkupStripHtml(msg).first
  notify("Received IM message", from, msg)
end

pidgin.on_signal(bus, "ReceivedChatMsg") do |account, from, msg, conv, flags|
  msg = pidgin.PurpleMarkupStripHtml(msg).first
  notify("Received Chat message", from, msg)
end

loop = DBus::Main.new
loop << bus
loop.run
