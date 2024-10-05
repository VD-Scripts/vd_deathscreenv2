function secondsTommss(totalSeconds) {
  var hours = Math.floor(totalSeconds / 3600);
  var minutes = Math.floor((totalSeconds - (hours * 3600)) / 60);
  var seconds = totalSeconds - (hours * 3600) - (minutes * 60);
  seconds = Math.round(seconds * 100) / 100

  return (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds);
}

$(document).ready(function(){
    $(".timer").hide();
    $("#discordcopy").hide();
});

let tare
window.addEventListener("message", function(event){
  let data = event.data
  if (data.type === "open") {
    document.getElementById("background").style.display = "block";
    if(data.killer === 0) {
      document.getElementById("killername").innerHTML = "YOURSELF";
    } else {
      document.getElementById("killername").innerHTML = data.killer;
    }
    $(".timer").show();
    let timeLimit = "180s";

    let timerElement = document.getElementById("timer"), time = 180;
    tare = setInterval(function() {
      timerElement.innerHTML = secondsTommss(time);
      time--;
      if (time < 0) {
        window.clearInterval(tare);
        timerElement.innerHTML = '!';
        Respawn();
        $(".timer").fadeOut("300ms");
        $(".text3").fadeOut("300ms");
      }
    }, 1000);
    
  }
  if (data.type === "hide") {
    let timerElement = document.getElementById("timer");
    clearInterval(tare);
    timerElement.innerHTML = '!';

    document.getElementById("background").style.display = "none";
    $(".timer").hide();
    $("#discordcopy").hide();
  }
  if (data.type === "updateName") {
    document.getElementById("killername").innerHTML = data.killernervos;
  }
});

document.onkeyup = function(data){
    // H
	if (data.which === 72){ 
		CallAdmin();
    // R
	} else if (data.which === 82) {
        Respawn();
    }
};

function copyToClipboard(element) {
  var $temp = $("<input>");
  $(".background").append($temp);
  $temp.val($(element).text()).select();
  document.execCommand("copy");
  $temp.remove();
}

function CallAdmin() {
  $.post('http://vd_deathscreenv2/calladmin', JSON.stringify({}));
}
function Respawn() {
  $.post('http://vd_deathscreenv2/respawn', JSON.stringify({}));
}