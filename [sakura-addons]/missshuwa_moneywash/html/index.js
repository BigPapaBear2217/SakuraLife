$("body").hide();
window.onload = function(e) {
    window.addEventListener('message', function(event) {
        let data = event.data
       

        $("body").show();
       
    })
} 
    
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://missshuwa_moneywash/v', JSON.stringify({
         
        
            }))
     
            $("body").hide();
            return
        }
    };

 
    $("#cancel").click(function() {
    
        
        $.post('http://missshuwa_moneywash/v', JSON.stringify({
         
        
        }))
 
        $("body").hide();
    });
    
    


  
    $("#submit").click(function() {
        
        var description = document.getElementById("firstnameinput").value;
        
        $.post('http://missshuwa_moneywash/join', JSON.stringify({
            input: description
         
            
        }))
        document.getElementById('firstnameinput').value = '';
        $("body").hide();
    
        
    });

      

    $("#100000").click(function() {
        $.post('http://missshuwa_moneywash/join3', JSON.stringify({}))
        $("body").hide();
    });

    $("#1000000").click(function() {
        $.post('http://missshuwa_moneywash/join4', JSON.stringify({}))
        $("body").hide();
    });


      
 
 
    
    

    

   

 


/* 
  let input = $("#sample3").val()
        if (input.lenght == ""){
            $.post("http://missshuwa_moneywash/error", JSON.stringify({}))
            return
        } else if (!input) {
            $.post("http://missshuwa_moneywash/error", JSON.stringify({}))
            return
        }
        
        $("#box").hide();
        data = [discord,description];
        $.post('http://missshuwa_moneywash/yallah', JSON.stringify({
            text: input
        }));
        */

        