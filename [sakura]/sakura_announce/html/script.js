var sound_effect = document.getElementById("sound-effect");

$(document).ready(function () {
	window.addEventListener("message", function (event) {
		if (event.data.action === "annouce") {
			$("#message").text(event.data.message);
			$("#annoucer").show().addClass("slide-in-top");
		} else if (event.data.action === "close") {
			$("#annoucer").fadeOut().removeClass("slide-in-top");
		}
	});
});
