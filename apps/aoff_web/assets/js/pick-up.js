let PickUp = {
  init(socket) {

    let channel = socket.channel('pick:up', {})
    channel.join()
    this.listenForPickup(channel)
  },

  listenForPickup(channel) {

    console.log("listenForPickup channel loaded")
    // let pick_up_botton = document.getElementsByClassName('pick_up_botton ');

    $(document).on('click', '.pick_up_botton', function (e) {

        $(this).hide()


        let pickUpId = $(this).attr('pick_up_id')
        let params =
          {
            "pick_up_id": pickUpId
          }
        channel.push('handled', params)
        $( `#` + pickUpId).show()
        $( `#sms-` + pickUpId).hide()
      }
    )

    $(document).on('click', '.sms_button', function (e) {

        let pickUpId = $(this).attr('pick_up_id')
        let params =
          {
            "pick_up_id": pickUpId
          }
        channel.push('send_sms_reminder', params)
        console.log(pickUpId)
        $(this).hide()
      }
    )
    /*
    $(document).on('click', '.basket-button', function (e) {

      let userId = $(this).attr('user_id')
      let productId = $(this).attr('product_id')
      let dateId = $(this).attr('date_id')
      let product_name = $(this).attr('product_name')

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

      $('#numberCircle').css('visibility', 'visibil')

      $('#shop-dialog-text').empty()
      $('#shop-dialog-text').append(product_name)

      let numberCircle = $('#numberCircle')

      let basketCount = parseInt(numberCircle.html()) + 1


      numberCircle.empty()
      numberCircle.append(basketCount)
      numberCircle.show()

    })
    */
  }
}

export default PickUp

