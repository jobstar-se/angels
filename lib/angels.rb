require 'rubygems'
require 'daemons'

module Angels

  def Angels.run_loop(name, opts = {}, &block)
    caller_dir = File.expand_path(File.dirname(caller[0].scan(/^([^:]*):/).first.first))
    opts = {
      :loop_sleep   => 60,
      :retry        => true,
      :retry_sleep  => 60,
      :rails_root   => File.join(caller_dir, '..'), 
      :load_rails   => false,
      :pid_dir      => File.join(caller_dir, '..', 'tmp'),
      :default_env  => 'production',
    }.merge(opts)

    Daemons.run_proc(name, :dir_mode => :normal, :dir => opts[:pid_dir]) do 
      if opts[:load_rails]
        ENV['RAILS_ENV'] ||= opts[:default_env]
        require File.join(opts[:rails_root], 'config', 'environment')
      end

      loop {
        begin
          yield
          sleep opts[:loop_sleep]
        rescue SignalException, Interrupt; SystemExit; Process.exit
        rescue => e
          handler = opts[:exception_handler]
          if handler
            if handler.is_a? Symbol
              case handler
              when :hoptoad; HoptoadNotifier.notify(e)
              else raise handler.inspect 
              end
            else
              handler.call(e)
            end
          end
          raise e unless opts[:retry]
          sleep opts[:retry_sleep]
        end
      }
    end
  end

end
