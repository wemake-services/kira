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
      add :assignee_id, references(:users, on_delete: :nilify_all), null: true

      timestamps()
    end

    create index(:issues, [:project_id])
    create unique_index(:issues, :uid)
    create unique_index(:issues, [:iid, :project_id], name: :project_issue)

    # This needs an extra comment:
    # All assignees can have just one task at a time.
    # That's why it is a unique index.
    # It is impossible to have a person to work on two tasks.
    create unique_index(:issues, :assignee_id)
  end
end
