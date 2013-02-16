require 'set'
require 'redis'
require 'flipper'

module Flipper
  module Adapters
    class Redis
      FeaturesKey = :flipper_features

      attr_reader :name

      def initialize(client)
        @client = client
        @name = :redis
      end

      # Public
      def get(feature)
        result = {}
        doc = @client.hgetall(feature.key)

        feature.gates.each do |gate|
          result[gate.key] = case gate.data_type
          when :boolean, :integer
            doc[gate.key.to_s]
          when :set
            regex = /^#{Regexp.escape(gate.key)}\//

            gate_keys = doc.keys.select { |key| key =~ regex }
            gate_values = gate_keys.map { |key| key.split('/', 2).last }
            gate_values.to_set
          else
            unsupported_data_type(gate.data_type)
          end
        end

        result
      end

      # Public
      def enable(feature, gate, thing)
        case gate.data_type
        when :boolean, :integer
          @client.hset feature.key, gate.key, thing.value.to_s
        when :set
          @client.hset feature.key, "#{gate.key}/#{thing.value}", 1
        else
          unsupported_data_type(gate.data_type)
        end

        true
      end

      # Public
      def disable(feature, gate, thing)
        case gate.data_type
        when :boolean
          @client.del(feature.key)
        when :integer
          @client.hset feature.key, gate.key, thing.value.to_s
        when :set
          @client.hdel feature.key, "#{gate.key}/#{thing.value}"
        else
          unsupported_data_type(gate.data_type)
        end

        true
      end

      # Public: Adds a feature to the set of known features.
      def add(feature)
        @client.sadd(FeaturesKey.to_s, feature.name.to_s)
        true
      end

      # Public: The set of known features.
      def features
        @client.smembers(FeaturesKey.to_s).to_set
      end

      # Private
      def unsupported_data_type(data_type)
        raise "#{data_type} is not supported by this adapter"
      end
    end
  end
end
