defmodule Kira.Projects.Entities.Project do
  @moduledoc """
  Represents `Project` domain entity.

  Project is a collaboration unit for developing software.
  It is also a representation of git repository.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Kira.Accounts.Entities.{User, UserProject}

  @fields ~w(
    uid
    name
    url
    path
  )a

  @derive {Jason.Encoder, only: @fields}
  schema "projects" do
    field :name, :string
    field :path, :string
    field :uid, :integer
    field :url, :string

    # TODO: add active flag to disable project for a while

    many_to_many :participants, User,
      join_through: UserProject,
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, @fields)
    |> validate_required([:uid, :name, :url, :path])
    |> unique_constraint(:uid)
  end
end
