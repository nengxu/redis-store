module Rack
  module Session
    class Redis < Abstract::ID
      attr_reader :mutex, :pool
      DEFAULT_OPTIONS = Abstract::ID::DEFAULT_OPTIONS.merge :redis_server => "redis://127.0.0.1:6379/0"

      def initialize(app, options = {})
        super
        @mutex = Mutex.new
        @pool = ::Redis::Factory.create options[:redis_server] || @default_options[:redis_server]
      end

      def generate_sid
        loop do
          sid = super
          break sid unless @pool.get(sid)
        end
      end

      def get_session(env, sid)
        session = @pool.get(sid) if sid
        @mutex.lock if env['rack.multithread']
        unless sid and session
          env['rack.errors'].puts("Session '#{sid.inspect}' not found, initializing...") if $VERBOSE and not sid.nil?
          session = {}
          sid = generate_sid
          ret = @pool.set sid, session
          raise "Session collision on '#{sid.inspect}'" unless ret
        end
        return [sid, session]
      rescue Errno::ECONNREFUSED
        warn "#{self} is unable to find server."
        warn $!.inspect
        return [ nil, {} ]
      ensure
        @mutex.unlock if env['rack.multithread']
      end

      def set_session(env, session_id, new_session, options)
        @mutex.lock if env['rack.multithread']
        if options[:renew] or options[:drop]
          @pool.del session_id
          return false if options[:drop]
          session_id = generate_sid
        end
        @pool.set session_id, new_session, options
        return session_id
      rescue Errno::ECONNREFUSED
        warn "#{self} is unable to find server."
        warn $!.inspect
        return false
      ensure
        @mutex.unlock if env['rack.multithread']
      end

      def destroy_session(env, session_id, options)
        options = { :renew => true }.update(options) unless options[:drop]
        set_session(env, session_id, 0, options)
      end

    end
  end
end

