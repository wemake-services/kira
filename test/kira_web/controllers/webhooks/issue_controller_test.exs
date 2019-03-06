defmodule KiraWebTest.Webhooks.IssueControllerTest do
  use KiraWeb.ConnCase

  import Tesla.Mock
  import KiraTest.Factory
  alias Kira.Projects.Queries.IssueQueries

  @invalid_attrs %{"uid" => nil}

  setup do
    # Just disable all HTTP calls:
    mock_global(fn _ -> %Tesla.Env{status: 200} end)

    {:ok, project: insert(:project)}
  end

  describe "webhook issue controller" do
    test "invalid data is handled", %{conn: conn} do
      conn = post(
        conn,
        Routes.issue_path(conn, :create),
        @invalid_attrs
      )

      assert response(conn, 400)
    end

    test "valid issue data is handled", %{project: project, conn: conn} do
      issue_params = string_params_for(:issue)
      issue =
        issue_params
        |> Map.put("id", issue_params["uid"])
        |> Map.put("action", "open")

      conn = post(
        conn,
        Routes.issue_path(conn, :create),
        %{
          "object_kind" => "issue",
          "project" => %{"id" => project.uid},
          "object_attributes" => issue
        }
      )

      assert response(conn, 200)
      assert IssueQueries.get_issue!(issue["uid"])
    end
  end

  describe "webhook issue note controller" do
    setup %{project: project} do
      {:ok, issue: insert(:issue, project: project)}
    end

    test "valid issue note data is handled", %{issue: issue, conn: conn} do
      conn = post(
        conn,
        Routes.issue_path(conn, :create),
        %{
          "object_kind" => "note",
          "project_id" => issue.project.uid,
          "object_attributes" => %{
            "noteable_type" => "Issue",
            "id" => 123,
            "note" => "@kira-bot queue",
            "noteable_id" => issue.uid
          }
        }
      )

      assert response(conn, 200)
      assert IssueQueries.get_issue!(issue.uid).state == "queued"
    end
  end
end
