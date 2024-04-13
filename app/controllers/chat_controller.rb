class ChatController < ApplicationController

  def new()
    
    @chat = Chat.new
  end

  def index()
    @chats = Chat.all
    accessCrete()
    indexMsg("")
  end

  def indexMsg(comment)
    @times = "現在は#{DateTime.now.strftime("%Y年 %m月 %d日 %H:%M:%S")}です "
    @ip_addres = request.remote_ip;
    @userAccess = UserAccess.where(ip_address: request.remote_ip)
    
    @allCount = UserAccess.all.count;
    
    weekEndFlg = (Date.today.wday == 0 || Date.today.wday == 6)
    if comment == "" then
        hour = DateTime.now.hour;
        msgNow = "今日も一日頑張りましょう"
        if hour >= 22 then
            msgNow = "もう眠くないですか？夜遅くまでお疲れ様です"
        elsif hour >= 20 then
            msgNow = "夜はいつも何をして過ごしますか？"
        elsif hour >= 17 then
            if weekEndFlg
              msgNow = "そろそろご飯の時間ですね"
            else
              msgNow = "こんばんは。お仕事お疲れ様です"
            end
        elsif  hour >= 14 then
          msgNow = "眠くなりますがファイトです"
        elsif  hour >= 12 then
          msgNow = "こんにちは。お昼は何を食べましたか？"
        elsif  hour >= 11 then
          msgNow = "お昼何食べようかそわそわ"
        elsif  hour >= 9 then
          if weekEndFlg
            msgNow = "休日は何して過ごしますか？"
          else
            msgNow = "お仕事集中してやっていますか？"
          end
        elsif hour >= 6 then
          if weekEndFlg
              msgNow = "おはようございます。休日ゆっくり過ごしてください"
            else
              msgNow = "おはようございます。今日もお仕事頑張ってください"
            end
        elsif hour >= 5 then
          msgNow = "おはようございます。朝早いですね"
        elsif hour >= 0 then
          msgNow = "寝れないんですか？私が癒してあげましょうか？"
        end
        @msg = "#{msgNow}"
    else 
        if comment.index("今日")
            @msg = DateTime.now.strftime("今日は、%Y年%m月%d日です")
        elsif comment.index("昨日")
            @msg = DateTime.now.ago(1.days).strftime("昨日は、%Y年%m月%d日です")
        elsif comment.index("明日")
            @msg = DateTime.now.since(1.days).strftime("明日は、%Y年%m月%d日です")
        elsif comment.index("時間") || comment.index("何時")
            @msg = DateTime.now.since(1.days).strftime("今は、%H時%M分%S秒です")
        else
            random = Random.new().rand(2)
            if random == 0 then
                @msg = "そうなんですね"
            else
                @msg = "なるほど"
            end
        end
    end
  end

  def regist
    @chats = Chat.new(chat_params)
    @chats.save
    indexMsg(params['Chat'][:comment])
    render 'index'
  end
  
  def accessCrete()
    @userAccess = UserAccess.where(ip_address: request.remote_ip)
    $userAccessFlg = @userAccess.count == 0
    if $userAccessFlg
      @userAccess = UserAccess.new
      @userAccess.ip_address = request.remote_ip
      @userAccess.access_date = Date.today
      @userAccess.access_count = 1
      @userAccess.save
    else
      UserAccess.update(@userAccess.first.id, :access_count => @userAccess.find(5).access_count + 1)
      # @userAccess.access_count = 2
    end

    if $userAccessFlg
      
    else
      
    end

  end


  private
    def chat_params
      params.require('Chat').permit(:comment,:ip_addres)
    end
    
    def user_acess_paprams
      params.require('UserAccess').permit(:ip_address, :access_date, :access_count)
    end
 
end
