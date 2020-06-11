defmodule AOFF.Repo.Migrations.AddPaymentMethodToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :paymenttype, :string, default: "1"
    end
  end
end
