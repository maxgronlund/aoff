let ShopDate = {
  init(socket) {

    let channel = socket.channel('shop:date', {})
    channel.join()
    this.addToBasket(channel)
  },

  addToBasket(channel) {
    //let basket_button = document.getElementsByClassName('basket-button');



    $(document).on('click', '.basket-button', function (e) {



      let userId = $(this).attr('user_id')
      let productId = $(this).attr('product_id')
      let dateId = $(this).attr('date_id')
      let product_name = $(this).attr('product_name')
      // let basketCount = $(this).attr('basket_count')



      let params =
        {
          "user_id": userId,
          "product_id": productId,
          "date_id": dateId
        }

      // Send the message to the server
      channel.push('add_to_basked', params)


      // Open the modal
      let shopDialog = $("#shop-dialog").css('display', 'block')

      shopDialog.click(function() {
        shopDialog.css('display', 'none')
      })

      $('#numberCircle').css('display', 'block')

      $('#shop-dialog-text').empty()
      $('#shop-dialog-text').append(product_name)

      let numberCircle = $('#numberCircle')

      let basketCount = parseInt(numberCircle.html()) + 1


      numberCircle.empty()
      numberCircle.append(basketCount)

    })
  }
}

export default ShopDate

