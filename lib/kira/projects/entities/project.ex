defmodule Kira.Projects.Entities.Project do
  @moduledoc """
  Represents `Project` domain entity.

  Project is a collaboration unit for developing software.
  It is also a representation of git repository.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :path, :string
    field :uid, :integer
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:uid, :name, :url, :path])
    |> validate_required([:uid, :name, :url, :path])
    |> unique_constraint(:uid)
  end
end
