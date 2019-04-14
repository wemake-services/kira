defmodule KiraWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use KiraWeb, :controller

  @doc """
  We send this response for all cleint related errors.
  """
  def call(conn, :error) do
    send_resp(conn, 400, "")
  end

  @doc """
  A special fallback for idempotent actions.

  We raise a special kind of warnings inside our app
  which should be treated as: it is already in the correct state, no worries.
  """
  def call(conn, {:interrupt, :idempotence}) do
    # TODO: our API is not fully tested for idempotence requests
    send_resp(conn, 200, "idempotence")
  end
end
