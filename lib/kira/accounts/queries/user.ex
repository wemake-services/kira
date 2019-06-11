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
    user_changes =
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

    user_changes
    |> User.changeset(user_params)
    |> Repo.insert_or_update()
  end

  def for_project(query, project) do
    from u in query,
      join: p in assoc(u, :projects),
      where: p.id == ^project.id
  end

  def assigned_within_project(query, project) do
    from u in for_project(query, project),
      join: p in assoc(u, :projects),
      join: i in assoc(p, :issues),
      where: i.assignee_id == u.id,
      distinct: u.id
  end

  def not_assigned_within_project(query, project) do
    from u in for_project(query, project),
      except: ^assigned_within_project(query, project)
  end
end
