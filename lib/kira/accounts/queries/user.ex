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
end
