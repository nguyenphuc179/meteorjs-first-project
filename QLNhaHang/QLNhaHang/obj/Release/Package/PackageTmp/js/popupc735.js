!function () {
    window.initial = true;

    var JSON = JSON || {};

    // implement JSON.stringify serialization
    JSON.stringify = JSON.stringify || function (obj) {

        var t = typeof (obj);
        if (t != "object" || obj === null) {

            // simple data type
            if (t == "string") obj = '"' + obj + '"';
            return String(obj);

        }
        else {

            // recurse array or object
            var n, v, json = [], arr = (obj && obj.constructor == Array);

            for (n in obj) {
                v = obj[n]; t = typeof (v);

                if (t == "string") v = '"' + v + '"';
                else if (t == "object" && v !== null) v = JSON.stringify(v);

                json.push((arr ? "" : '"' + n + '":') + String(v));
            }

            return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
        }
    };


    // implement JSON.parse de-serialization
    JSON.parse = JSON.parse || function (str) {
        if (str === "") str = '""';
        eval("var p=" + str + ";");
        return p;
    };

    //section api
    var Session = Session || (function () {

        // window object
        var win = window.top || window;

        // session store
        var store = (win.name ? JSON.parse(win.name) : {});

        // save store on page unload
        function Save() {
            win.name = JSON.stringify(store);
        };

        // page unload event
        if (window.addEventListener) window.addEventListener("unload", Save, false);
        else if (window.attachEvent) window.attachEvent("onunload", Save);
        else window.onunload = Save;

        // public methods
        return {

            // set a session variable
            set: function (name, value) {
                store[name] = value;
            },

            // get a session value
            get: function (name) {
                return (store[name] ? store[name] : undefined);
            },

            // clear session
            clear: function () { store = {}; },

            // dump session data
            dump: function () { return JSON.stringify(store); }

        };

    }
    )();

    (function () {
        

        var host = "http://popupwindow.bizwebapps.vn/";
        var hostSecure = "https://popupwindow.bizwebapps.vn/";


        var GetShopName = function () {
            for (var i = 0; i < document.scripts.length; i++) {
                var getUrl = document.scripts[i].src;
                var urlCheck = getUrl.split("?")[0];
                var hostLength = host.length;
                if (urlCheck == host + 'assets/popup.js') { //Check for http instance
                    return document.scripts[i].src.substr(host.length + 22);
                    break;
                } else if (urlCheck == hostSecure + 'assets/popup.js') { //Check for https instance
                    return document.scripts[i].src.substr(hostSecure.length + 22);
                }

            }
        }
        var DataConfig = null;

        var mainPopUpScript = function ($) {

            function appendStylesheet(pathToStylesheet) {
                var head = document.getElementsByTagName("head")[0];
                var css = document.createElement("link");
                css.setAttribute("rel", "stylesheet")
                css.setAttribute("type", "text/css")
                css.setAttribute("href", pathToStylesheet)
                head.appendChild(css);
            }

            //console.log("Existing cookie found. Don't show pop-up.");
            window.cookie = true; //Make cookie global variable for exit intent
            fireModal(); //Get JSON and show modal



            function appendScript(pathToScript) {
                var head = document.getElementsByTagName("head")[0];
                var script = document.createElement("script");

                //css.setAttribute("type", "text/css")
                script.setAttribute("src", pathToScript)
                head.appendChild(script);
            }


            function fireModal() {

                //Load in Fancybox CSS
                appendStylesheet(hostSecure + "assets/fancybox/fancybox.css");
                //console.log('start of fireModal function');

                var varShop = GetShopName();

                varId = DataConfig.Id;
                varHeight = DataConfig.Height;
                varWidth = DataConfig.Width;
                varDelay = 2000;
                if (DataConfig.Active) {
                    var body = document.getElementsByTagName("body")[0];
                    var image = document.createElement("img");


                    $(body).append("<div id='PopupImage' hidden ></div>");
                    body.appendChild(image);


                    if (!DataConfig.SessionPopup) writeCookie(DataConfig.Frequency);
                    //console.log("Regular mode. Call showPopupWindow function after delay.");
                    setTimeout(function () {
                        showPopupWindow(DataConfig);
                    }, varDelay);

                }


            };
            //End fireModal function

            //fancybox modal parameters
            function showPopupWindow(data) {
                if (data.HasLink) {
                    var target = '';
                    if (data.NewTab) target = 'target="_blank"';
                    $("#PopupImage").append("<a href='" + data.Link + "' " + target + " > <img width='100%' src='" + data.ImageUrl + "' /></a>");
                }
                else {
                    $("#PopupImage").append("<img width='100%' src='" + data.ImageUrl + "' />");
                }
                
                if (typeof $.fancybox == 'function') {
                    $("#PopupImage").fancybox({
                        autoSize: false,
                        autoWidth: false,
                        maxWidth: data.Width,
                        autoHeight: true,
                        //autoResize: true,
                        scrolling: 'no',
                        autoCenter: true,
                        aspectRatio: true,
                        fitToView: true
                    });

                    $("#PopupImage").trigger("click");

                    $("#PopupImage").closest("body").delegate(".fancybox-wrap", "click", function (event) {
                        event.stopPropagation();
                        event.preventDefault();
                    });

                    $("#PopupImage").closest("body").delegate(".fancybox-wrap .fancybox-inner", "click", function (event) {
                        if (data.HasLink) {
                            event.stopPropagation();
                            event.preventDefault();
                            if (data.NewTab) {
                                $.fancybox.close(true);
                                window.open(data.Link);
                            }
                            else {
                                window.location = data.Link;
                            }
                        }
                    });
                } else {
                    setTimeout(function () {
                        showPopupWindow(DataConfig);
                    }, 500);
                }


            }
            //End showPopupWindow
        }

        //Part of load in jQuery
        var loadScript = function (url, callback) {
            var script = document.createElement("script");
            script.type = "text/javascript";

            // If the browser is Internet Explorer.
            if (script.readyState) {
                script.onreadystatechange = function () {
                    if (script.readyState == "loaded" || script.readyState == "complete") {
                        script.onreadystatechange = null;
                        callback();
                    }
                };
                // For any other browser.
            } else {
                script.onload = function () {
                    callback();
                };
            }

            script.src = url;
            document.getElementsByTagName("head")[0].appendChild(script);

        };

        var expiresTime = readCookie('expires');
        var currentTime = new Date().getTime();


        //Read cookie
        function readCookie(name) {
            var nameEQ = name + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') c = c.substring(1, c.length);
                if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
            }
            return null;
        }

        //Write cookie
        function writeCookie(varFrequency) {
            var date = new Date();
            date.setTime(date.getTime());
            var expires = date.getTime() + 1000 * varFrequency * 60;
            document.cookie = "expires=" + expires;
        }

        //LOAD DEPENDENCIES
        if (window.initial) {
            initial = false;
            
            if (typeof jQuery === 'undefined') {
                var arr = $.fn.jquery.split('.');

                if (arr[0] > 1 || (arr[0] == 1 && arr[1] > 6)) {
                    loadScript('https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js', function () { });
                }
            }
            
            $.ajax({
                type: 'GET',
                url: hostSecure + 'view/setting?shop=' + GetShopName(),
                crossDomain: true,
                dataType: 'jsonp',
                jsonp: "callback",
                success: function (data) {
                    var ActivePopup = false;
                    DataConfig = data;

                    if (data.SessionPopup) {
                        if (!(Session.get("PopupWindow"))) {
                            ActivePopup = true;
                        }
                    } else {
                        if (expiresTime == null) {
                            writeCookie(data.Frequency);
                            ActivePopup = true;
                        }
                        else {
                            if (currentTime > expiresTime) {
                                ActivePopup = true;
                            }
                        }
                    }

                    var isHome = window.location.href.replace(window.location.protocol + "//", "").replace("/", "") == window.location.host;

                    if (ActivePopup && data.HomePagePopup) {
                        if (!isHome) ActivePopup = false;
                    }
                    
                    if (window.location.hash == "#reset=true") {
                        writeCookie(-1);
                        ActivePopup = true;
                    }
                    
                    if (ActivePopup) {
                        if (data.SessionPopup) Session.set("PopupWindow", true);
                        loadScript(hostSecure + 'assets/fancybox/fancybox.js', function () {
                            mainPopUpScript(jQuery);
                        });
                    }
                },
                error: function () {
                    return false;
                }
            });
        }
    })();
}();
