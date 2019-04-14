defmodule Kira.Projects.Commands.CreateIssue do
  @moduledoc """
  Persistant command to create a new `Issue`.
  """

  use Exop.Operation

  alias Kira.Accounts.Queries.UserQueries
  alias Kira.Projects.Entities.Issue
  alias Kira.Projects.Queries.ProjectQueries
  alias Kira.Repo

  parameter(:project_uid, type: :integer)
  parameter(:author_uid, type: :integer)
  parameter(:assignee_uid, type: :integer, allow_nil: true)
  parameter(:attrs, type: :map)

  def process(%{
        attrs: attrs,
        project_uid: project_uid,
        author_uid: author_uid,
        assignee_uid: assignee_uid
      }) do
    project = ProjectQueries.get_project!(project_uid)
    author = UserQueries.get_user!(author_uid)

    attrs =
      attrs
      |> Map.put("project_id", project.id)
      |> Map.put("author_id", author.id)
      |> Map.put("assignee_id", UserQueries.get_user_id_or_nil(assignee_uid))

    issue =
      %Issue{}
      |> Issue.changeset(attrs)
      # We need this line to "postload" the relationship for future usages:
      |> Ecto.Changeset.put_assoc(:project, project)
      |> Repo.insert!()

    %{entity: issue}
  end
end
