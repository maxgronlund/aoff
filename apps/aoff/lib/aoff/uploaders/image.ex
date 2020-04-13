defmodule AOFF.Uploader.Image do
  use Arc.Definition

  @acl :public_read

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original, :thumb, :stamp, :avatar]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a original transformation:
  def transform(:original, _) do
    {:convert, "-strip -thumbnail 700x433^ -gravity center -extent 700x433 -format png", :png}
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 310x192^ -gravity center -extent 310x192 -format png", :png}
  end

  # Define a stamp transformation:
  def transform(:stamp, _) do
    {:convert, "-strip -thumbnail 100x62^ -gravity center -extent 100x62 -format png", :png}
  end

  # Define a stamp transformation:
  def transform(:avatar, _) do
    {:convert, "-strip -thumbnail 150x150^ -gravity center -extent 150x150 -format png", :png}
  end

  # Override the persisted filenames:
  def filename(version, {file, scope}) do
    version
  end

  # Override the storage directory:
  def storage_dir(version, {file, scope}) do
    "uploads/post/images/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(version, scope) do
    "https://aoff.s3-eu-west-1.amazonaws.com/default/image/#{version}.jpg"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  def s3_object_headers(version, {file, scope}) do
    [content_type: MIME.from_path(file.file_name)]
  end
end

# "/uploads/post/images/907ca6bb-1bee-4dc4-9d48-83bd7163e8e1/original.png"
# "/uploads/post/images/d4875e1e-f5f0-44f7-99cd-dd666bd7a074/original.png"
# "/uploads/post/images/ccd29608-41d8-476d-a57d-16403737d968/thumb.png"
