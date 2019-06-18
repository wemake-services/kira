defmodule Kira.Projects.Services.Files.GitlabFileFetcher do
  @moduledoc """
  HTTP client to fetch files from Gitlab.
  """

  use Kira.Common.Gitlab.Client

  plug Tesla.Middleware.Timeout, timeout: 2000
  plug Tesla.Middleware.Retry

  @branch "master"

  def fetch(%{project_uid: project_uid, file_path: file_path}) do
    project_uid
    |> api_path(file_path)
    |> get!()
  end

  defp api_path(project_uid, path) do
    "/projects/#{encode(project_uid)}/repository/files/#{encode(path)}/raw?ref=#{
      @branch
    }"
  end

  defp encode(param) do
    param
    |> URI.encode_www_form()
  end
end
