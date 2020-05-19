defmodule AOFF.Repo.Migrations.AddMobileCountryCodeToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :mobile_country_code, :string, default: "45"
    end
  end
end
