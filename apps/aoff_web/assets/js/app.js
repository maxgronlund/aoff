// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket

// import AddToBasket from "./add_to_basket"

// Import local files
import ShopDate from "./shop-date"
import PickUp from "./pick-up"
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"

ShopDate.init(socket)
PickUp.init(socket)

// AddToBasket.init()


// $ curl -i 'http://localhost:4000/phoenix/live_reload/socket/websocket?vsn=2.0.0' -H 'Pragma: no-cache' -H 'Origin: http://localhost:4000' -H 'Accept-Language: en-US,en;q=0.9,da;q=0.8,pl;q=0.7,sv;q=0.6,fi;q=0.5,nb;q=0.4,und;q=0.3' -H 'Sec-WebSocket-Key: X/8xlvB4a814k561dM5lBg==' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36' -H 'Upgrade: websocket' -H 'Sec-WebSocket-Extensions: permessage-deflate; client_max_window_bits' -H 'Cache-Control: no-cache' -H 'Cookie: testCookie=1; cookie_notice=1; auth_token=PTOtCDNUUIqUknJea-6mAw; _samso_session=ZWtEMmxOZHdMZ1FlaXpsWTVJTUl2N3Axdjd6NTlGQ25BelF0dElENVRwSXpHUGJlR1B4cDc5VyttUHFMd0ttd3k3c25PdGY1aGFsL3RkbFlyeDdjVFByTUxZNDZFdHlJeUZlOGFCSDBkU0FqOVBpbHV2K1QrRHRPcGh1YUdTZUlTVngrTFhxSytGZlk3N2Y1ZGZXZ0htNTJTemZlRWlycUlCelMxN3ZLcm01eiswcExFN3o1cVdndExPZlhhZGsrdGJJZ2NxRDZzVDFHWUg5ZkhrMU40RlhUV3RtQlJzUGpDUXl3L3VpNTByRlFVZ0ZWYzA1UUZuV3BwejZ4MnFya1Z0RTNvc2JhTEJhTmg1R1pQWndrV1RkNWUrTWV5SGdIZkQyTXEwYW1uYUZURTRtcGEwOFY1Nm4ySTlnQ2Z0b0F3VDdvVHRrbThEc3NNaFVvRUEzbFlqS1hiaGpab2xlVFdhWk5zT3B4NGxNRTMzVFhHMzV5QzFoQVhQSXduaTEvWDFaVDFBU3FWSFlLaGQyTkxVZDVCNVY4YThTcEdrczhMQXlOWVF3QnVRUT0tLVJyaE0vTEpsK1RiTHJQaFA4UXI0cFE9PQ%3D%3D--d85d797b7d9e6294afc4a3d23381dad612c1ec72; _aoff_web_key=SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYSkNfOTlzN09XeXhTVU9tNHVJNzA5TVl6bQAAAAd1c2VyX2lkbQAAACRjNjQwMzVjOC0zYzkxLTRjODEtODk5My1kMDNiNGI5YjM5NmM.QbOMG8ECnwHBUhbDRE6dLV1J64KNaPWDj4pjcaIF6jE' -H 'Connection: Upgrade' -H 'Sec-WebSocket-Version: 13' --compressed