defmodule KiraWeb.AuthController do
  use KiraWeb, :controller
  plug Ueberauth

  alias Kira.Accounts.Queries.UserQueries

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      email: auth.info.email,
      username: auth.info.nickname,
      provider: Atom.to_string(auth.provider),
      state: "active",
      uid: auth.uid
    }

    case UserQueries.find_or_create_by_email(user_params) do
      {:ok, user} ->
        respond_with_json(conn, %{user: user})

      {:error, %Ecto.Changeset{} = reason} ->
        respond_with_json(conn, %{
          errors: KiraWeb.ChangesetView.translate_errors(reason)
        })
    end
  end

  defp respond_with_json(conn, data) do
    conn
    |> json(data)
  end
end
