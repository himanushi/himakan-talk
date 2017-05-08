(function(){
  var
    app_url = 'himakan-talk.herokuapp.com';
    scripts = [
      'http://' + app_url + '/javascripts/action_cable.min.js',
      'http://' + app_url + '/javascripts/cable.min.js',
      'https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js',
      'http://code.jquery.com/ui/1.12.1/jquery-ui.min.js'
    ];

  (function(){
    $.getScriptsSequencial = function(scripts, callback) {
      var f = function(i) {
        $.getScript(scripts[i], function(){
          if (i+1 < scripts.length) {
            f(i+1);
          } else {
            callback();
          }
        });
      };
      f(0);
    };
  }).call(this);

  (function(){
    if (is_current_pc()) {
      $.getScriptsSequencial(scripts, function () {
        var app_template =
          '<div id="himakan_talk">' +
          '<div id="himakan_talk_title">ひま缶トーク</div>' +
          '<form><input id="user_name" placeholder="名前@パスワード" type="text" value="' + ($.cookie( 'himakan_talk_user_name') || '') + '">' +
          '<input id="himakan_talk_content" placeholder="会話入力してEnter!!" data-behavior="chat_room_talk" type="text"></form>' +
          '<div id="messages"></div></div>';

        $('body')
          .append(app_template)
          .find('#himakan_talk').draggable({containment: 'body',scroll: false});

        $.getJSON('http://' + app_url + '/chat_rooms/' + location_origin(), function(data){
          for(var i in data){ $("#messages").prepend(talk_template(data[i])) }
        });

        App.cable.subscriptions.consumer.url = 'ws://' + app_url + '/cable';
        App.chat_room = App.cable.subscriptions.create({
          channel: "ChatRoomChannel",
          url: location_origin()
        }, {
          connected: function() {
            return console.log("connected!!")
          },
          disconnected: function() {
            return console.log("disconnected!!")
          },
          received: function(t) {
            return $("#messages").prepend(talk_template(t)).animate({ scrollTop: 0 }, 500),
              $('.talk').first().animate( {
                backgroundColor: '#888'
              }, 600).animate( {
                backgroundColor: '#000'
              }, 400)
          },
          talk: function(t, e, n) {
            return this.perform("talk", {
              url: location_origin(),
              user_name: e,
              message: n
            })
          }
        }),
          $(document).on("keypress", "[data-behavior~=chat_room_talk]", function(t) {
            if (13 === t.keyCode)
              return App.chat_room.talk(location_origin(), $('#user_name').val(), t.target.value),
                t.target.value = "",
                t.preventDefault(),
                $.cookie('himakan_talk_user_name', $('#user_name').val())
          })
      })
    }
  }).call(this);

  function is_current_pc() {
    var ua = navigator.userAgent;
    if (ua.indexOf('iPhone') > 0 ||
      ua.indexOf('iPod') > 0 ||
      ua.indexOf('Android') > 0 ||
      ua.indexOf('iPad') > 0) {
      return false;
    } else {
      return true;
    }
  }

  function talk_template(t) {
    return '<div class="talk"><div class="user" title="' + t.code + '">' +
      t.name + '</div><div class="date">' + t.date +
      '</div><div class="message">' + t.message + "</div></div>\n"
  }

  function location_origin() { return window.location.origin.replace(/\//g, '').replace(/\./g, '') }
}).call(this);
