defmodule AOFF.Token do
  use(Puid, bits: 92, charset: :alphanum)
end
