defmodule AOFFWeb.System.SMSMessageController do
  use AOFFWeb, :controller

  alias AOFF.System
  alias AOFF.System.SMSMessage

  alias AOFFWeb.Users.Auth
  plug Auth
  plug :authenticate when action in [:index, :show, :create, :delete]

  def index(conn, _params) do
    sms_messages = System.list_sms_messages()
    render(conn, "index.html", sms_messages: sms_messages)
  end

  def new(conn, _params) do
    changeset = System.change_sms_message(%SMSMessage{mobile: "4581907375"})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sms_message" => sms_message_params}) do
    user = conn.assigns.current_user

    _result =
      case sms_api().send_sms_message(sms_message_params) do
        {:ok, %HTTPoison.Response{} = response} ->
          IO.inspect(response)

        {:error, reason} ->
          IO.inspect(reason)
      end

    sms_message_params = Map.put(sms_message_params, "user_id", user.id)

    case System.create_sms_message(sms_message_params) do
      {:ok, sms_message} ->
        conn
        |> put_flash(:info, "Sms message created successfully.")
        |> redirect(to: Routes.system_sms_message_path(conn, :show, sms_message))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp sms_api() do
    Application.get_env(:aoff, :sms_api)
  end

  # todo
  # defp send_sms_message(sms_message_params) do
  #   IO.puts "===================="

  #   IO.inspect sms_message_params["mobile"]
  #   IO.inspect sms_message_params["text"]

  #   # endpoint = Application.get_env(:aoff_web, :cpsms)[:endpoint]
  #   # token = Application.get_env(:aoff_web, :cpsms)[:token]

  #   # body =
  #   #   Poison.encode!(%{
  #   #     to: "4581907375",
  #   #     message: "test message from aoff",
  #   #     from: "Max - AOFF"
  #   #   })

  #   # HTTPoison.post(
  #   #   endpoint,
  #   #   body,
  #   #   [
  #   #     {"content-type", "application/json"},
  #   #     {"Authorization: Basic #{token}", ""}
  #   #   ]
  #   # )
  #   {:error, "========= test=========="}
  # end

  def show(conn, %{"id" => id}) do
    sms_message = System.get_sms_message!(id)
    render(conn, "show.html", sms_message: sms_message)
  end

  def delete(conn, %{"id" => id}) do
    sms_message = System.get_sms_message!(id)
    {:ok, _sms_message} = System.delete_sms_message(sms_message)

    conn
    |> put_flash(:info, "Sms message deleted successfully.")
    |> redirect(to: Routes.system_sms_message_path(conn, :index))
  end

  defp authenticate(conn, _opts) do
    conn = assign(conn, :page, :volunteer)

    if conn.assigns.volunteer do
      conn
    else
      conn
      |> put_status(401)
      |> put_view(AOFFWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
