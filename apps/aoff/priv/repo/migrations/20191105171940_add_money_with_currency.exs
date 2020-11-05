defmodule AOFF.Repo.Migrations.AddMoneyWithCurrency do
  use Ecto.Migration

  def up do
    if System.get_env("PREFIX") == "public" do
      execute """
      CREATE TYPE public.money_with_currency AS (amount integer, currency char(3))
      """
    end
  end

  def down do
    if System.get_env("PREFIX") == "public" do
      execute """
      DROP TYPE public.money_with_currency
      """
    end
  end
end
