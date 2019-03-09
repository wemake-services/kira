defmodule Kira.Projects.CodeReview do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kira.Accounts.Entities.{User, Project}

  @fields ~w(
    uid iid state merge_status origin_date
    project_id author_id assignee_id
  )a

  @derive {Jason.Encoder, only: @fields}
  schema "code_reviews" do
    field :uid, :integer
    field :iid, :integer

    field :merge_status, :string
    field :origin_date, :utc_datetime
    field :state, :string

    # TODO: add pipeline status
    belongs_to :project, Project
    belongs_to :author, User
    belongs_to :assignee, User

    timestamps()
  end

  @doc false
  def changeset(code_review, attrs) do
    code_review
    |> cast(attrs, @fields)
    |> validate_required([
      :uid,
      :iid,
      :state,
      :merge_status,
      :origin_date,
      :project_id,
      :author_id
    ])
    |> unique_constraint(:uid)
    |> unique_constraint(:project_code_review, name: :project_code_review)
    |> unique_constraint(:assignee_id)
  end
end
