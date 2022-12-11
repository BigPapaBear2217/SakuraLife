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
                $(".icon-funk").css("color", "#f7a2f3");

            } else {
                $(".icon-funk").css("color", "#353535");
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
            document.documentElement.style.setProperty("--mic-color", event.data.val ? "#f7a2f3" : "#353535");
        };

        // MUTED NONMUTED
        if (event.data.action == "muted") {
            document.documentElement.style.setProperty("--mic-color", "#ff0000");
        };

        if (event.data.action == "nomuted") {
            document.documentElement.style.setProperty("--mic-color", "#353535");
        };

        if (event.data.action == "togglehud") {
            $('#ui').fadeToggle()
        }
    });
});

function setGeld(anzahl) {
    document.getElementById("geld").innerHTML = new Intl.NumberFormat('de-DE').format(anzahl) + " $";

}