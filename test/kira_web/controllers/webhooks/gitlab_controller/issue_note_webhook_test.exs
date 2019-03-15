defmodule KiraWebTest.Webhooks.GitlabController.IssueNoteTest do
  use KiraWeb.ConnCase

  import Tesla.Mock
  import KiraTest.Factory
  alias Kira.Projects.Queries.IssueQueries

  setup %{conn: conn} do
    # Just disable all HTTP calls:
    mock_global(fn _ -> %Tesla.Env{status: 200} end)

    token = Application.get_env(:kira, :gitlab)[:secret_header_value]
    conn = put_req_header(conn, "x-gitlab-token", token)

    {:ok, project: insert(:project), author: insert(:user), conn: conn}
  end

  describe "issue note webhook" do
    setup %{project: project} do
      {:ok, issue: insert(:issue, project: project)}
    end

    test "valid issue note data is handled", %{issue: issue, conn: conn} do
      conn =
        post(
          conn,
          Routes.gitlab_path(conn, :create),
          %{
            "object_kind" => "note",
            "project_id" => issue.project.uid,
            "object_attributes" => %{
              "noteable_type" => "Issue",
              "id" => issue.iid,
              "note" => "@kira-bot queue",
              "noteable_id" => issue.uid
            }
          }
        )

      assert response(conn, 200)
      assert IssueQueries.get_issue!(issue.uid).state == "queued"
    end

    test "no command note data is handled", %{issue: issue, conn: conn} do
      conn =
        post(
          conn,
          Routes.gitlab_path(conn, :create),
          %{
            "object_kind" => "note",
            "project_id" => issue.project.uid,
            "object_attributes" => %{
              "noteable_type" => "Issue",
              "id" => issue.iid,
              "note" => "Just some comment, other person is @mentioned",
              "noteable_id" => issue.uid
            }
          }
        )

      assert response(conn, 200)
      assert IssueQueries.get_issue!(issue.uid).state == "opened"
    end
  end
end
