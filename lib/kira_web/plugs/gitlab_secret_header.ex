defmodule KiraWeb.Plugs.GitlabSecretHeader do
  @moduledoc """
  Peforms Gitlab authentication for webhooks.

  It is a rather simple thing: it just compares a secret value from
  the Gitlab settings with the one we have in this project.
  """

  use Plug.Builder

  @secret_header "X-Gitlab-Token"
  @secret_header_value Application.get_env(:kira, :gitlab)[
                         :secret_header_value
                       ]

  plug :validate_secret_header_value

  def validate_secret_header_value(conn, _opts) do
    if received_secret_value(conn) != @secret_header_value do
      conn
      |> halt()
      |> send_resp(403, "")
    else
      conn
    end
  end

  defp received_secret_value(conn) do
    conn
    |> get_req_header(String.downcase(@secret_header))
    |> List.first()
  end
end
