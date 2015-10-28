function startPlayer(start){
  setTimeout(function(){
    audio = $('#player');
    audio.load();
    if(start){
      audio[0].play();
    }
  },2000);
}
