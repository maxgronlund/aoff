# script for confirmation of all existing users
# mix run apps/aoff/priv/repo/confirm_users.exs

alias AOFF.Users.User
alias AOFF.Users
import Ecto.Query

users = AOFF.Repo.all(User)

for user <- users do
  Users.confirm_user(user)
end