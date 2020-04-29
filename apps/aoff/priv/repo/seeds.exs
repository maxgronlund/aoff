# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AOFF.Repo.insert!(%AOFF.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias AOFF.Blogs

# {:ok, blog} =
#   Blogs.create_blog(%{
#     "title" => "Nyheder",
#     "description" => "some description",
#     "identifier" => "news"
#   })

# for n <- 1..1 do
#   s = Integer.to_string(n)

#   Blogs.create_post(%{
#     "blog_id" => blog.id,
#     "title" => "some title" <> s,
#     "date" => Date.utc_today(),
#     "text" => "some text" <> s,
#     "tag" => "some tag" <> s,
#     "author" => "some author" <> s,
#     "caption" => "some caption" <> s
#   })
# end

for n <- 1..15 do
  n
  s = Integer.to_string(n)

  AOFF.Users.create_user(%{
    "member_nr" => n = 100,
    "username" => "User-" <> s,
    "email" => "user-" <> s <> "@example.com",
    "mobile" => Integer.to_string(n + 1_234_578),
    "password" => "password",
    "expiration_date" => Date.add(Date.utc_today(), 365),
    "month" => 12,
    "admin" => false,
    "volunteer" => n < 12,
    "purchasing_manager" => n < 4,
    "shop_assistant" => n < 41,
    "terms_accepted" => true,
    "registration_date" => Date.utc_today()
  })
end

alias AOFF.Shop

Shop.secure_dates()

# for n <- 1..5 do
#   s = Integer.to_string(n)

#   Shop.create_product(%{
#     "name" => "Product-" <> s,
#     "description" => "Description-" <> s,
#     "price" => Money.new(n * 100 + 300, :DKK),
#     "for_sale" => false,
#     "membership" => false
#   })
# end

Shop.create_product(%{
  "name" => "Stor pose",
  "description" => "Stor pose",
  "price" => Money.new(10000, :DKK),
  "for_sale" => true,
  "membership" => false,
  "show_on_landing_page" => true
})

Shop.create_product(%{
  "name" => "Lille pose",
  "description" => "Lille pose",
  "price" => Money.new(8000, :DKK),
  "for_sale" => true,
  "membership" => false,
  "show_on_landing_page" => false
})

Shop.create_product(%{
  "name" => "Kartofler",
  "description" => "Kartofler",
  "price" => Money.new(2000, :DKK),
  "for_sale" => true,
  "membership" => false,
  "show_on_landing_page" => false
})

Shop.create_product(%{
  "name" => "Medlemsskab",
  "description" => "Medlemsskab i et år",
  "price" => Money.new(10000, :DKK),
  "for_sale" => false,
  "membership" => true,
  "show_on_landing_page" => false
})

for year <- 2020..2029, month <- 1..11, date <- 1..31 do
  case Date.new(year, month, date) do
    {:ok, date} ->
      if Date.day_of_week(date) == 3 do
        if Date.compare(date, Date.utc_today()) == :gt do
          Shop.create_date(%{
            "date" => date,
            "open" => true
          })
        end
      end

    _ ->
      "not a date"
  end
end
