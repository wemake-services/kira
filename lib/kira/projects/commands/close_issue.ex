defmodule Kira.Projects.Commands.CloseIssue do
  @moduledoc """
  Persistant command to close an existing `Issue`.
  """

  use Exop.Operation

  alias Kira.Projects.Queries.IssueQueries
  alias Kira.Repo

  parameter(:attrs, type: :map)

  def process(%{attrs: attrs}) do
    {:ok, issue} =
      Repo.transaction(fn ->
        attrs["uid"]
        |> IssueQueries.get_issue!()
        |> Ecto.Changeset.change(%{state: attrs["state"]})
        |> Repo.update!()
      end)

    %{entity: issue}
  end
end
