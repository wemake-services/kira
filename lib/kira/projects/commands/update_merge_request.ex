defmodule Kira.Projects.Commands.UpdateMergeRequest do
  @moduledoc """
  Persistant command to update an existing `MergeRequest`.
  """

  use Exop.Operation

  alias Kira.Accounts.Queries.UserQueries
  alias Kira.Projects.Entities.MergeRequest
  alias Kira.Projects.Queries.MergeRequestQueries
  alias Kira.Repo

  parameter(:assignee_uid, type: :integer, allow_nil: true)
  parameter(:attrs, type: :map)

  def process(%{assignee_uid: assignee_uid, attrs: attrs}) do
    valid_attrs =
      attrs
      |> Map.put("assignee_id", UserQueries.get_user_id_or_nil(assignee_uid))
      |> atomize_keys()

    {:ok, merge_request} =
      Repo.transaction(fn ->
        attrs["uid"]
        |> MergeRequestQueries.get_merge_request!()
        |> MergeRequest.changeset(valid_attrs)
        |> Repo.update!()
      end)

    %{entity: merge_request}
  end

  # TODO: the same we do in tests, we need generic way to do that
  defp atomize_keys(dict) do
    Map.new(dict, fn {k, v} -> {String.to_existing_atom(k), v} end)
  end
end
