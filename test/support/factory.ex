defmodule KiraTest.Factory do
  @moduledoc """
  Factory to create different entities during tests.
  """

  use ExMachina.Ecto, repo: Kira.Repo

  alias Kira.Accounts.Entities.User
  alias Kira.Projects.Entities.{Issue, Project}

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

    %Issue{
      uid: sequence(:uid, &(&1 + 100)),
      iid: sequence(:iid, &(&1 + 1)),
      state: state,
      project: insert(:project),
      due_date: "2029-01-10"
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
