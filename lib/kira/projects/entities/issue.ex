defmodule Kira.Projects.Entities.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "issues" do
    field :uid, :integer
    field :iid, :integer
    # TODO: priority, assignee, due_date
    # TODO: participant model

    belongs_to :project, Kira.Projects.Entities.Project

    timestamps()
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:uid, :iid, :project_id])
    |> validate_required([:uid, :iid, :project_id])
    |> unique_constraint(:uid)
    |> unique_constraint(:project_issue, name: :project_issue)
  end
end
