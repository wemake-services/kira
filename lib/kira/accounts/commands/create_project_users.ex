defmodule Kira.Accounts.Commands.CreateProjectUsers do
  @moduledoc """
  Saves `User`s inside a `Project` in the database.
  """

  use Exop.Operation
  import Ecto.Query
  alias Ecto.Changeset

  alias Kira.Accounts.Entities.User
  alias Kira.Common.TimeUtils
  alias Kira.Projects.Queries.ProjectQueries
  alias Kira.Repo

  parameter(:project_uid, type: :integer)
  parameter(:users, type: :list)

  def process(%{project_uid: project_uid, users: users}) do
    Repo.transaction(fn ->
      project_uid
      |> ProjectQueries.get_project!()
      |> Repo.preload(:participants)
      |> Changeset.change()
      |> Changeset.put_assoc(:participants, insert_and_get_all(users))
      |> Repo.update!()
    end)
  end

  defp insert_and_get_all(users) do
    uids = Enum.map(users, & &1["id"])

    # TODO: on conflict update extra fields when it will be required:
    # username, state, expires_at, access_level
    Repo.insert_all(User, valid_users(users),
      on_conflict: :nothing,
      conflict_target: [:uid]
    )

    Repo.all(from t in User, where: t.uid in ^uids)
  end

  defp valid_users(users) do
    users
    |> Enum.map(&Map.put_new(&1, "uid", &1["id"]))
    |> Enum.map(&User.changeset(%User{}, &1))
    |> Enum.reject(&(not &1.valid?))
    |> Enum.map(& &1.changes)
    |> Enum.map(&TimeUtils.enrich_with_timestamps/1)
  end
end
