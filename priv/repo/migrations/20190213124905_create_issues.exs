defmodule Kira.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :uid, :integer
      add :iid, :integer
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end

    create index(:issues, [:project_id])
    create unique_index(:issues, :uid)
    create unique_index(:issues, [:iid, :project_id], name: :project_issue)
  end
end
