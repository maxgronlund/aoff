defmodule AOFF.SMSApi do
  def send_sms_message(sms_message_params) do

    endpoint = Application.get_env(:aoff_web, :cpsms)[:endpoint]
    token = Application.get_env(:aoff_web, :cpsms)[:token]


    body =
      Poison.encode!(%{
        to: sms_message_params["mobile"],
        message: sms_message_params["text"],
        from: "AOFF"
      })

    HTTPoison.post(
      endpoint,
      body,
      [
        {"content-type", "application/json"},
        {"Authorization: Basic #{token}", ""}
      ]
    )
  end
end