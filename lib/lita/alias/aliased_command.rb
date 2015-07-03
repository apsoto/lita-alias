module Lita
  module Alias
    # A single aliased command
    class AliasedCommand
      attr_accessor :name, :command, :global_flag

      def initialize(name = nil, command = nil, global_flag = nil)
        @name = name
        @command = command
        @global_flag = global_flag
      end

      # Returns true if the object is valid.  False otherwise
      # @return Boolean
      # @todo this currently returns a String or Nil, not a Boolean.
      def valid?
        # for now, just validate the name and command are not nil
        @name && @command
      end

      # Returns true if the command is a global command. False otherwise
      # @return Boolean
      def global?
        !@global_flag.nil?
      end
    end
  end
end
