defmodule Kira.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :uid, :integer
      add :iid, :integer
      add :state, :string
      add :weight, :integer
      add :due_date, :date

      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :author_id, references(:users, on_delete: :nilify_all), null: true
      add :assignee_id, references(:users, on_delete: :nilify_all), null: true

      timestamps()
    end

    create index(:issues, [:project_id])
    create index(:issues, [:author_id])
    create index(:issues, [:assignee_id])
    create unique_index(:issues, :uid)
    create unique_index(:issues, [:iid, :project_id], name: :project_issue)
  end
end
