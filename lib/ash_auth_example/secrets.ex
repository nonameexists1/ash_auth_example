defmodule AshAuthExample.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], AshAuthExample.Accounts.User, _opts) do
    Application.fetch_env(:ash_auth_example, :token_signing_secret)
  end
end
