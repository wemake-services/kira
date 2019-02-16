defmodule Kira.Projects.Commands.CreateIssue do
  use Exop.Operation

  alias Kira.Repo
  alias Kira.Projects.Entities.{Project, Issue}
  alias Kira.Projects.Queries.ProjectQueries

  parameter(:project_uid, type: :integer)
  parameter(:attrs, type: :map)

  def process(%{attrs: attrs, project_uid: project_uid}) do
    project = ProjectQueries.get_project!(project_uid)
    attrs = Map.put(attrs, "project_id", project.id)

    issue =
      %Issue{}
      |> Issue.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:project, project)
      |> Repo.insert!()

    %{entity: issue}
  end
end
