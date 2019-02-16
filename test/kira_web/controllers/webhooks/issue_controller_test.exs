defmodule KiraWeb.Webhooks.IssueControllerTest do
  use KiraWeb.ConnCase

  alias Kira.Projects
  alias Kira.Projects.Issue

  @create_attrs %{
    uid: 42
  }
  @update_attrs %{
    uid: 43
  }
  @invalid_attrs %{uid: nil}

  def fixture(:issue) do
    {:ok, issue} = Projects.create_issue(@create_attrs)
    issue
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create issue" do
    # TODO: test correct creation and use real webhook data format
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.issue_path(conn, :create), issue: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_issue(_) do
    issue = fixture(:issue)
    {:ok, issue: issue}
  end
end
