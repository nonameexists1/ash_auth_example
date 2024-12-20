defmodule AshAuthExample.Repo.TenantMigrations.Example do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:users, primary_key: false, prefix: prefix()) do
      add :confirmed_at, :utc_datetime_usec
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :text, null: false
    end

    create unique_index(:users, [:email], name: "users_unique_email_index")
  end

  def down do
    drop_if_exists unique_index(:users, [:email], name: "users_unique_email_index")

    drop table(:users, prefix: prefix())
  end
end
