defmodule AOFF.System.UserImporter do
  NimbleCSV.define(UserCsvParser, separator: "\,", escape: "\"")

  import Ecto.Query, warn: false
  alias AOFF.Repo

  alias AOFF.Users.User
  alias AOFF.Users

  def import(path, prefix) do
    str = HTTPoison.get!(path).body
    rows = UserCsvParser.parse_string(str)

    users =
      Enum.map(rows, fn [
                          member_nr,
                          username,
                          email,
                          mobile,
                          password_hash,
                          registration_date,
                          expiration_date
                        ] ->
        %{
          "member_nr" => member_nr,
          "username" => username,
          "email" => email,
          "mobile_country_code" => "45",
          "mobile" => mobile,
          "password_hash" => password_hash,
          "registration_date" => to_date(registration_date),
          "expiration_date" => to_date(expiration_date)
        }
      end)

    for attrs <- users do
      member_nr = attrs["member_nr"]

      unless member_nr == "" do
        user = Users.get_user_by_member_nr(member_nr, prefix)

        if is_nil(user) do
          IO.puts("not found: " <> attrs["username"])
          changeset = User.import_changeset(%User{}, attrs)
          Repo.insert(changeset)
        else
          IO.puts("found: " <> attrs["username"])
        end
      end
    end
  end

  def to_date(date_str) do
    [y, m, d] =
      Regex.run(~r/\d+-\d+-\d+/, date_str)
      |> List.first()
      |> String.replace("-", " ")
      |> String.split()
      |> Enum.map(fn n -> String.to_integer(n) end)

    {:ok, date} = Date.new(y, m, d)
    date
  end
end

# AOFF.System.UserImporter.to_date("~D[2020-01-18]")

# AOFF.System.UserImporter.import("https://aoff.s3-eu-west-1.amazonaws.com/imports/aoff-import.csv", "prefix")
