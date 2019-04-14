defmodule Kira.Projects.Entities.Pipeline do
  @moduledoc """
  Represents `Pipeline` domain entity from some `Project`.

  This entity is actually a set of CI step.
  We use it to mark `MergeRequest` as passed or failed.
  And the we work with them based on either they are failed or passed.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Kira.Accounts.Entities.User
  alias Kira.Projects.Entities.Project

  @fields ~w(
    uid
    ref
    tag
    sha
    origin_timestamp
    finishe_timestamp
    status
    detailed_status
    source_branch
    project_id
    author_id
  )a

  @derive {Jason.Encoder, only: @fields}
  schema "pipelines" do
    field :uid, :integer

    field :ref, :string
    field :tag, :boolean
    field :sha, :string
    field :origin_timestamp, :utc_datetime
    field :finish_timestamp, :utc_datetime
    field :status, :string
    field :detailed_status, :string
    field :source_branch, :string

    belongs_to :project, Project
    belongs_to :author, User

    timestamps()
  end

  @doc false
  def changeset(merge_request, attrs) do
    merge_request
    |> cast(attrs, @fields)
    |> validate_required([
      :uid,
      :ref,
      :tag,
      :sha,
      :origin_timestamp,
      :status,
      :detailed_status,
      :source_branch,
      :project_id,
      :author_id
    ])
    |> unique_constraint(:uid)
  end
end
