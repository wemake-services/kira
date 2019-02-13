defmodule KiraWeb.PageController do
  use KiraWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
