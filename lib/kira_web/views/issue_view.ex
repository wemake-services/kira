defmodule KiraWeb.IssueView do
  use KiraWeb, :view
  alias KiraWeb.IssueView

  def render("index.json", %{issues: issues}) do
    %{data: render_many(issues, IssueView, "issue.json")}
  end

  def render("show.json", %{issue: issue}) do
    %{data: render_one(issue, IssueView, "issue.json")}
  end

  def render("issue.json", %{issue: issue}) do
    %{id: issue.id, uid: issue.uid}
  end
end
