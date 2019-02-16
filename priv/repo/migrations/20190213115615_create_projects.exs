defmodule Kira.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :uid, :integer
      add :name, :string
      add :url, :string
      add :path, :string

      timestamps()
    end

    create unique_index(:projects, :uid)
  end
end
