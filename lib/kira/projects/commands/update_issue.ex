defmodule Kira.Projects.Commands.UpdateIssue do
  @moduledoc """
  Persistant command to update an existing `Issue`.
  """

  use Exop.Operation

  alias Kira.Accounts.Queries.UserQueries
  alias Kira.Common.MapUtils
  alias Kira.Projects.Entities.Issue
  alias Kira.Projects.Queries.IssueQueries
  alias Kira.Repo

  parameter(:assignee_uid, type: :integer, allow_nil: true)
  parameter(:attrs, type: :map)

  def process(%{assignee_uid: assignee_uid, attrs: attrs}) do
    valid_attrs =
      attrs
      |> Map.put("assignee_id", UserQueries.get_user_id_or_nil(assignee_uid))
      # State should not to be updated from "queued"
      |> Map.delete("state")
      |> MapUtils.atomize_keys()

    {:ok, issue} =
      Repo.transaction(fn ->
        attrs["uid"]
        |> IssueQueries.get_issue!()
        |> Issue.changeset(valid_attrs)
        |> Repo.update!()
      end)

    %{entity: issue}
  end
end
