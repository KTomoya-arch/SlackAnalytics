class PopularMessageAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    # dummy
    channel_array = Array.new   # 各チャンネルデータを格納する配列
    reactions_array = Array.new # スタンプデータを格納する配列
    result_array = Array.new    # 最終結果を格納する配列
    # チャンネルごとに処理
    @channel_names.each_with_index do |element,index|
      # 取り出したチャンネルをロード
      jsonelement = load(element) 
      # 対象チャンネルのmessages部分を切り抜し
      jsonmessage = jsonelement["messages"].compact
      # reactionsがないデータは除外
      jsonmessage.each do |temp|
        tmparray = Array.new
        channel_hash = Hash.new
         if temp["reactions"] != nil
            temp["reactions"].each do |k|
             tmparray.push(k["count"])
            end   
            # textに対応するスタンプの数を集計しハッシュに格納 
            channel_hash.store(":text",temp["text"])
            channel_hash.store(":reaction_count",tmparray.sum)
            # ハッシュを配列へ格納   
            result_array.push(channel_hash)    
         end
      end
    end
    # 結果を出力
    puts result_array.max{|a, b| a[":reaction_count"] <=> b[":reaction_count"]}
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end