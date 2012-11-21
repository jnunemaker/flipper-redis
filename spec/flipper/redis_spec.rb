require 'helper'
require 'flipper/adapters/redis'
require 'flipper/spec/shared_adapter_specs'

describe Flipper::Adapters::Redis do
  let(:client) { Redis.new }

  subject { Flipper::Adapters::Redis.new(client) }

  before do
    client.flushdb
  end

  def read_key(key)
    client.get key.to_s
  rescue RuntimeError => e
    if e.message =~ /wrong kind of value/
      client.smembers(key.to_s).to_set
    else
      raise
    end
  end

  def write_key(key, value)
    case value
    when Array, Set
      value.each do |member|
        client.sadd key.to_s, member
      end
    else
      client.set key.to_s, value
    end
  end

  it_should_behave_like 'a flipper adapter'
end
