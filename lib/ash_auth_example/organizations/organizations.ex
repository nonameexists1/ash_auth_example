defmodule AshAuthExample.Organizations do
  use Ash.Domain

  resources do
    resource AshAuthExample.Organizations.Organization
  end
end
