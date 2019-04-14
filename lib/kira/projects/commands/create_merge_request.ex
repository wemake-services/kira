defmodule Kira.Projects.Commands.CreateMergeRequest do
  @moduledoc """
  Persistant command to create a new `MergeRequest`.
  """

  use Exop.Operation

  alias Kira.Accounts.Queries.UserQueries
  alias Kira.Projects.Entities.MergeRequest
  alias Kira.Projects.Queries.ProjectQueries
  alias Kira.Repo

  parameter(:project_uid, type: :integer)
  parameter(:author_uid, type: :integer)
  parameter(:assignee_uid, type: :integer, allow_nil: true)
  # TODO: enable pipeline creation
  # TODO: make sure that pipeline can come before and after MR
  # parameter(:pipeline_uid, type: :integer)
  parameter(:attrs, type: :map)

  def process(%{
        attrs: attrs,
        project_uid: project_uid,
        author_uid: author_uid,
        assignee_uid: assignee_uid
        # pipeline_uid: pipeline_uid
      }) do
    project = ProjectQueries.get_project!(project_uid)
    author = UserQueries.get_user!(author_uid)

    attrs =
      attrs
      |> Map.put("project_id", project.id)
      |> Map.put("author_id", author.id)
      |> Map.put("assignee_id", UserQueries.get_user_id_or_nil(assignee_uid))

    merge_request =
      %MergeRequest{}
      |> MergeRequest.changeset(attrs)
      # We need this line to "postload" the relationship for future usages
      |> Ecto.Changeset.put_assoc(:project, project)
      |> Repo.insert!()

    %{entity: merge_request}
  end
end
