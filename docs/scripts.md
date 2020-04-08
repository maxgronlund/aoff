mix phx.gen.html.slime Users User users user_name:string member_nr:integer
mix phx.gen.schema Users.Credential credentials password_hash:string email:string
mix phx.gen.schema Users.Membership memberships expires:datetime

mix phx.gen.html.slime Shop Date dates date:date shop_assistant_a:binary

mix phx.gen.html.slime Shop Product products name:string description:text price:integer


Money.Ecto.Amount.Type


mix phx.gen.html.slime PaymentServices StreamingService streaming_services \
--web PaymentServices \
--table ps_streaming_services \
uuid:string
streaming_service_uuid:string \

mix phx.gen.html.slime Shop Pickup pickups \
date_id:references:date \
user_id:references:user \
order_item_id:references:order_item \
picked_up:boolean




mix phx.gen.html.slime Blogs Blog blogs title:string description:text


mix phx.gen.html.slime Blog BlogPost posts date:date title:string image:string caption:string text:text author:string


mix phx.gen.html.slime Shop Order orders user_id:binary state:string

mix phx.gen.html.slime Shop OrderItem order_items order_id:references:order date_id:references:date user_id:references:user product_id:references:product state:string


mix phx.gen.html.slime Volunteer Message messages title:string identifier:string body:text show:boolean locale:string