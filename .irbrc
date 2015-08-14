# vim: ft=ruby
require 'irb/completion'

if ENV['RAILS_ENV']
  # Rails-specific stuff goes here, for script/console

  # kinkiness modified from http://errtheblog.com/post/43
  def Object.method_added(method, &block)
    return super(method, &block) unless method == :helper
    (class<<self;self;end).send(:remove_method, :method_added)

    $helper_proxy = ActionView::Base.new
    define_method(:helper) do |*helper_names|
      returning $helper_proxy do |h_obj|
        helper_names.each { |h|
          h = "#{h}_helper".classify.constantize
          h_obj.extend h
        }
      end
    end

    helper.controller = ActionController::Integration::Session.new
    helper :application
  end
end

class Class
  def descendents
    out = []
    ObjectSpace.each_object( Class ) {|k| out << k if k < self }
    return out
  end
end

def self.wirble
  # load rubygems and wirble
  require 'rubygems'
  require 'wirble'

  # load wirble
  Wirble.init(:skip_shortcuts => true,
              :skip_libraries => true,
              :skip_prompt => true,
              :init_colors => true
             )
  Wirble::Colorize.colors.merge!(:symbol => :cyan,
                                  :symbol_prefix => :blue,
                                  :object_class => :red,
                                  :comma => :brown,
                                  :refers => :brown
                                 )
  Wirble::Shortcuts.module_eval do
    def loop_execute(file)
      old_mtime = nil
      loop do
        # print("\e[sWaiting...")
        sleep(0.2) while (mtime = File.stat(file).mtime) == old_mtime
        # print("\e[u\e[K")
        begin
          r = eval(File.read(file))
          puts("=> #{r.inspect}")
        rescue IRB::Abort
          puts("Abort")
          return
        rescue Exception => e
          puts("#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}")
        end
        old_mtime = mtime
      end
    end
  end
  extend Wirble::Shortcuts
  puts "\tWirble loaded and colors initted"
end

#wirble
