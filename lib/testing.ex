defmodule Testing do
  use TelegramBotWrapper.Listener

  on "/help" do
    IO.puts "Print help options"
  end

  on "/something" do
    IO.puts "Something"
  end

  on "text" do
    IO.puts "Some text thing"
  end

  
end