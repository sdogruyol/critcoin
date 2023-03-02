require "kemal"
require "./block"

module Critcoin
  blockchain = [] of NamedTuple(
    index: Int32,
    timestamp: String,
    data: String,
    hash: String,
    previous_hash: String,
    difficulty: Int32,
    nonce: String)

  blockchain << Block.create(0, Time.local.to_s, "Genesis block", "")

  get "/" do
    blockchain.to_json
  end

  post "/new-block" do |env|
    pp env.params.json
    data = env.params.json["data"].as(String)

    new_block = Block.generate(blockchain[blockchain.size - 1], data)

    if Block.is_valid?(new_block, blockchain[blockchain.size - 1])
      blockchain << new_block
      puts "\n"
      p new_block
      puts "\n"
    end

    new_block.to_json
  end

  Kemal.run
end
