// modified from: https://medium.com/codex/user-session-inactivity-timeout-with-rails-and-devise-7269ac3a8213
(($) => {
  const $document = $(document);
  const sessionTimeoutPollFrequency = 30; // poll every 30 seconds
  let heartBeatActivated = false;

  class HeartBeat {
    constructor() {
      $document.on("turbolinks:load", () => {
        this.initHeartBeat();
      });
    }

    initHeartBeat() {
      this.lastActive = new Date().valueOf();
      if (!heartBeatActivated) {
        ["mousemove", "scroll", "click", "keydown"].forEach((activity) => {
          document.addEventListener(
            activity,
            (ev) => {
              this.lastActive =
                ev.timeStamp + performance.timing.navigationStart;
            },
            false
          );
        });
        heartBeatActivated = true;
      }
    }
  }

  window.heartBeat = new HeartBeat();

  function pollForSessionTimeout() {
    setTimeout(pollForSessionTimeout, sessionTimeoutPollFrequency * 1000);
    if (Date.now() - window.heartBeat.lastActive < sessionTimeoutPollFrequency * 1000
    ) {
      return;
    }

    let sessionTimeoutURL = `/session_timeout?path=${String(window.location.pathname)}`;
    $.ajax({
      type: "GET",
      url: "/check_session_timeout",
      error: () => {
        window.location.href = sessionTimeoutURL;
      }, complete: (response) => {
        if (response.status === 200 || response.status === 401) {
          if (parseInt(response.responseText) <= 0) {
            window.location.href = sessionTimeoutURL;
          }
        }
      }
    })
  }

  $document.on("turbolinks:load",
    setTimeout(pollForSessionTimeout, sessionTimeoutPollFrequency * 1000)
  );
})(window.jQuery);
