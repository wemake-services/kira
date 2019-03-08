defmodule Kira.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :integer
      add :username, :string
      add :state, :string
      add :expires_at, :utc_datetime
      add :access_level, :integer

      timestamps()
    end

    create unique_index(:users, :uid)
    create unique_index(:users, :username)
  end
end
