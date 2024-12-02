defmodule AshAuthExample.Accounts do
  use Ash.Domain

  resources do
    resource AshAuthExample.Accounts.Token
    resource AshAuthExample.Accounts.User
  end
end
