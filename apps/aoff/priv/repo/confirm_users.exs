# script for confirmation of all existing users

alias AOFF.Users.User
alias AOFF.Users
import Ecto.Query

users = AOFF.Repo.all(User)

for user <- users do
  Users.confirm_user(user)
end