defmodule Kira.ProjectsTest do
  use Kira.DataCase

  # TODO: refactor
  alias Kira.Projects

  describe "issues" do
    alias Kira.Projects.Entities.Issue

    @valid_attrs %{uid: 42}
    @invalid_attrs %{uid: nil}

    test "create_issue/1 with valid data creates a issue" do
      assert {:ok, %Issue{} = issue} = Projects.create_issue(@valid_attrs)
      assert issue.uid == 42
    end

    test "create_issue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_issue(@invalid_attrs)
    end
  end
end
