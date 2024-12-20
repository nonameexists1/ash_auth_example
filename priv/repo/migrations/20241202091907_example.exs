defmodule AshAuthExample.Repo.Migrations.Example do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:organizations, primary_key: false) do
      add :id, :bigserial, null: false, primary_key: true
      add :name, :text, null: false
      add :slug, :text, null: false
    end

    create unique_index(:organizations, [:name], name: "organizations_unique_name_index")

    create unique_index(:organizations, [:slug], name: "organizations_unique_slug_index")
  end

  def down do
    drop_if_exists unique_index(:organizations, [:slug], name: "organizations_unique_slug_index")

    drop_if_exists unique_index(:organizations, [:name], name: "organizations_unique_name_index")

    drop table(:organizations)
  end
end
