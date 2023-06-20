module Commands
  extend Discordrb::Commands::CommandContainer

  command(:region, chain_usable: true, description: "Gets the region the server is stationed in.") do |event|
        event.server.region
  end

  command(:userid, description: "Gets user's ID.") do |event, name|
    event.bot.parse_mention(name.to_s).id
  end

  command(:username, description: "Gets user's username from ID.", chain_usable: true) do |event, id|
    id = id.to_i
    name = event.bot.user(id).name
    event.respond "#{name}"
  end

  command(:mention, description: "Mentions a user") do |event, id|
      id = id.to_i
      event.respond "<@#{id}>"
  end

  command(:mention_val, description: "Mentions a user on loop") do |event, id, amount|
        id = id.to_i
        for i in 0 .. amount.to_i - 1 do
        	event.respond "<@#{id}>"
        	sleep 1
        end
  end

  command(:ping, description: "Pings the bot.") do |event|
         #ping = event.respond 'Pong!'
         #ping.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
         #event.respond "Pong! Time taken: #{Time.now - event.timestamp} seconds."
         m = event.respond('Pong!')
         m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
  end

  command(:random, description: "Gives you a random number: min max") do |event, min, max|
  		if min.to_i == max.to_i then
  			event.respond 'Cannot give a random number if min and max are the same dumbass'
  		else
        	rand(min.to_i .. max.to_i)
        end
  end

  command(:spoiler, description: "Annoy your friends!", chain_usable: true) do |event, *text|
    spoiler = text.join(' ').chomp.scan(/.{1,1}/).join("||||").insert(0, "||").insert(-1, "||")
    event.respond "#{spoiler}"
  end

#  command(:cute, description: "hehe") do |event|
#         event.respond 'Gothalia ist cute! :3'
#  end

  command(:eval, help_available: false) do |event, *arg|
  		break unless event.user.id == 285454085631508484
  		begin
    		eval arg.join(' ')
  		rescue StandardError
    		'An error occurred..'
  		end
  end

  command(:shutdown, help_available: false) do |event|
    		break unless event.user.id == 285454085631508484
    		event.respond 'Shutting down..'
    		exit
  end

  command(:test_img, description: "test") do |event|
  	event.send_file(File.open('/home/star/test.png', 'r'))
  end

#  command(:test_math, description: "test") do |event, *arg|
#    arg = arg.join(' ')
#  	options = { :zoom => 5.0, :base64 => true }
#  	renderer = Mathematical.new(options)
#  	img = renderer.render(arg)
#	img = img.to_s.scan(/"([^"]*)"/)
#	img = img[0]
#	img = img[0].to_s.split(',')
#	outimg = Magick::Image.from_blob(Base64.decode64(img[1])) { |image|
#		image.format = 'SVG'
#		image.background_color = 'white'
#	}
#	outimg[0].write "/home/star/test.png"
#	event.send_file(File.open('/home/star/test.png', 'r'))
	
  #	def getBase64(str)
  #	   str = str.to_s.scan(/"([^"]*)"/)
  #	   str = str[0]
  #	   str = str[0].to_s.split(',')
  #	   return str[1]
  #	end
  
  #	outimg = Magick::Image.from_blob(Base64.decode64(getBase64(img))) {
  #	   self.format = 'SVG'
  #	   self.background_color = 'transparent'
  #	}
  #	event.send_file(File.open(outimg[0], 'r'))
#  end
  
end
