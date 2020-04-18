defmodule AOFFWeb.Cldr do
  use Cldr,
    default_locale: "en",
    locales: ["da", "en"],
    gettext: AOFFWeb.Gettext,
    data_dir: "./priv/cldr",
    otp_app: :aoff_web,
    precompile_number_formats: ["¤¤#,##0.##"],
    precompile_transliterations: [{:latn, :arab}, {:thai, :latn}]
end
