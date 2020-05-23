$('#accept-payment-terms').change(function() {
    // this will contain a reference to the checkbox
    if (this.checked) {
        $('#go-to-payment').prop( "disabled", false );
    } else {
      $('#go-to-payment').prop( "disabled", true );
    }
});