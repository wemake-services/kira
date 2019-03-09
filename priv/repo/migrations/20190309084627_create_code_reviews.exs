defmodule Kira.Repo.Migrations.CreateCodeReviews do
  use Ecto.Migration

  def change do
    create table(:code_reviews) do
      add :uid, :integer
      add :iid, :integer

      add :state, :string
      add :merge_status, :string
      add :origin_date, :utc_datetime

      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :author_id, references(:users, on_delete: :nilify_all), null: true
      add :assignee_id, references(:users, on_delete: :nilify_all), null: true

      timestamps()
    end

    create index(:code_reviews, [:project_id])
    create index(:code_reviews, [:author_id])

    create unique_index(
             :code_reviews,
             [:iid, :project_id],
             name: :project_code_review
           )

    # This needs an extra comment:
    # All assignees can have just one task at a time.
    # That's why it is an unique index.
    # It is impossible to have a person
    # who works on two tasks at the same moment.
    create unique_index(:code_reviews, :assignee_id)
  end
end
