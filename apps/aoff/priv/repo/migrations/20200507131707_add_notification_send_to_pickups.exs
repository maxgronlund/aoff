defmodule AOFF.Repo.Migrations.AddNotificationSendToPickups do
  use Ecto.Migration

  def change do
    alter table("pick_ups") do
      add :send_sms_notification, :boolean, default: true
    end
  end
end
