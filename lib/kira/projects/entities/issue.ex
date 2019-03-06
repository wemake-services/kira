defmodule Kira.Projects.Entities.Issue do
  @moduledoc """
  Represents `Issue` domain entity from some `Project`.

  This entity is actually a bug/feature/etc ticket for Gitlab.
  It is later used to build a prioritized queue.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "issues" do
    field :uid, :integer
    field :iid, :integer

    # TODO: use state machine
    field :state, :string

    field :weight, :integer, default: 0
    field :due_date, :date, default: nil
    # TODO: assignee and participant model

    belongs_to :project, Kira.Projects.Entities.Project

    timestamps()
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:uid, :iid, :state, :weight, :due_date, :project_id])
    |> validate_required([:uid, :iid, :state, :project_id])
    |> unique_constraint(:uid)
    |> unique_constraint(:project_issue, name: :project_issue)
  end
end
