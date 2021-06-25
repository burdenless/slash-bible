defmodule SlashBible do
  use Application
    def start(_type, _args) do
      port = Integer.parse(Application.get_env(:slash_bible, SlashBible, 4000)[:cowboy_port])
      children = [
        Plug.Adapters.Cowboy.child_spec(
        :http, SlashBible.Router, [],
        [port: elem(port, 0)])
      ]
      opts = [strategy: :one_for_one, name: SlashBible.Supervisor]
      Supervisor.start_link(children, opts)
    end
end
