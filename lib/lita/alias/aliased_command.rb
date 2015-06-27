module Lita
  module Alias
    # A single aliased command
    class AliasedCommand
      attr_accessor :name, :command

      def initialize(name = nil, command = nil)
        @name = name
        @command = command
      end

      # Returns true if the object is valid.  False otherwise
      # @return Boolean
      def valid?
        # for now, just validate the name and command are not nil
        @name && @command
      end
    end
  end
end
