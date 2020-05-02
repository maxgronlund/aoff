let CommitteeChat = {
  init(socket) {

    let channel = socket.channel('committee:lobby', {})
    channel.join()
    this.listenForChats(channel)
  },

  listenForChats(channel) {
    let chat_form = document.getElementById('chat-form')
    if(chat_form != null) {
      chat_form.addEventListener('submit', function(e){
        e.preventDefault()

        let userName = document.getElementById('user-name').value
        let committeeId = document.getElementById('committee-id').value
        let userMsg = document.getElementById('user-msg').value

        channel.push('shout', {committee_id: committeeId, username: userName, body: userMsg})

        // document.getElementById('user-name').value = ''
        document.getElementById('user-msg').value = ''
      })

      channel.on('shout', payload => {

        let chatBox = document.querySelector('#chat-box')
        let msgBlock = document.createElement('div')

        msgBlock
          .insertAdjacentHTML(
            'beforeend',
            `<div class='date'>${payload.posted}</div>` +
            `<div class='message'><b>${payload.username}</b><br />` +
            `${payload.body.replace(/\r?\n/g, '<br />')}` +
            `</div><br />`
          )
        chatBox.appendChild(msgBlock)

        let scroll_pane = document.getElementById('chat-box')
        scroll_pane.scrollTop = scroll_pane.scrollHeight;
      })
    }
  }
}

export default CommitteeChat

