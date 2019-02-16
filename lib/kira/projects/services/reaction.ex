defmodule Kira.Projects.Services.Reaction do
  use Exop.Operation

  alias Kira.Projects.Entities.Issue

  @domain Application.get_env(:kira, :gitlab)[:domain]
  @private_token Application.get_env(:kira, :gitlab)[:personal_token]

  parameter(:entity)

  def process(%{entity: %Issue{}} = params) do
    params.entity
    |> build_request
    |> react_async

    params
  end

  defp build_request(%Issue{} = issue) do
    domain = "#{@domain}/api/v4"
    path = "projects/#{issue.project.uid}/issues/#{issue.iid}/award_emoji"
    {"#{domain}/#{path}", %{name: "tada", private_token: @private_token}}
  end

  defp react_async({url, params}) do
    Task.async fn ->
      HTTPoison.post!(url, [], [], params: params)
    end
  end
end
