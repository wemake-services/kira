# https://github.com/thoughtbot/ex_machina
{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Kira.Repo, :manual)

# https://github.com/igas/faker
Faker.start()

# Mocking different things:
# https://hexdocs.pm/mox/Mox.html
# https://github.com/teamon/tesla/issues/241
Mox.defmock(
  KiraTest.Projects.Services.Reactions.Providers.GitlabReaction.Mock,
  for: Tesla.Adapter
)

Mox.defmock(
  KiraTest.Accounts.Services.Providers.GitlabUsers.Mock,
  for: Tesla.Adapter
)
