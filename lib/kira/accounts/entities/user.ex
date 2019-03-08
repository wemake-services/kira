defmodule Kira.Accounts.Entities.User do
  @moduledoc """
  Represents `User` domain entity.

  This entity is actually a real person who works inside a `Project`.
  It is a representation of Gitlab's user. Not our own.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Kira.Projects.Entities.Project

  @fields ~w(uid username state expires_at access_level)a

  @derive {Jason.Encoder, only: @fields}
  schema "users" do
    field :uid, :integer
    field :username, :string

    field :state, :string
    field :expires_at, :utc_datetime
    field :access_level, :integer

    many_to_many :projects, Project,
      join_through: Kira.Accounts.Entities.UserProject

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required([:uid, :username, :state])
    |> unique_constraint(:uid)
    |> unique_constraint(:username)
  end
end
