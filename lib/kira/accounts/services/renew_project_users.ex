defmodule Kira.Accounts.Services.RenewProjectUsers do
  @moduledoc """
  Fetches all new `User`s in each existing `Project`.
  """

  use Exop.Operation

  alias Kira.Accounts.Commands.CreateProjectUsers
  alias Kira.Accounts.Services.Providers.GitlabUsers
  alias Kira.Projects.Queries.ProjectQueries

  def process(_params) do
    # TODO: this way of streaming does not scale, use `GenStage` instead.
    ProjectQueries.active_projects()
    |> Task.async_stream(&project_payload/1)
    |> Enum.map(fn {:ok, payload} -> CreateProjectUsers.run(payload) end)
    |> Enum.map(fn
      {:ok, project} -> project
      _ -> :error
    end)
  end

  defp project_payload(project) do
    users = GitlabUsers.in_project(project)
    [project_uid: project.uid, users: users.body]
  end
end
