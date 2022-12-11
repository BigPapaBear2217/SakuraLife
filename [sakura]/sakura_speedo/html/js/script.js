var blackmoney = false;

$(document).ready(function() {
    window.addEventListener("message", function(event) {

        if (event.data.action === 'showCar') {
            document.querySelector(".carhud").classList.remove("carhud-hidden");
            $("#geschtext").html(Math.round(event.data.showSpeed));
            $("#fueltext").html(Math.round(event.data.showFuel) + "L");
        } else if (event.data.action === 'hideCar') {
            document.querySelector(".carhud").classList.add("carhud-hidden");
        }

        if (event.data.action == "toggleEngine") {
            if (event.data.status) {
                $('#on').show()
                $('#off').hide()
            } else {
                $('#on').hide()
                $('#off').show()
            }
        } else if (event.data.action == "toggleLock") {
            if (event.data.status) {
                document.getElementById("lock").style.color = "#F7A2F3";
            } else {
                document.getElementById("lock").style.color = "#ff0000";
            }
        }

    });
});