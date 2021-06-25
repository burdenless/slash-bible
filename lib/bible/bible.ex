defmodule Bible do
  use HTTPotion.Base
  @derive [Poison.Encoder]
  defstruct [:response_type, :text, :attachments]

  def process_url(url) do
    "http://labs.bible.org/api" <> url <> "&formatting=plain"
  end

  def process_request_headers(headers) do
    Dict.put headers, :"User-Agent", "slash-bible"
  end

  def process_response_body(body) do
    IO.puts "Completed operation. Body: #{body}"
  end

  def check_reference(ref) do
    full_url = URI.encode(process_url("?passage=#{ref}"))
    response = HTTPotion.get(full_url, [ follow_redirects: true ])
    response.body
  end
end
