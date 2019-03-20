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

  describe "create issue webhook" do
    test "valid issue data is handled", %{
      project: project,
      author: author,
      conn: conn
    } do
      issue_params = string_params_for(:issue, author: author)

      issue_payload =
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
            "object_attributes" => issue_payload
          }
        )

      assert response(conn, 200)
      assert IssueQueries.get_issue!(issue_payload["uid"]).state == "opened"
    end
  end

  describe "update issue webhook" do
    setup %{project: project, author: author} do
      {:ok, issue: insert(:issue, project: project, author: author)}
    end

    test "valid issue data is handled", %{
      issue: issue,
      conn: conn
    } do
      issue_payload =
        issue
        |> Map.from_struct()
        |> Map.delete(:__meta__)
        |> to_string_map()
        |> Map.put("id", issue.uid)
        |> Map.put("author_id", issue.author.uid)
        |> Map.put("assignee_id", nil)
        |> Map.put("action", "update")
        # Updated args:
        # TODO: test reassign
        |> Map.put("weight", 4)
        |> Map.put("due_date", "2019-06-01")

      conn =
        post(
          conn,
          Routes.gitlab_path(conn, :create),
          %{
            "object_kind" => "issue",
            "project" => %{"id" => issue.project.uid},
            "object_attributes" => issue_payload
          }
        )

      assert response(conn, 200)

      instance = IssueQueries.get_issue!(issue.uid)
      assert instance.state == "opened"
      assert instance.weight == 4
      assert instance.due_date == ~D[2019-06-01]
    end
  end

  describe "close issue webhook" do
    setup %{project: project, author: author} do
      {:ok, issue: insert(:issue, project: project, author: author)}
    end

    test "valid issue data is handled", %{
      issue: issue,
      conn: conn
    } do
      issue_payload =
        issue  # TODO: refactor, this is ugly
        |> Map.from_struct()
        |> Map.delete(:__meta__)
        |> to_string_map()
        |> Map.put("id", issue.uid)
        |> Map.put("author_id", issue.author.uid)
        |> Map.put("assignee_id", nil)
        |> Map.put("action", "close")
        |> Map.put("state", "closed")

      conn =
        post(
          conn,
          Routes.gitlab_path(conn, :create),
          %{
            "object_kind" => "issue",
            "project" => %{"id" => issue.project.uid},
            "object_attributes" => issue_payload
          }
        )

      assert response(conn, 200)
      assert IssueQueries.get_issue!(issue.uid).state == "closed"
    end
  end

  defp to_string_map(dict) do  # TODO: refactor, make helper
    Map.new(dict, fn {k, v} -> {Atom.to_string(k), v} end)
  end
end
