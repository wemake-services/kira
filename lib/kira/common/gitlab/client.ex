defmodule Kira.Common.Gitlab.Client do
  @moduledoc """
  Represents a basic setup for tesla client that we use for Gitlab API.
  """

  defmacro __using__(_opts) do
    quote location: :keep do
      use Tesla

      @domain Application.get_env(:kira, :gitlab)[:domain]
      @api_url "#{@domain}/api/v4"
      @private_token Application.get_env(:kira, :gitlab)[:personal_token]

      plug Tesla.Middleware.BaseUrl, @api_url
      plug Tesla.Middleware.Headers, [{"Private-Token", @private_token}]

      def api_url, do: @api_url
    end
  end
end
