defmodule AOFF.Bambora do
  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://api.v1.checkout.bambora.com"
  plug Tesla.Middleware.Headers, [
    {"authorization", "basic: " <> "MEdUaEd0bEpldm9hTzBSNU5jN1k="},
    {"content"}
  ]
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.FormUrlencoded

  def go() do
    #get("/sessions")

    # password = "0GThGtlJevoaO0R5Nc7Y@T356710501:fzxojhtu0mLcgxSCne4WOci4QrQaPPGmiGSasFW9"
    # IO.inspect Base.encode64(password)


    request_body =
      %{
        order: %{
          id: "123",
          amount: 9900,
          currency: "DKK"
          },
        url: %{
          accept: "https://aoff.herokupp.com/shop/payment_accepted",
          cancel: "https://aoff.herokua.com/shop/payment_declined"
        }
      }
    IO.inspect request_body

    # request_body = %{name: "Joel", age: 21}
    path = "/sessions"
    IO.inspect post(path, request_body)
  end


  def get() do

      accessToken = "0GThGtlJevoaO0R5Nc7Y"
      merchantNumber = "T356710501";
      secretToken = "fzxojhtu0mLcgxSCne4WOci4QrQaPPGmiGSasFW9";

      IO.inspect api_key = Base.encode64(accessToken <> "@" <> merchantNumber <> ":" <> secretToken)



      # checkoutUrl = "https://api.v1.checkout.bambora.com/sessions";

      # request = array();
      # request["order"] = array();
      # request["order"]["id"] = "ABC123";
      # request["order"]["amount"] = "195";
      # request["order"]["currency"] = "DKK";

      # request["url"] = array();
      # request["url"]["accept"] = "https://example.org/accept";
      # request["url"]["cancel"] = "https://example.org/cancel";
      # request["url"]["callbacks"] = array();
      # request["url"]["callbacks"][] = array("url" => "https://example.org/callback");

      # requestJson = json_encode(request);

      # contentLength = isset(requestJson) ? strlen(requestJson) : 0;

      # headers = array(
      #   'Content-Type: application/json',
      #   'Content-Length: ' . contentLength,
      #   'Accept: application/json',
      #   'Authorization: Basic ' . apiKey
      # );

      # curl = curl_init();

      # curl_setopt(curl, CURLOPT_CUSTOMREQUEST, "POST");
      # curl_setopt(curl, CURLOPT_POSTFIELDS, requestJson);
      # curl_setopt(curl, CURLOPT_URL, checkoutUrl);
      # curl_setopt(curl, CURLOPT_RETURNTRANSFER, true);
      # curl_setopt(curl, CURLOPT_HTTPHEADER, headers);
      # curl_setopt(curl, CURLOPT_FAILONERROR, false);
      # curl_setopt(curl, CURLOPT_SSL_VERIFYPEER, false);

      # rawResponse = curl_exec(curl);
      # response = json_decode(rawResponse);

  end
end


# https://web.na.bambora.com/scripts/payment/payment.asp?merchant_id=T356710501&hashValue=468155ff50e868a98626b1a5a5de6474999b04fe