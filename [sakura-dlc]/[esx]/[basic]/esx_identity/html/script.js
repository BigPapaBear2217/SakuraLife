$(function () {
	window.addEventListener("message", function (event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27) {
			// Escape key
			$.post("http://esx_identity/escape", JSON.stringify({}));
		}
	};

	$("#register").submit(function (event) {
		event.preventDefault(); // Prevent form from submitting

		// Verify date
		var date = $("#dateofbirth").val();
		var dateCheck = new Date($("#dateofbirth").val());

		if (dateCheck == "Invalid Date") {
			date == "invalid";
		}

		if (
			(document.getElementById("f").checked == true &&
				document.getElementById("m").checked == true) ||
			(document.getElementById("m").checked == false &&
				document.getElementById("f").checked == false)
		) {
			return;
		}

		var gender = "";

		if (document.getElementById("f").checked == false) {
			gender = "m";
		} else {
			gender = "f";
		}

		$.post(
			"http://esx_identity/register",
			JSON.stringify({
				firstname: $("#firstname").val(),
				lastname: $("#lastname").val(),
				dateofbirth: date,
				sex: gender,
				height: $("#height").val(),
			})
		);
	});
});
