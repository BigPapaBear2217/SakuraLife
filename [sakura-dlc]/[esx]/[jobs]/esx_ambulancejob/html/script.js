window.addEventListener('message', (event) => {
    let data = event.data

    if (data.action == "showdeathscreen") {
        $('body').fadeIn(250);
        $('.dispatchtext').fadeIn(250);
	} 
    if (data.action == "hide") {
        $('body').fadeOut(250);
    }
    if (data.action == "hidedispatch") {
        $('.dispatchtext').fadeOut(250);
    }
    if (data.action == "updatetime") {
        $('#timedata').html(data.remainingseconds);
        $('#textdata').html(data.text);
        $('#textdata2').html(data.text2);
    }
});