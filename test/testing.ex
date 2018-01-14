defmodule Testing do
  use Telebrew

  on "/test" do
    send_message m.chat.id, "System is up"
  end

  on "document" do
    result = download_file(m.document.file_id, "/home/evan/Documents")
    send_message m.chat.id, result
  end

  on "default" do
    IO.inspect m
  end
end
