defmodule SlashBible.Router do
  use Plug.Router
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  require Bible

  # Slack will periodically send get requests
  # to make sure the bot is still alive.
  get "/" do
    send_resp(conn, 200, "")
  end

  post "/" do
    %{"text" => text} = conn.params
    data = Bible.check_reference(text)
    response = Poison.encode!(%Bible{
      response_type: "in_channel",
      text: "#{text} - " <> data
    })
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
