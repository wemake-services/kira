defmodule Kira.Projects.Commands.QueueIssue do
  @moduledoc """
  Persistant command to change status of an `Issue` to "queued".
  """

  use Exop.Operation

  alias Kira.Projects.Queries.IssueQueries
  alias Kira.Repo

  parameter(:issue_uid, type: :integer)

  def process(%{issue_uid: issue_uid} = params) do
    {:ok, issue} =
      Repo.transaction(fn ->
        issue_uid
        |> IssueQueries.get_issue!()
        |> Repo.preload(:project)
        |> Ecto.Changeset.change(%{state: "queued"})
        |> Repo.update!()
      end)

    Map.put(params, :entity, issue)
  end
end
