defmodule Kira.Accounts.Entities.UserProject do
  @moduledoc """
  Represents a link between `Project` and `User` entities.
  """

  use Ecto.Schema

  @primary_key false
  schema "users_projects" do
    belongs_to :user, Kira.Accounts.Entities.User
    belongs_to :project, Kira.Projects.Entities.Project

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:user_id, :project_id])
    |> Ecto.Changeset.validate_required([:user_id, :project_id])
  end
end
