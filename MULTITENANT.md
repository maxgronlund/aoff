DELETE THIS FILE IS AL HANDLED

psql -d my_app_dev -c "CREATE SCHEMA connection_prefix"


query_args = ["SET search_path TO public", []]

# Run migrations with envioronment variable to secure prefixes on index
PREFIX="prefix_roff" mix ecto.migrate --prefix "prefix_roff"



mix ecto.migrate --prefix "public"
mix ecto.migrate --prefix "public"