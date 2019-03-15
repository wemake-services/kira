defmodule Kira.Repo.Migrations.CreateMergeRequests do
  use Ecto.Migration

  def change do
    create table(:merge_requests) do
      add :uid, :integer
      add :iid, :integer

      add :state, :string
      add :merge_status, :string
      add :origin_timestamp, :utc_datetime

      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :author_id, references(:users, on_delete: :nilify_all), null: true
      add :assignee_id, references(:users, on_delete: :nilify_all), null: true

      timestamps()
    end

    create index(:merge_requests, [:project_id])
    create index(:merge_requests, [:author_id])
    create index(:merge_requests, [:assignee_id])
    create unique_index(:merge_requests, :uid)

    create unique_index(
             :merge_requests,
             [:iid, :project_id],
             name: :project_merge_request
           )
  end
end
