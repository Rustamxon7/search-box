import consumer from './consumer';

consumer.subscriptions.create('ArgumentsChannel', {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('connected arguments channel');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel

    const arguments_html = data.arguments_html;

    const result = document.getElementById('arguments-table');

    if (result === null) {
      return false;
    }

    result.innerHTML = arguments_html;
  },
});
