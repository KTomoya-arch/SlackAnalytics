require 'json'

class HighMotivationUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    channel_array = Array.new
    message_count = 0
    # チャンネルごとに処理
    @channel_names.each_with_index do |element,index|
      # 取り出したチャンネルをロード
      jsonelement = load(element) 
      # 対象チャンネルのmessages部分を切り抜き
      temp = jsonelement["messages"]
      channel_hash = Hash.new
      # typeがmessageのものを抽出しカウントを加算
      temp.each do |tempdiv|
        if tempdiv["type"] == "message" 
            message_count += 1
        end
     end
     channel_hash.store(":channl_name",element) 
     channel_hash.store(":message_count",message_count) 
     channel_array.push(channel_hash)
     message_count = 0
    end
    # カウント数の多い順にソートする
      result_array = channel_array.sort do |a,b|
      b[":message_count"] <=> a[":message_count"]
     end
     puts result_array[0..2]
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end