require "socket"

client = TCPSocket.new "irc.freenode.net", 6667

client.puts "user vb localhost irc.freenode.net :Playing with Ruby IRC"
client.puts "nick vb"

# Flag to control the main loop
running = true

# Handle Ctrl+C (SIGINT)
Signal.trap("INT") do
  puts "\nInterrupted externally. Shutting down gracefully..."
  running = false
  exit
end

# Print incoming messages
Thread.start do
  begin
    loop do
      msg = client.gets
      break if msg.nil? # Connection closed
      puts "Received: #{msg}"
      if msg.include?("ERROR") 
        puts "Exiting application"
        running = false
        client.close
        exit
      end
      if msg.include?("PING")
        response = "PONG #{msg.split(" ")[1]}"
        puts "Sending: #{response}"
        client.puts "#{response}"
      end
    end
  rescue IOError => e
    puts "Connection closed" if running # Only show message if we didn't initiate the close
  end
end

# UI: send messages
while running
  msg = gets.chomp
  if msg.downcase == "exit"
    running = false
    client.close
    break
  end
  begin
    client.puts "#{msg}"
  rescue IOError => e
    puts "Connection closed"
    break
  end
end
