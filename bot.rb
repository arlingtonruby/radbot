#! /usr/bin/env ruby

require "bundler/setup"
require 'uri'
require 'cinch'
#require "cinch/plugins/cleverbot"
#require 'mongo'
require 'open-uri'
require 'json'
require './plugins/cleverbot'

# Set the Env
IRC_ENV = ENV["IRC_ENV"] || "development"

$bot = Cinch::Bot.new do
  configure do |c|
    c.server = ENV['IRC_SERVER']
    c.realname = 'RadBot'
    c.password = ENV['IRC_PASS']

    if IRC_ENV == "development"
      c.channels = ['#radbot_dev']
      c.user = 'radbot_dev'
      c.nick = 'radbot_dev'
    else
      c.channels = [ENV['IRC_CHAN']]
      c.user = ENV['IRC_USER'] || 'radbot'
      c.nick = ENV['IRC_NICK'] || c.user
    end

    c.plugins.plugins = [Cinch::Plugins::CleverBot]
  end

  on :connect do
    if ENV['IRC_NICK_PASS']
      User("nickserv").send("identify #{ENV['IRC_NICK_PASS']}")
    end
  end

  on :message, /radbot say:(.*)/i do |m,message|
    $bot.channels.each do |c|
      c.send(message)
    end
  end

  on :message, /radbot say (.*):(.*)/i do |m,channel,message|
    $bot.channels.each do |c|
      if c == channel
        c.send(message)
        ret = "Said #{message} on #{c}"
      end
    end
  end

  #
  # Lol Plugin
  #
  on :message, /\blol\b|\blolz\b/i do |m|
    images = [
      "http://i.imgur.com/PgP44.png",
      "http://i.imgur.com/n1xml.png"
    ]
    m.reply images.sample
  end

  #
  # Stock Plugin
  #
  on :message, /stock (.*)/i do |m,ticker|
    if ticker
      time ||= '1d'
      m.reply "http://chart.finance.yahoo.com/z?s=#{ticker}&t=1d&q=l&l=on&z=l&a=v&p=s&lang=en-US&region=US#.png"
    else
      m.reply 'Huh?'
    end
  end

  #
  # Haters Plugin
  #
  on :message, /hater(z|s)?/i do |m|
    images = [
      "http://i.imgur.com/XaZRf.gif",
      "http://i.imgur.com/imPCK.gif",
      "http://i.imgur.com/kaIiQ.jpg",
      #"http://i.imgur.com/oxLDK.gif",
      #"http://i.imgur.com/WN8Ud.gif",
      "http://i.imgur.com/B0ehW.gif",
      "http://i.imgur.com/6oPAO.gif",
      "http://i.imgur.com/0X1AK.png",
      "http://i.imgur.com/FPIUh.png",
      "http://i.imgur.com/296IJ.gif",
      "http://i.imgur.com/Kpx68.jpg"
    ]
    m.reply images.sample
  end

  #
  # Coffee Plugin
  #
  on :message, /coffee/ do |m|
    message = [
      [:reply, "Hey guys, I like coffee!"],
      [:reply, "Yay!"],
      [:reply, "Coffee!"],
      [:reply, "Coffee? I hope you don't mean Coffeescript! It is a nice option, but don't make it the default."],
      [:reply, "http://www.toothpastefordinner.com/071112/coffee-fun-fact.gif"],
      [:reply, "http://image.spreadshirt.com/image-server/v1/designs/12025843,width=190,height=190/Instant-human-just-add-coffee---funny-t-shirt.png"],
      [:reply, "http://www.shape.com/sites/shape.com/files/imagecache/node_page_image/blog_images/coffeedayb.jpg"],
      [:reply, "http://www.toothpastefordinner.com/021302/playing-music-on-coffee.gif"],
      [:reply, "http://coffeemoment.info/wp-content/uploads/2013/01/drinkable_coffee.gif"],
      [:reply, "http://coffee.groovybrew.com/wp-content/uploads/2012/02/coffee-solves-everything.jpg"],
      [:reply, "http://katiemcdermott.files.wordpress.com/2011/11/another-coffee-funny.jpg"],
      [:reply, "http://www.sanitaryum.com/wp-content/uploads/2010/07/retro-coffee-funny1.jpg"],
      [:reply, "http://www.punjabigraphics.com/images/17/coffee.gif"],
      [:reply, "http://www.theteewarehouse.com/wp-content/uploads/2013/01/coffee-detail_56947_cached_thumb_-928107ac47da4bc345a3edd84ac43cf3.jpg"],
      [:reply, "http://assets.diylol.com/hfs/699/83d/6a4/resized/business-cat-meme-generator-code-in-java-be-an-enterprise-hipster-a39e0b.jpg"],
      [:reply, "http://www.instructables.com/files/deriv/FCY/SG9V/GW88ORG6/FCYSG9VGW88ORG6.LARGE.jpg"],
      [:reply, "http://www.java-forums.org/attachments/entertainment/4074d1346683563t-java-jokes-thread-comic.jpg"],
      [:reply, "http://jaxenter.com/assets/duke-mug.jpg"],
      [:reply, "http://www.doolwind.com/images/blog/comic/comic-06.jpg"],
      [:reply, "http://jokideo.com/wp-content/uploads/2012/07/527423_310179082389474_1431720477_n.jpg"],
      [:reply, "http://slurmed.com/fanart/tastes-like-fry/007_fry-coffee-coffee-coffee_tastes-like-fry.jpg"],
      [:reply, "http://memecreator.eu/media/created/5md02j.jpg"],
      [:reply, "http://i.qkme.me/3q49xz.jpg"],
      [:action, "smiles"],
      [:action, "is happy"],
      [:action, "dances a *really* fast jig"],
    ]
    msg = message.sample
    if msg.first == :action
      m.channel.action msg.last
    else
      m.reply msg.last
    end
  end

  #
  # Cheer me up Plugin
  #
  on :message, /cheer (.*?) up/i do |m, n|
    images = JSON(open("http://imgur.com/r/aww.json").read)['data']
    image = images[rand(images.length)]
    m.reply "http://i.imgur.com/#{image['hash']}#{image['ext']}"
    unless n == "me" || n == "you"
      m.reply "I hope that makes #{n} feel better"
    end
  end

  #
  # Cray-cray
  #
  on :message, /(crazy|cray)/i do |m|
    m.reply "http://i.imgur.com/hycIuKc.jpg"
  end

  #
  # Logical
  #
  on :message, /\blogical\b/i, do |m|
    message = [
      "http://logicalawesome.com/logical_awesome.jpg",
      "http://i727.photobucket.com/albums/ww271/Bonoa/spock-logic.jpg",
      "http://trinities.org/blog/wp-content/uploads/logic-spock.jpg",
      "http://vulcanstev.files.wordpress.com/2010/05/trek-spock-planning.jpg",
      "http://fc04.deviantart.net/fs70/f/2012/018/3/d/spock_approves_by_kit_kat1982-d4mr6u1.jpg",
      "http://cdn.memegenerator.net/instances/400x/31238697.jpg",
      "http://i653.photobucket.com/albums/uu257/markus69_bucket/Spock.jpg",
    ]
    m.reply message.sample
  end

  #
  # Illogical
  #
  on :message, /illogical/i do |m|
    message = [
      "http://www.katzy.dsl.pipex.com/Smileys/illogical.gif",
      "http://icanhascheezburger.files.wordpress.com/2010/08/e95f76c6-469b-486e-9d18-b2c600ff7ab6.jpg",
      "http://fc01.deviantart.net/fs46/i/2009/191/d/6/Spock_Finds_You_Illogical_by_densethemoose.jpg",
      "http://cache.io9.com/assets/images/8/2008/11/medium_vulcan-cat-is-logical.jpg",
      "http://roflrazzi.files.wordpress.com/2011/01/funny-celebrity-pictures-karaoke.jpg",
      "http://i13.photobucket.com/albums/a292/macota/MCCOYGOBLET.jpg",
      "http://spike.mtvnimages.com/images/import/blog//1/8/7/5/1875583/200905/1242167094687.jpg",
      "http://randomoverload.com/wp-content/uploads/2010/12/fc5558bae4issors.jpg.jpg",
      "http://25.media.tumblr.com/vVmbDWseNqfu8w069WO5RISVo1_500.jpg",
    ]
    m.reply message.sample
  end

  #
  # Gravity Falls Plugin
  #
  on :message, /puke/i do |m|
    m.reply "http://i.imgur.com/G0Z36.gif"
  end
  on :message, /attack/i do |m|
    m.reply "http://i.imgur.com/xXsO4.gif"
  end
  on :message, /legal/i do |m|
    m.reply "http://i.imgur.com/Kmulu.gif"
  end

  on :message, /snuggle/i do |m|
    m.reply "http://i.imgur.com/TaWjH.gif"
  end
  on :message, /whee/i do |m|
    message = [
      "http://i.imgur.com/ZwzU3.gif",
      "http://i.imgur.com/QAJlS.gif",
      "http://i.imgur.com/zTIPM.gif",
      "http://i.imgur.com/Ovato.gif",
      "shh, please"
    ]
    m.reply message.sample
  end


  #
  # I hate plugin
  #
  on :message, /i hate/i do |m|
    m.reply "http://i.imgur.com/ZrN7c.jpg"
  end

  #
  # I sad plugin
  #
  on :message, /makes me sad/i do |m|
    m.reply "http://i.imgur.com/XEC69.gif"
  end

  #
  # Is up plugin
  #
  on :message, /is (.*?) (up|down)(\?)?/i do |m, domain|
    body = open("http://www.isup.me/"+domain).read
    if body.include? "It's just you"
      m.reply "#{domain} looks UP from here."
    elsif body.include? "It's not just you!"
      m.reply "#{domain} looks DOWN from here."
    else
      m.reply  "Not sure, #{domain} returned an error."
    end
  end

  #
  # SQUIRREL
  #
  on :message do |m|
    # Randomlly say squirrel
    if rand(500) == 0
      m.reply "SQUIRREL!"
    end
  end

  on :message, /squirrel/i do |m|
    m.reply "SQUIRREL!"
  end

  #
  # zen
  #
  on :message, /zen/i do |m|
    body = open("https://api.github.com/zen").read
    m.reply body
  end

  #
  # http status codes
  #
  on :message, /http.(\d\d\d)\b/i do |m, code_str|
    code = Integer code_str
    resp = case code
           when 100
             "Continue"
           when 101
             "Switching Protocols"
           when 102
             "Processing"
           when 200
             "OK"
           when 201
             "Created"
           when 202
             "Accepted"
           when 203
             "Non-Authoritative Information"
           when 204
             "No Content (Won't return a response body)"
           when 205
             "Reset Content (Won't return a response body)"
           when 206
             "Partial Content"
           when 207
             "Multi..Status"
           when 208
             "Already Reported"
           when 226
             "IM Used"
           when 300
             "Multiple Choices"
           when 301
             "Moved Permanently (Will also return this extra header: Location: http://radbot.com)"
           when 302
             "Found (Will also return this extra header: Location: http://radbot.com)"
           when 303
             "See Other (Will also return this extra header: Location: http://radbot.com)"
           when 304
             "Not Modified (Will also return this extra header: Location: http://radbot.com)"
           when 305
             "Use Proxy (Will also return this extra header: Location: http://radbot.com)"
           when 306
             "Reserved"
           when 307
             "Temporary Redirect (Will also return this extra header: Location: http://radbot.com)"
           when 308
             "Permanent Redirect (Will also return this extra header: Location: http://radbot.com)"
           when 400
             "Bad Request"
           when 401
             "Unauthorized (Will also return this extra header: WWW-Authenticate: Basic realm=\"Fake Realm\""
           when 402
             "Payment Required"
           when 403
             "Forbidden"
           when 404
             "Not Found"
           when 405
             "Method Not Allowed"
           when 406
             "Not Acceptable"
           when 407
             "Proxy Authentication Required (Will also return this extra header: Proxy-Authenticate: Basic realm=\"Fake Realm\")"
           when 408
             "Request Timeout"
           when 409
             "Conflict"
           when 410
             "Gone"
           when 411
             "Length Required"
           when 412
             "Precondition Failed"
           when 413
             "Request Entity Too Large"
           when 414
             "Request-URI Too Long"
           when 415
             "Unsupported Media Type"
           when 416
             "Requested Range Not Satisfiable"
           when 417
             "Expectation Failed"
           when 418
             "I'm a teapot"
           when 420
             "Enhance Your Calm"
           when 422
             "Unprocessable Entity"
           when 423
             "Locked"
           when 424
             "Failed Dependency"
           when 425
             "Reserved for WebDAV advanced collections expired proposal"
           when 426
             "Upgrade Required"
           when 428
             "Precondition Required"
           when 429
             "Too Many Requests"
           when 431
             "Request Header Fields Too Large"
           when 500
             "Internal Server Error"
           when 501
             "Not Implemented"
           when 502
             "Bad Gateway"
           when 503
             "Service Unavailable"
           when 504
             "Gateway Timeout"
           when 505
             "HTTP Version Not Supported"
           when 506
             "Variant Also Negotiates (Experimental)"
           when 507
             "Insufficient Storage"
           when 508
             "Loop Detected"
           when 510
             "Not Extended"
           when 511
             "Network Authentication Required"
           else
             "Unassigned"
           end
    m.reply "HTTP #{code}: #{resp}" if resp
  end
end

$bot.start
