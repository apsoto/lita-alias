require_relative './aliased_command'
require_relative './alias_store'

# main Lita module
module Lita
  # namespace for plugin handlers
  module Alias
    # Chat handler for lita-alias
    class ChatHandler < Handler
      #########
      # Events
      on :loaded, :load_aliases

      #########
      # Routes
      route(/alias\s+add\s+(\w+)\s+(.+)/,
            :add,
            command: true,
            help: { 'alias add NAME COMMAND' => 'Alias for sending COMMAND when NAME typed' }
           )
      route(/alias\s+list/,
            :list,
            command: true,
            help: { 'alias list' => 'List all the saved aliases' }
           )
      route(/alias\s+delete\s+(\w+)/,
            :delete,
            command: true,
            help: { 'alias delete NAME' => 'Delete the alias with NAME' }
           )

      ##########################
      # Event Handlers
      def load_aliases(_payload)
        log.debug('Loading aliases')
        alias_store.list.each do |ac|
          add_alias_route(ac)
        end
      end

      ##########################
      # Route Handlers

      def add(response)
        name = response.match_data[1]
        command = response.match_data[2]

        # TODO: support multiple commands
        ac = AliasedCommand.new(name, command)
        add_alias_route(ac)
        alias_store.add(ac)

        response.reply "Added alias '#{name}' for '#{command}'"
      rescue AliasStore::AliasAddException => e
        response.reply(e.message)
      end

      def trigger_alias(response)
        ac = alias_store.lookup(response.match_data[1])
        body = "#{robot.mention_name} #{ac.command} #{response.args.join(' ')}".rstrip
        message = Lita::Message.new(robot, body, response.message.source)
        robot.receive(message)
      end

      def list(response)
        aliases = alias_store.list

        if aliases.empty?
          message = 'No aliases have been saved'
        else
          message = aliases.map do |ac|
            "#{ac.name} => #{ac.command}"
          end
        end

        response.reply message
      end

      def delete(response)
        name = response.match_data[1]
        ac = alias_store.delete(name)
        delete_alias_route(ac)
        response.reply("Deleted alias '#{ac.name}' => '#{ac.command}'")
      rescue AliasStore::AliasNotFoundException
        response.reply("Alias '#{name}' does not exist")
      end

      # The repository where aliases are persisted
      # @return AliasStore
      def alias_store
        @alias_store ||= AliasStore.new(redis)
      end

      private

      def add_alias_route(aliased_command)
        return if alias_route_exists?(aliased_command)

        alias_name = aliased_command.name
        self.class.route(/^(#{alias_name})(\s|\z)/, :trigger_alias, command: true, alias_name: alias_name)
        log.debug("Added route for alias '#{aliased_command.name}'")
      end

      def delete_alias_route(aliased_command)
        self.class.routes.delete_if { |route| route.extensions[:alias_name] == aliased_command.name }
      end

      def alias_route_exists?(aliased_command)
        self.class.routes.any? { |route| route.extensions[:alias_name] == aliased_command.name }
      end
    end

    Lita.register_handler(ChatHandler)
  end
end
