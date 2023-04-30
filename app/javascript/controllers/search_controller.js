import { Controller } from '@hotwired/stimulus';
import consumer from '../channels/consumer';

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ['query', 'arguments'];

  arguments() {
    const query = this.queryTarget;
    const queryValue = query.value;
    const url = this.element.dataset.suggesttionsUrl;

    document.getElementById('search-form').addEventListener('keyup', (e) => {
      if (e.keyCode === 13) {
        e.preventDefault();
        return false;
      }

      clearTimeout(this.timeout);
      this.timeout = setTimeout(() => {
        this.requestArguments(queryValue, url);
      }, 100);
    });
  }

  requestArguments(queryValue, url) {
    if (queryValue.length < 0) {
      return false;
    }

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')
          .content,
      },

      body: JSON.stringify({
        query: queryValue,
      }),
    }).then((response) => {
      response.text().then((data) => {
        document.body.insertAdjacentHTML('beforeend', data);
      });
    });
  }

  hideArguments() {
    const result = document.getElementById('arguments');
    result.innerHTML = '';
  }

  // saveArgument(queryValue) {
  //   const url = this.element.dataset.saveUrl;

  //   fetch(url, {
  //     method: 'POST',
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')
  //         .content,
  //     },

  //     body: JSON.stringify({
  //       query: queryValue,
  //     }),
  //   }).then((response) => {
  //     response.text().then((data) => {
  //       document.body.insertAdjacentHTML('beforeend', data);
  //     });
  //   });
  // }
}
