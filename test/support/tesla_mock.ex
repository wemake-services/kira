defmodule KiraTest.TeslaMock do
  @moduledoc """
  Allows to use `Tesla` and `Mox` together.

  Sets temporary `:adapter` property for `Tesla` before each test.
  And after each test removes it back to normal.

  Usage:

    use KiraTest.TeslaMock
    mock Your.Module.NameMock

  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Mox

      import KiraTest.TeslaMock
      require KiraTest.TeslaMock
    end
  end

  setup context do
    old_adapter = Application.get_env(:tesla, :adapter)
    Application.put_env(:tesla, :adapter, context.mock)

    on_exit(fn ->
      Application.put_env(:tesla, :adapter, old_adapter)
    end)
  end

  defmacro mock(module) do
    quote do
      setup_all do
        {:ok, mock: unquote(module)}
      end

      setup :verify_on_exit!
    end
  end
end
