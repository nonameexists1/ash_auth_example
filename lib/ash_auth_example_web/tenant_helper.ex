defmodule AshAuthExampleWeb.TenantHelper do
  def transform_tenant(tenant) do
    tenant
    |> String.split(".")
    |> hd
  end
end
