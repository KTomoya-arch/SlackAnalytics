require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    channel_array = Array.new # 各チャンネルデータを格納する配列
    reactions_array = Array.new # スタンプデータを格納する配列
    message_count = 0
    # チャンネルごとに処理
    @channel_names.each_with_index do |element,index|
      # 取り出したチャンネルをロード
      jsonelement = load(element) 
      # 対象チャンネルのmessages部分を切り抜き
      jsonmessage = jsonelement["messages"]
      jsonmessage.each do |temp|
         temp["reactions"]    
         reactions_array = channel_array.push(temp["reactions"])
      end
    end
    # nilと空白を除去しいいねを押した人"users"のデータを取り出し
    last_array = Array.new
    reactions_array.compact.each do |tmp|
      tmp.each do |dvdtmp|
      last_array.push(dvdtmp["users"])
      end 
    end
    # 配列をフラットな配列へ
    tmp_array = Array.new
    channel_array = Array.new
    result_array = Array.new
    tmp_array = last_array.flatten
    # 重複したデータをグループ化
    group_array = tmp_array.group_by(&:itself)
    # keyとvalueを取り出しvalueをカウントし配列に格納
    group_array.each do | key, value |
    channel_hash = Hash.new
    valuearray = Array.new
    valuearray = value 
      channel_hash.store(":channel_name",key)
      channel_hash.store(":reaction_count",valuearray.count)
    channel_array.push(channel_hash)
  end 
    result_array = channel_array.sort do |a,b|
    b[":reaction_count"] <=> a[":reaction_count"] 
   end
   puts result_array[0..2]
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end