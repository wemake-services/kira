defmodule KiraWebTest.Webhooks.GitlabController.IssueWebhookTest do
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

  describe "issue webhook" do
    test "valid issue data is handled", %{
      project: project,
      author: author,
      conn: conn
    } do
      issue_params = string_params_for(:issue, author: author)

      issue =
        issue_params
        |> Map.put("id", issue_params["uid"])
        |> Map.put("author_id", author.uid)
        |> Map.put("assignee_id", nil)
        |> Map.put("action", "open")

      conn =
        post(
          conn,
          Routes.gitlab_path(conn, :create),
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
end
