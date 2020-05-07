$(function()
{
    window.addEventListener('message', function(event)
    {
        // array . {} {} {} where [0] = {name, value}, [1] = {name, value}
        var item = event.data;
        var buf = $('#wrap');
        
        if ($('.heading').length == 0) {
            // buf.find('table').append("<tr class=\"heading\"><th>ID</th><th>Name</th><th>Kills</th><th>Deaths</th><th>Money</th><th>Time</th></tr>");
            buf.find('#ptbl').append("<tr class=\"heading\"><th>ID</th><th>Name</th><th>Kills</th><th>Deaths</th><th>Money</th><th>Time</th></tr>");
            
            $('#top-kills').append('<tr class="heading"><th></th><th>TOP _KILLS_</th><th></th></tr>');
            $('#top-deaths').append('<tr class="heading"><th></th><th>TOP DEATHS</th><th></th></tr>');
            $('#top-time').append('<tr class="heading"><th></th><th>TOP TIME</th><th></th></tr>');
            
        }

        if (item.meta && item.meta == 'close')
        {
            document.getElementById("ptbl").innerHTML = "";
            document.getElementById("top-kills").innerHTML = "";
            document.getElementById("top-deaths").innerHTML = "";
            document.getElementById("top-time").innerHTML = "";
            $('#main').hide();
            return;
        }
        
        if (item.meta && item.meta == 'move') {
            if(item.direction) {
                var pos = $('#wrap').scrollTop();

                if (item.direction == 'top')
                    $('#wrap').scrollTop(pos - 100);
                else 
                    $('#wrap').scrollTop(pos + 100);
            }
        }
        // buf.find('table').append(item.text);
        buf.find('#ptbl').append(item.text);
        $('#top-kills').append(item.tKills);
        $('#top-deaths').append(item.tDeaths);
        $('#top-time').append(item.tTime);
        $('#main').show();
    }, false);
});