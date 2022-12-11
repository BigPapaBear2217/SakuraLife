$("#box").hide();

window.onload = function(e) {
    window.addEventListener('message', function(event) {
        let data = event.data
        $("#box").show();
       //  document.getElementById("title").textContent = data.title;
    })
} 

    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://sakura_name/exit', JSON.stringify({}));
            return
        }
    };

    $("#close").click(function () {
        $.post('http://sakura_name/exit', JSON.stringify({}));
        return
    })

    $("#cancel").click(function() {
        $("#box").hide();
        $.post("http://sakura_name/exit", JSON.stringify({
    
        }));
    });
    
    //when the user clicks on the submit button, it will run
    $("#submit").click(function () {
        let firstname = $("#firstnameinput").val()
        let lastname = $("#lastnameinput").val()
    
        // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
        $("#box").hide();
        $.post('http://sakura_name/join', JSON.stringify({
            vorname: firstname,
            nachname: lastname,
            
        }));
      //  $("body").hide();
    })

   





