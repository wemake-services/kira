defmodule Kira.Accounts.Queries.UserQueries do
  @moduledoc """
  Reading queries that do not modify state of `User`s.
  """

  import Ecto.Query, warn: false
  alias Kira.Repo

  alias Kira.Accounts.Entities.User

  def get_user!(uid) do
    User
    |> Repo.get_by!(uid: uid)
  end

  def get_user_id_or_nil(nil), do: nil

  def get_user_id_or_nil(uid) do
    get_user!(uid).id
  end

  def find_or_create_by_email(user_params) do
    case Repo.get_by(User, email: user_params.email) do
      nil ->
        %User{
          email: user_params.email,
          username: user_params.username,
          provider: user_params.provider,
          state: user_params.state,
          uid: user_params.uid
        }

      user ->
        user
    end
    |> User.changeset(user_params)
    |> Repo.insert_or_update()
  end
end
