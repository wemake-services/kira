defmodule KiraWeb.ProjectView do
  use KiraWeb, :view
  alias KiraWeb.ProjectView

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{
      id: project.id,
      uid: project.uid,
      name: project.name,
      url: project.url,
      path: project.path
    }
  end
end
