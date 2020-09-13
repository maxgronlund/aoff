# script for confirmation of all existing users
# mix run apps/aoff/priv/repo/subscribe_users_to_news.exs
# heroku run "POOL_SIZE=2 mix run apps/aoff/priv/repo/subscribe_users_to_news.exs"

alias AOFF.Users.User
alias AOFF.Users
import Ecto.Query

users = AOFF.Repo.all(User)

for user <- users do
  Users.unsubscribe_to_news(user)
end