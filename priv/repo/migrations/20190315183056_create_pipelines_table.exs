defmodule Kira.Repo.Migrations.CreatePipelinesTable do
  use Ecto.Migration

  def change do
    create table(:pipelines) do
      add :uid, :integer

      add :ref, :string
      add :tag, :boolean
      add :sha, :string
      add :origin_timestamp, :utc_datetime
      add :finish_timestamp, :utc_datetime
      add :status, :string
      add :detailed_status, :string
      add :source_branch, :string

      add :project_id, references(:projects, on_delete: :delete_all),
        null: false

      add :author_id, references(:users, on_delete: :nilify_all), null: true
    end

    create index(:pipelines, [:project_id])
    create index(:pipelines, [:author_id])
    create unique_index(:pipelines, :uid)
  end
end
