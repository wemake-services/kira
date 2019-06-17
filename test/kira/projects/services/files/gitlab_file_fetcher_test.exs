defmodule Kira.Projects.Services.Files.GitlabFileFetcherTest do
  use KiraTest.TeslaMock

  alias Kira.Projects.Services.Files.GitlabFileFetcher
  alias KiraTest.Projects.Services.Files.GitlabFileFetcher.Mock

  mock(Mock)

  @project_uid "test_project_uid"
  @file_path "kira.yml"
  @expected_url "https://gitlab.com/api/v4/projects/#{@project_uid}/repository/files/#{
                  @file_path
                }/raw?ref=master"

  test "fetch file" do
    Mock
    |> expect(:call, fn
      %{method: :get, url: url}, _opts ->
        assert url == @expected_url
        {:ok, %Tesla.Env{status: 200}}
    end)

    GitlabFileFetcher.fetch(%{project_uid: @project_uid, file_path: @file_path})
  end
end
