defmodule SlashBibleTest do
  use ExUnit.Case
  use Plug.Test
  alias SlashBible.Router
  @opts Router.init([])

  test "returns 200" do
    conn = conn(:get, "/", "")
           |> Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns 404" do
    conn = conn(:get, "/missing", "")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "returns the right verse" do
    conn = conn(:post, "/?text=John+11:35", "")
           |> Router.call(@opts)
    assert conn.state == :sent
    decoded = Poison.decode(conn.resp_body, as: %Bible{})
    resp = elem(decoded, 1)
    assert resp.text == "John 11:35 - 11:35 Jesus wept. "
  end
end
