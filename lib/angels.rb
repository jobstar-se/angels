module Angels

  def run_loop(name, opts = {}, &block)
    opts = {
      :loop_sleep   => 60,
      :retry        => true,
      :retry_sleep  => 60,
      :rails_root   => File.expand_path(File.join(File.dirname(__FILE__), '..')),
      :load_rails   => false,
      :pid_dir      => File.join(File.dirname(__FILE__), '..', 'tmp'),
      :default_env  => 'production'
    }.merge(opts)

    environment_file = File.expand_path(File.dirname(__FILE__) + "/../config/environment.rb")

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
          HoptoadNotifier.notify(e) if defined? HoptoadNotifier
          raise e unless opts[:retry]
          sleep opts[:retry_sleep]
        end
      }
    end
  end

end
