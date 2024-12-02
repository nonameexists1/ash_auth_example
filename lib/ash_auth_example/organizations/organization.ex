defmodule AshAuthExample.Organizations.Organization do
  use Ash.Resource,
    otp_app: :ash_auth_example,
    domain: AshAuthExample.Organizations,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "organizations"
    repo AshAuthExample.Repo

    manage_tenant do
      template [:slug]
    end
  end

  code_interface do
    define :get_by_slug, args: [:slug]
    define :all_organizations
    define :create, args: [:name, :slug]
  end

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept [:name, :slug]
    end

    update :update do
      primary? true
      accept [:name, :slug]
    end

    destroy :destroy do
      primary? true
    end

    read :all_organizations do
    end

    read :get_by_slug do
      argument :slug, :string, allow_nil?: false

      get_by [:slug]
    end
  end

  attributes do
    integer_primary_key :id

    attribute :name, :string do
      public? true
      allow_nil? false
    end

    attribute :slug, :string do
      public? true
      allow_nil? false
    end
  end

  identities do
    identity :unique_name, [:name]
    identity :unique_slug, [:slug]
  end

  defimpl Ash.ToTenant do
    def to_tenant(%{id: id} = org, resource) do
      if Ash.Resource.Info.data_layer(resource) == AshPostgres.DataLayer &&
           Ash.Resource.Info.multitenancy_strategy(resource) == :context do
        org.slug
      else
        id
      end
    end
  end
end
