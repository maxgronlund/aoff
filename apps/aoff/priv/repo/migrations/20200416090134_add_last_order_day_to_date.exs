defmodule AOFF.Repo.Migrations.AddLastOrderDayToDate do
  use Ecto.Migration

  def change do
    alter table("dates") do
      add :last_order_date, :date
    end
  end
end
