require "socket"

client = TCPSocket.new "irc.freenode.net", 6667

client.puts "user vb localhost irc.freenode.net :Playing with Ruby IRC"
client.puts "nick vb"


# Print incoming messages
Thread.start do
  loop do
    msg = client.gets
    puts "Received: #{msg}"
    if msg.include?("PING")
      response = "PONG #{msg.split(" ")[1]}"
      puts "Sending: #{response}"
      client.puts "#{response}"
    end
  end  
end

# UI: send messages
loop do
  msg = gets.chomp
  client.puts "#{msg}"
end


client.close
