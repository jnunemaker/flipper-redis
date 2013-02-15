require 'set'
require 'redis'

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

        feature.gates.each do |gate|
          result[gate] = case gate.data_type
          when :boolean, :integer
            read key(feature, gate)
          when :set
            set_members key(feature, gate)
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
          write key(feature, gate), thing.value.to_s
        when :set
          set_add key(feature, gate), thing.value.to_s
        else
          unsupported_data_type(gate.data_type)
        end

        true
      end

      # Public
      def disable(feature, gate, thing)
        case gate.data_type
        when :boolean
          feature.gates.each do |gate|
            delete key(feature, gate)
          end
        when :integer
          write key(feature, gate), thing.value.to_s
        when :set
          set_delete key(feature, gate), thing.value.to_s
        else
          unsupported_data_type(gate.data_type)
        end

        true
      end

      # Public: Adds a feature to the set of known features.
      def add(feature)
        set_add(FeaturesKey, feature.name.to_s)
        true
      end

      # Public: The set of known features.
      def features
        set_members(FeaturesKey)
      end

      # Private
      def key(feature, gate)
        "#{feature.key}/#{gate.key}"
      end

      # Private
      def unsupported_data_type(data_type)
        raise "#{data_type} is not supported by this adapter"
      end

      # Private
      def read(key)
        @client.get key.to_s
      end

      # Private
      def write(key, value)
        @client.set key.to_s, value.to_s
      end

      # Private
      def delete(key)
        @client.del key.to_s
      end

      # Private
      def set_add(key, value)
        @client.sadd(key.to_s, value.to_s)
      end

      # Private
      def set_delete(key, value)
        @client.srem(key.to_s, value.to_s)
      end

      # Private
      def set_members(key)
        @client.smembers(key.to_s).to_set
      end
    end
  end
end
