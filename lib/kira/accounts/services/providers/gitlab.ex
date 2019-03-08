defmodule Kira.Accounts.Services.Providers.GitlabUsers do
  @moduledoc """
  HTTP client to fetch `User`s from Gitlab.
  """

  use Kira.Common.Gitlab.Client

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Timeout, timeout: 2000
  plug Tesla.Middleware.Retry

  # URL API:

  def in_project_url(project) do
    "/projects/#{project.uid}/members/all"
  end

  # HTTP API:

  def in_project(project) do
    get!(in_project_url(project), [])
  end
end
