var blackmoney = false;
var isEngineOn = false;

$(document).ready(function() {
    window.addEventListener("message", function(event) {


        if (event.data.action == "setMoney") {
            setGeld(event.data.money);
            $(".money").show();
            $("money").show();
        };
        if (event.data.action == "showHud") {
            $('#ui').show();
        };
        if (event.data.action == "hideHud") {
            $('#ui').hide();
        };

        if (event.data.action == "setFunk") {
            if (event.data.val) {
                $(".icon-funk").css("color", "#fff");

            } else {
                $(".icon-funk").css("color", "#F7A2F3");
            }

            if (event.data.funk !== "" && event.data.funk !== undefined && (typeof event.data.funk == "string")) {
                $("#funktxt").text(event.data.funk + " MHz")
            } else {
                $("#funktxt").text("")
            }
        };

        if (event.data.action == "setVoiceLevel") {
            if (event.data.level == 1) {
                $(".level-1").show();
                $(".level-2").hide();
                $(".level-3").hide();
            } else if (event.data.level == 2) {
                $(".level-1").show();
                $(".level-2").show();
                $(".level-3").hide();
            } else if (event.data.level == 3) {
                $(".level-1").show();
                $(".level-2").show();
                $(".level-3").show();
            }
        };


        // TALK
        if (event.data.action == "setVoiceTalking") {
            document.documentElement.style.setProperty("--mic-color", event.data.val ? "#fff" : "#F7A2F3");
        };

        // MUTED NONMUTED
        if (event.data.action == "muted") {
            document.documentElement.style.setProperty("--mic-color", "#ff0000");
        };

        if (event.data.action == "nomuted") {
            document.documentElement.style.setProperty("--mic-color", "#F7A2F3");
        };

        if (event.data.action == "togglehud") {
            $('#ui').fadeToggle()
        }
    });
});

function setGeld(anzahl) {
    document.getElementById("geld").innerHTML = new Intl.NumberFormat('de-DE').format(anzahl) + " $";

}