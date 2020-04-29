let AddToBasket = {

  init() {
    document.
      getElementById('basket_button')
      .addEventListener('click', function(e) {


      let value = document.getElementById('basket_button').getAttribute('value')
      alert(value)
    })
    // window.addEventListener('phoenix.link.click', function (e) {
    //   // Introduce custom behaviour
    //   var message = e.target.getAttribute("data-prompt");
    //   var answer = e.target.getAttribute("data-prompt-answer");
    //   if(message && answer && (answer != window.prompt(message))) {
    //     e.preventDefault();
    //   }
    // }, false);
  }

}

export default AddToBasket