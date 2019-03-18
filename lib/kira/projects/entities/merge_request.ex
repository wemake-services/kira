defmodule Kira.Projects.Entities.MergeRequest do
  @moduledoc """
  Represents `MergeRequest` domain entity from some `Project`.

  This entity is actually a code change request for Gitlab.
  It is later used to build a prioritized queue.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Kira.Accounts.Entities.User
  alias Kira.Projects.Entities.Project

  @fields ~w(
    uid
    iid
    merge_status
    origin_timestamp
    state
    source_branch
    work_in_progress
    project_id
    author_id
    assignee_id
  )a

  @derive {Jason.Encoder, only: @fields}
  schema "merge_requests" do
    field :uid, :integer
    field :iid, :integer

    field :merge_status, :string
    field :origin_timestamp, :utc_datetime
    field :state, :string
    field :source_branch, :string
    field :work_in_progress, :boolean

    # TODO: add pipeline status
    belongs_to :project, Project
    belongs_to :author, User
    belongs_to :assignee, User

    timestamps()
  end

  @doc false
  def changeset(merge_request, attrs) do
    merge_request
    |> cast(attrs, @fields)
    |> validate_required([
      :uid,
      :iid,
      :merge_status,
      :origin_timestamp,
      :state,
      :source_branch,
      :work_in_progress,
      :project_id,
      :author_id
    ])
    |> unique_constraint(:uid)
    |> unique_constraint(:project_merge_request, name: :project_merge_request)
  end
end
