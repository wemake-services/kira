defmodule KiraTest.Projects.Commands.CreateIssueTest do
  use Kira.DataCase

  import KiraTest.Factory
  alias Kira.Projects.Commands.CreateIssue

  describe "create issue command" do
    setup do
      {:ok, project: insert(:project)}
    end

    @invalid_attrs %{"missing" => "key"}
    @valid_attrs %{"uid" => 1, "iid" => 1, "state" => "opened"}
    @valid_full_attrs %{
      "uid" => 1,
      "iid" => 1,
      "state" => "opened",
      "due_date" => "2019-02-17",
      "weight" => 1
    }

    test "creates issue for valid attrs", %{project: project} do
      {:ok, context} =
        CreateIssue.run(attrs: @valid_attrs, project_uid: project.uid)

      assert context.entity.id > 0
    end

    test "creates issue for full valid attrs", %{project: project} do
      {:ok, context} =
        CreateIssue.run(attrs: @valid_full_attrs, project_uid: project.uid)

      assert context.entity.id > 0
    end

    test "does not create issue for invalid attrs", %{project: project} do
      assert_raise Ecto.InvalidChangesetError, fn ->
        CreateIssue.run(attrs: @invalid_attrs, project_uid: project.uid)
      end
    end
  end
end
