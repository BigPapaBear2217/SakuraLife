let typeb = "0"
$(document).ready(function () {
	
    window.addEventListener("message", function (event) {
        if (event.data.action == "open") {
            $('body').show();
        };

        if (event.data.action == "close") {

            $("body").hide();

        };
		$(document).keyup(function (e) {
			if (e.key === "Escape") {
				$('body').css('display', 'none');
				$.post('http:///sakura_carmenu/escape', JSON.stringify({}));
			}
		});
    });
});


		$(document).keyup(function (e) {
			if (e.keyCode === 88) {
				if(typeb == "0"){
				$.post('http:///sakura_carmenu/ichhabgarnixgemacht', JSON.stringify({}));
				$('body').css('display', 'none');
				typeb = "0"
				}
				if(typeb == "1"){
				$.post('http:///sakura_carmenu/escape', JSON.stringify({}));
				$('body').css('display', 'none');
				typeb = "0"
				}
				if(typeb == "2"){
				$.post('http:///sakura_carmenu/Autoaufundzu', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "3"){
				$.post('http:///sakura_carmenu/Motor', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "4"){
				$.post('http:///sakura_carmenu/Radio', JSON.stringify({}));
				typeb = "0"
				}
			}
		});

document.getElementById("menu_item_1").onmouseover = function() {mouseOver('1')};
document.getElementById("menu_item_1").onmouseout = function() {mouseOut('1')};

document.getElementById("menu_item_4").onmouseover = function() {mouseOver('2')};
document.getElementById("menu_item_4").onmouseout = function() {mouseOut('2')};

document.getElementById("menu_item_5").onmouseover = function() {mouseOver('3')};
document.getElementById("menu_item_5").onmouseout = function() {mouseOut('3')};

document.getElementById("menu_item_8").onmouseover = function() {mouseOver('4')};
document.getElementById("menu_item_8").onmouseout = function() {mouseOut('4')};




function mouseOver(type) {
    if(type == "1"){
		typeb = "1"
        document.getElementById("menu_text_1").style.display = "block";
    } else if(type == "2"){
		typeb = "2"
        document.getElementById("menu_text_4").style.display = "block";
    }else if(type == "3"){
		typeb = "3"
        document.getElementById("menu_text_5").style.display = "block";
    }else if(type == "4"){
		typeb = "4"
        document.getElementById("menu_text_8").style.display = "block";
		type = "0"
    }
}

function mouseOut(type) {
    if(type == "1"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_1").style.display = "none";
    } else if(type == "2"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_4").style.display = "none";
    }else if(type == "3"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_5").style.display = "none";
    }else if(type == "4"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_8").style.display = "none";
    }
}

function mouseClick(a) {
    let ID = a.id;
    if(ID == 1){
	$.post('http:///sakura_carmenu/escape', JSON.stringify({}));
	}
	if(ID == 2){
	$.post('http:///sakura_carmenu/Autoaufundzu', JSON.stringify({}));
	}
	if(ID == 3){
	$.post('http:///sakura_carmenu/Motor', JSON.stringify({}));
	}
	if(ID == 4){
	$.post('http:///sakura_carmenu/Radio', JSON.stringify({}));
	}
}
