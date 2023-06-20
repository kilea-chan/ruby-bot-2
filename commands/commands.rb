# frozen_string_literal: true

# Generic module holding misc commands
module Commands
  extend Discordrb::Commands::CommandContainer

  command(:region, chain_usable: true, description: 'Gets the region the server is stationed in.') do |event|
    event.server.region
  end

  command(:userid, description: "Gets user's ID.") do |event, name|
    event.bot.parse_mention(name.to_s).id
  end

  command(:username, description: "Gets user's username from ID.", chain_usable: true) do |event, id|
    id = id.to_i
    name = event.bot.user(id).name
    event.respond name.to_s
  end

  command(:mention, description: 'Mentions a user') do |event, id|
    id = id.to_i
    event.respond "<@#{id}>"
  end

  command(:mention_val, description: 'Mentions a user on loop') do |event, id, amount|
    id = id.to_i
    (0..amount.to_i - 1).each do
      event.respond "<@#{id}>"
      sleep 1
    end
  end

  command(:ping, description: 'Pings the bot.') do |event|
    # ping = event.respond 'Pong!'
    # ping.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
    # event.respond "Pong! Time taken: #{Time.now - event.timestamp} seconds."
    m = event.respond('Pong!')
    m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
  end

  command(:random, description: 'Gives you a random number: min max') do |event, min, max|
    if min.to_i == max.to_i
      event.respond 'Cannot give a random number if min and max are the same dumbass'
    else
      rand(min.to_i..max.to_i)
    end
  end

  command(:spoiler, description: 'Annoy your friends!', chain_usable: true) do |event, *text|
    spoiler = text.join(' ').chomp.scan(/.{1,1}/).join('||||').insert(0, '||').insert(-1, '||')
    event.respond spoiler.to_s
  end

  # command(:eval, help_available: false) do |event, *arg|
  #  break unless event.user.id == 285_454_085_631_508_484
  #  begin
  #    SAFE = 4
  #    eval arg.join(' ')
  #  rescue StandardError
  #    'An error occurred..'
  #  end
  # end

  command(:shutdown, help_available: false) do |event|
    break unless event.user.id == 285_454_085_631_508_484

    event.respond 'Shutting down..'
    exit
  end

  command(:test_img, description: 'test') do |event|
    event.send_file(File.open('/home/star/test.png', 'r'))
  end
end
