module Lita
  module Alias
    # Repository of aliases.
    # Stores the aliases in a hash in redis keyed by the alias name
    class AliasStore
      STORE_KEY = 'aliases'
      attr_reader :redis

      def initialize(redis)
        @redis = redis
      end

      # Delete the alias with *name*
      def delete(name)
        fail AliasNotFoundException, "No alias with name #{name} exists" unless @redis.hexists(STORE_KEY, name)

        command = @redis.hget(STORE_KEY, name)
        @redis.hdel(STORE_KEY, name)
        AliasedCommand.new(name, command).freeze
      end

      # Store the alias.
      # @raises ArgumentError if the alias is not valid
      # @return AliasedCommand The saved alias
      def add(aliased_command)
        fail AliasAddException, 'The alias is not valid' unless aliased_command.valid?

        @redis.hset(STORE_KEY, aliased_command.name, aliased_command.command)
      end

      # Return a list of all aliases
      # @return Array<AliasedCommand>
      def list
        @redis.hgetall(STORE_KEY).sort.map do |name, command|
          AliasedCommand.new(name, command)
        end
      end

      def lookup(name)
        command = @redis.hget(STORE_KEY, name)
        AliasedCommand.new(name, command)
      end

      def exists?(name)
        @redis.hexists(STORE_KEY, name)
      end

      # Exceptions
      class AliasNotFoundException < StandardError; end
      class AliasAddException < StandardError; end
    end
  end
end
