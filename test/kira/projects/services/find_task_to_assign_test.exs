defmodule KiraTest.Projects.Services.FindTaskToAssignTest do
  use Kira.DataCase

  import KiraTest.Factory
  alias Kira.Projects.Services.FindTaskToAssign

  # TODO:
  # Find an issue with:
  #   1. status: opened
  #   2. assignee: nil
  describe "find task to assign service" do
    test "with no task to be assigned" do
      # TODO
    end

    test "with only one task to be assigned" do
      # TODO
    end

    test "with multiple tasks to be assigned" do
      # test "without prioritization" do
        # TODO
      # end

      # test "with prioritization" do
        # TODO
      # end
    end
  end
end
