defmodule Kira.Repo.Migrations.AddOauthFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :provider, :string
    end

    create unique_index(:users, :email)
  end
end