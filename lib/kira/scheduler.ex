defmodule Kira.Scheduler do
  @moduledoc """
  We use Quantum to run cron jobs inside BEAM VM.

  See configuration for the specific env
  to know what jobs we run in what envs.

  Docs: https://github.com/quantum-elixir/quantum-core
  """

  use Quantum.Scheduler, otp_app: :kira
end
