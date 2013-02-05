require 'set'
require 'redis'

module Flipper
  module Adapters
    class Redis
      def initialize(client)
        @client = client
      end

      def read(key)
        @client.get key.to_s
      end

      def write(key, value)
        @client.set key.to_s, value.to_s
      end

      def delete(key)
        @client.del key.to_s
      end

      def set_add(key, value)
        @client.sadd(key.to_s, value.to_s)
      end

      def set_delete(key, value)
        @client.srem(key.to_s, value.to_s)
      end

      def set_members(key)
        @client.smembers(key.to_s).to_set
      end
    end
  end
end
