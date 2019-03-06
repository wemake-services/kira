defmodule KiraTest.Factory do
  @moduledoc """
  Factory to create different entities during tests.
  """

  use ExMachina.Ecto, repo: Kira.Repo

  alias Kira.Projects.Entities.{Issue, Project}

  def project_factory do
    project_name = Faker.Name.first_name()

    %Project{
      name: sequence(:name, &"#{project_name}#{&1}"),
      path: "organization/#{project_name}",
      uid: sequence(:uid, &(&1 + 1)),
      url: Faker.Internet.url() <> "/#{project_name}"
    }
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
end
