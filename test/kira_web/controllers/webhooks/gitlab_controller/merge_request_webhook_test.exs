defmodule KiraWebTest.Webhooks.GitlabController.MergeRequestWebhookTest do
  use KiraWeb.ConnCase

  import Tesla.Mock
  import KiraTest.Factory
  alias Kira.Common.{TimeUtils, MapUtils}
  alias Kira.Projects.Queries.MergeRequestQueries

  setup %{conn: conn} do
    # Just disable all HTTP calls:
    mock_global(fn _ -> %Tesla.Env{status: 200} end)

    token = Application.get_env(:kira, :gitlab)[:secret_header_value]
    conn = put_req_header(conn, "x-gitlab-token", token)

    {:ok, project: insert(:project), author: insert(:user), conn: conn}
  end

  describe "create merge request webhook" do
    test "valid merge request data is handled", %{
      project: project,
      author: author,
      conn: conn
    } do
      merge_request_params = string_params_for(:merge_request, author: author)

      {:ok, created_at, _} =
        DateTime.from_iso8601(merge_request_params["origin_timestamp"])

      merge_request =
        merge_request_params
        |> Map.put("id", merge_request_params["uid"])
        |> Map.put("created_at", TimeUtils.to_gitlab_timeformat!(created_at))
        |> Map.put("author_id", author.uid)
        |> Map.put("assignee_id", nil)
        |> Map.put("action", "open")

      conn =
        post(
          conn,
          Routes.gitlab_path(conn, :create),
          %{
            "object_kind" => "merge_request",
            "project" => %{"id" => project.uid},
            "object_attributes" => merge_request
          }
        )

      assert response(conn, 200)
      assert MergeRequestQueries.get_merge_request!(merge_request["uid"])
    end
  end

  describe "update merge request webhook" do
    setup %{project: project, author: author} do
      {:ok,
       merge_request: insert(:merge_request, project: project, author: author)}
    end

    test "valid merge request data is handled", %{
      merge_request: merge_request,
      conn: conn
    } do
      created_at =
        TimeUtils.to_gitlab_timeformat!(merge_request.origin_timestamp)

      merge_request_payload =
        merge_request
        |> Map.from_struct()
        |> Map.delete(:__meta__)
        |> MapUtils.stringify_keys()
        |> Map.merge(%{
          "id" => merge_request.uid,
          "author_id" => merge_request.author.uid,
          "assignee_id" => nil,
          "merge_status" => "can_be_merged",
          "action" => "update",
          "work_in_progress" => false,
          "created_at" => created_at
        })

      conn =
        post(
          conn,
          Routes.gitlab_path(conn, :create),
          %{
            "object_kind" => "merge_request",
            "project" => %{"id" => merge_request.project.uid},
            "object_attributes" => merge_request_payload
          }
        )

      assert response(conn, 200)

      instance = MergeRequestQueries.get_merge_request!(merge_request.uid)

      assert instance.state == "opened"
      assert instance.assignee_id == nil
      assert instance.merge_status == "can_be_merged"
      assert instance.work_in_progress == false
    end
  end
end
