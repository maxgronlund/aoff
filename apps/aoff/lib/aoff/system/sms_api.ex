defmodule AOFF.SMSApi do
  def send_sms_message(params) do
    endpoint = Application.get_env(:aoff_web, :cpsms)[:endpoint]
    token = Application.get_env(:aoff_web, :cpsms)[:token]

    body =
      Poison.encode!(%{
        to: params["mobile"],
        message: params["text"],
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
