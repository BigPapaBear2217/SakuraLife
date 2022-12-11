  
window.addEventListener("message", (event) => {
    var item = event.data;
    if (item !== undefined && item.type === "custom") {     
        const content = $(
            `
            <div class="notification">
            <div class="notification-title">
            <p style="color: ` + item.color + `">` + item.title + `</p>
            </div>
            <p id="message">
            ` + item.message.replaceAll('~r~','<a style="color: #db2a91;">')
            .replaceAll('~g~','<a style="color: green;">')
            .replaceAll('~b~','<a style="color: blue;">')
            .replaceAll('~y~','<a style="color: yellow;">')
            .replaceAll('~p~','<a style="color: purple;">')
            .replaceAll('~c~','<a style="color: grey;">')
            .replaceAll('~m~','<a style="color: darkgrey;">')
            .replaceAll('~u~','<a style="color: black;">')
            .replaceAll('~o~','<a style="color: orange;">')

            .replaceAll('~n~','<p>')
            .replaceAll('~s~','<a style="color: white;">')
            .replaceAll('~h~','')
             + `
            </p>
            </div>
            `
            )

            
          content.fadeIn();
      $("#notifications").prepend(content);
  
      setTimeout(() => {
        content.fadeOut();
      }, 9000)
    }
});