defmodule Kira.Projects.Commands.CloseMergeRequest do
  @moduledoc """
  Persistant command to close an existing `MergeRequest`.
  """

  use Exop.Operation

  alias Kira.Projects.Queries.MergeRequestQueries
  alias Kira.Repo

  parameter(:attrs, type: :map)

  def process(%{attrs: attrs}) do
    {:ok, merge_request} =
      Repo.transaction(fn ->
        attrs["uid"]
        |> MergeRequestQueries.get_merge_request!()
        |> Ecto.Changeset.change(%{state: attrs["state"]})
        |> Repo.update!()
      end)

    %{entity: merge_request}
  end
end
