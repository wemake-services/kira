defmodule KiraTest.Factory do
  @moduledoc """
  Factory to create different entities during tests.
  """

  use ExMachina.Ecto, repo: Kira.Repo

  alias Kira.Accounts.Entities.User
  alias Kira.Projects.Entities.{Issue, MergeRequest, Project}

  def project_factory do
    project_name = Faker.Name.first_name()

    %Project{
      name: sequence(:name, &"#{project_name}#{&1}"),
      path: "organization/#{project_name}",
      uid: sequence(:uid, &(&1 + 1)),
      url:
        Application.get_env(:kira, :gitlab)[:domain] <>
          "/organization/#{project_name}"
    }
  end

  def project_with_users(project) do
    users = build_list(2, :user)
    %{project | participants: users}
  end

  def issue_factory(attrs) do
    state = Map.get(attrs, :state, "opened")
    project = Map.get(attrs, :project, insert(:project))
    author = Map.get(attrs, :author, insert(:user))
    assignee = Map.get(attrs, :assignee, nil)
    weight = Map.get(attrs, :weight, 0)

    %Issue{
      uid: sequence(:uid, &(&1 + 100)),
      iid: sequence(:iid, &(&1 + 1)),
      state: state,
      due_date: Faker.Date.forward(100) |> Date.to_iso8601(),
      project: project,
      author: author,
      assignee: assignee,
      weight: weight
    }
  end

  def merge_request_factory(attrs) do
    state = Map.get(attrs, :state, "opened")
    assignee = Map.get(attrs, :assignee, nil)
    work_in_progress = Map.get(attrs, :work_in_progress, true)

    %MergeRequest{
      uid: sequence(:uid, &(&1 + 100)),
      iid: sequence(:iid, &(&1 + 1)),
      merge_status: "unchecked",
      origin_timestamp: Faker.DateTime.backward(1) |> DateTime.to_iso8601(),
      state: state,
      source_branch: sequence(:source_branch, &"issue-#{&1}"),
      work_in_progress: work_in_progress,
      project: insert(:project),
      author: insert(:user),
      assignee: assignee
    }
  end

  def user_factory do
    %User{
      uid: sequence(:uid, &(&1 + 1)),
      username: sequence(:username, &"#{Faker.Internet.user_name()}_#{&1}"),
      state: "active",
      expires_at: Faker.DateTime.forward(100) |> DateTime.to_iso8601(),
      access_level: 30
    }
  end
end
