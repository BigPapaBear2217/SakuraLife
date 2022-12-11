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
				$.post('http:///bloodline-animationsrad/escape', JSON.stringify({}));
			}
		});
    });
});


		$(document).keyup(function (e) {
			if (e.keyCode === 90) {
				if(typeb == "0"){
				$.post('http:///sakura_animation/ichhabgarnixgemacht', JSON.stringify({}));
				$('body').css('display', 'none');
				typeb = "0"
				}
				if(typeb == "1"){
				$.post('http:///sakura_animation/escape', JSON.stringify({}));
				$('body').css('display', 'none');
				typeb = "0"
				}
				if(typeb == "2"){
				$.post('http:///sakura_animation/anlehnen', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "3"){
				$.post('http:///sakura_animation/arme', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "4"){
				$.post('http:///sakura_animation/kniehen', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "5"){
				$.post('http:///sakura_animation/ergeben', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "6"){
				$.post('http:///sakura_animation/sitzen', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "7"){
				$.post('http:///sakura_animation/doggym', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "8"){
				$.post('http:///sakura_animation/dance', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "9"){
				$.post('http:///sakura_animation/doggyf', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "10"){
				$.post('http:///sakura_animation/bewusst', JSON.stringify({}));
				typeb = "0"
				}
				if(typeb == "11"){
				$.post('http:///sakura_animation/superman', JSON.stringify({}));
				typeb = "0"
				}
			}
		});

document.getElementById("menu_item_1").onmouseover = function() {mouseOver('1')};
document.getElementById("menu_item_1").onmouseout = function() {mouseOut('1')};

document.getElementById("menu_item_2").onmouseover = function() {mouseOver('2')};
document.getElementById("menu_item_2").onmouseout = function() {mouseOut('2')};

document.getElementById("menu_item_3").onmouseover = function() {mouseOver('3')};
document.getElementById("menu_item_3").onmouseout = function() {mouseOut('3')};

document.getElementById("menu_item_4").onmouseover = function() {mouseOver('4')};
document.getElementById("menu_item_4").onmouseout = function() {mouseOut('4')};

document.getElementById("menu_item_5").onmouseover = function() {mouseOver('5')};
document.getElementById("menu_item_5").onmouseout = function() {mouseOut('5')};

document.getElementById("menu_item_6").onmouseover = function() {mouseOver('6')};
document.getElementById("menu_item_6").onmouseout = function() {mouseOut('6')};

document.getElementById("menu_item_7").onmouseover = function() {mouseOver('7')};
document.getElementById("menu_item_7").onmouseout = function() {mouseOut('7')};

document.getElementById("menu_item_8").onmouseover = function() {mouseOver('8')};
document.getElementById("menu_item_8").onmouseout = function() {mouseOut('8')};

document.getElementById("menu_item_9").onmouseover = function() {mouseOver('9')};
document.getElementById("menu_item_9").onmouseout = function() {mouseOut('9')};

document.getElementById("menu_item_10").onmouseover = function() {mouseOver('10')};
document.getElementById("menu_item_10").onmouseout = function() {mouseOut('10')};

document.getElementById("menu_item_11").onmouseover = function() {mouseOver('11')};
document.getElementById("menu_item_11").onmouseout = function() {mouseOut('11')};



function mouseOver(type) {
    if(type == "1"){
		typeb = "1"
        document.getElementById("menu_text_1").style.display = "block";
    } else if(type == "2"){
		typeb = "2"
        document.getElementById("menu_text_2").style.display = "block";
    }else if(type == "3"){
		typeb = "3"
        document.getElementById("menu_text_3").style.display = "block";
    }else if(type == "4"){
		typeb = "4"
        document.getElementById("menu_text_4").style.display = "block";
		type = "0"
    }else if(type == "5"){
		typeb = "5"
        document.getElementById("menu_text_5").style.display = "block";
    }else if(type == "6"){
		typeb = "6"
        document.getElementById("menu_text_6").style.display = "block";
    }else if(type == "7"){
		typeb = "7"
        document.getElementById("menu_text_7").style.display = "block";
    }else if(type == "8"){
		typeb = "8"
        document.getElementById("menu_text_8").style.display = "block";
    }else if(type == "9"){
		typeb = "9"
        document.getElementById("menu_text_9").style.display = "block";
    }else if(type == "10"){
		typeb = "10"
        document.getElementById("menu_text_10").style.display = "block";
    }else if(type == "11"){
		typeb = "11"
        document.getElementById("menu_text_11").style.display = "block";
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
        document.getElementById("menu_text_2").style.display = "none";
    }else if(type == "3"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_3").style.display = "none";
    }else if(type == "4"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_4").style.display = "none";
    }else if(type == "5"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_5").style.display = "none";
    }else if(type == "6"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_6").style.display = "none";
    }else if(type == "7"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_7").style.display = "none";
    }else if(type == "8"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_8").style.display = "none";
    }else if(type == "9"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_9").style.display = "none";
    }else if(type == "10"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_10").style.display = "none";
    }else if(type == "11"){
		typeb = "0"
		type = "0"
        document.getElementById("menu_text_11").style.display = "none";
    }
}

function mouseClick(a) {
    let ID = a.id;
    if(ID == 1){
	$.post('http:///sakura_animation/escape', JSON.stringify({}));
	}
	if(ID == 2){
	$.post('http:///sakura_animation/anlehnen', JSON.stringify({}));
	}
	if(ID == 3){
	$.post('http:///sakura_animation/arme', JSON.stringify({}));
	}
	if(ID == 4){
	$.post('http:///sakura_animation/kniehen', JSON.stringify({}));
	}
	if(ID == 5){
	$.post('http:///sakura_animation/ergeben', JSON.stringify({}));
	}
	if(ID == 6){
	$.post('http:///sakura_animation/sitzen', JSON.stringify({}));
	}
	if(ID == 7){
	$.post('http:///sakura_animation/doggym', JSON.stringify({}));
	}
	if(ID == 8){
	$.post('http:///sakura_animation/dance', JSON.stringify({}));
	}
	if(ID == 9){
	$.post('http:///sakura_animation/doggyf', JSON.stringify({}));
	}
	if(ID == 10){
	$.post('http:///sakura_animation/bewusst', JSON.stringify({}));
	}
	if(ID == 11){
	$.post('http:///sakura_animation/superman', JSON.stringify({}));
	}
}
