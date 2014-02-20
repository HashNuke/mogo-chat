//NOTE from http://stackoverflow.com/a/1060034/477045
(function() {
    var hidden = "hidden";

    // Standards:
    if (hidden in document)
        document.addEventListener("visibilitychange", onVisibilityChange);
    else if ((hidden = "mozHidden") in document)
        document.addEventListener("mozvisibilitychange", onVisibilityChange);
    else if ((hidden = "webkitHidden") in document)
        document.addEventListener("webkitvisibilitychange", onVisibilityChange);
    else if ((hidden = "msHidden") in document)
        document.addEventListener("msvisibilitychange", onVisibilityChange);
    // IE 9 and lower:
    else if ('onfocusin' in document)
        document.onfocusin = document.onfocusout = onVisibilityChange;
    // All others:
    else
        window.onpageshow = window.onpagehide 
            = window.onfocus = window.onblur = onVisibilityChange;

    function onVisibilityChange (evt) {
      var v = 'visible', h = 'hidden';
      var evtMap = {
        focus:v, focusin:v, pageshow:v, blur:h, focusout:h, pagehide:h
      };

      evt = evt || window.event;
      if(evt.type == "focusout" || evt.type == "blur" || evt.type == "pagehige" || this[hidden]) {
        App.isPageActive = false;
      }
      else {
        App.isPageActive = true;
        document.title = "Mogo Chat";
      }
    }
})();


App.notifyBySound = function() {
  if(App.isPageActive)
    return

  if(!document.title.match(/[\+]/g))
    document.title = "[+] " + document.title;

  $audio = $("#app-audio")[0];
  $audio.load();
  $audio.play();
};