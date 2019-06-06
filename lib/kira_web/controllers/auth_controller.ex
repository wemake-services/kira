defmodule KiraWeb.AuthController do
  use KiraWeb, :controller
  plug Ueberauth

  alias Kira.Accounts.Queries.UserQueries

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{email: auth.info.email, username: auth.info.nickname, provider: Atom.to_string(auth.provider),
                    state: "active", uid: auth.extra.raw_info.user["id"]}

    case UserQueries.find_or_create_by_email(user_params) do
      {:ok, user} ->
        respond_with_json(conn, %{user: user})
      {:error, %Ecto.Changeset{} = reason} ->
        respond_with_json(conn, %{errors: KiraWeb.ChangesetView.translate_errors(reason)})
    end
  end

  defp respond_with_json(conn, data) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Jason.encode!(data))
    |> halt
  end
end