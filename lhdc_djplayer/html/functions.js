$(function () {
  let initSongs = 1 //-----------------------------NUMBER OF SONGS IN USE---------------------------------
  let listContainer = document.getElementById('list');
  for (let i = 0; i < initSongs; i++) {
    let newSong = '<div class="song amplitude-song-container amplitude-play-pause" data-amplitude-song-index="' + i + '">' +
      '<span class="song-number-now-playing">' +
      '<span class="number">' + (i+1) + '</span>' +
      '<img class="now-playing" src="https://521dimensions.com/img/open-source/amplitudejs/examples/flat-black/now-playing.svg"/>' +
      '</span>' +
      '<div class="song-meta-container">' +
      '<span class="song-name" data-amplitude-song-info="name" data-amplitude-song-index="' + i + '"></span>' +
      '<span class="song-artist-album"><span data-amplitude-song-info="artist" data-amplitude-song-index="' + i + '"></span> <span data-amplitude-song-info="album" data-amplitude-song-index="' + i + '"></span></span>' +
      '</div>' +
    '</div>';

    listContainer.innerHTML = listContainer.innerHTML + newSong
  }
  Amplitude.init({
    "bindings": {
        37: 'prev',
        39: 'next',
        32: 'play_pause'
    },
    "volume": 10,
    "default_album_art": "sounds/covers/No_cover.jpg",

//-------------------------------ADD YOUR SONGS HERE (FOLLOW THE TEMPLATE)-------------------------------
songs: [
      {
	"name": "Elektro",
	"artist": "Dynoro",
	"url": "sounds/elektro.mp3",
	"cover_art_url": "sounds/covers/elektro.jpg"
      },
],
    
    callbacks: {
      song_change: function(){
        Amplitude.setVolume(0)
        $.post("http://lhdc_djplayer/newsong", JSON.stringify({
          song: Amplitude.getActiveIndex()
        }))
        return
      },
      // play: function(){
      //   $.post('http://lhdc_djplayer/play', JSON.stringify({}));
      //   return
      // },

      // pause: function(){
      //   $.post('http://lhdc_djplayer/pause', JSON.stringify({}));
      //   return
      // },
    }
  });
  function display(bool) {
      if (bool) {
          $("#flat-black-player-container").show();
      } else {
          $("#flat-black-player-container").hide();
      }
  }
  display(false)
  window.addEventListener('message', function(event) {
      var item = event.data;
      if (item.type === "ui") {
          if (item.status == true) {
              display(true)
          } else {
              display(false)
          }
  }
  if (item.musiccommand == 'playsong') {
    if (Amplitude.getActiveIndex() !== item.songname) {
      Amplitude.setVolume(0)
      Amplitude.playSongAtIndex(item.songname)
      Amplitude.setVolume(0)
    }
  } else if (item.musiccommand == 'pause') {
    Amplitude.pause()
  } else if (item.musiccommand == 'play') {
    Amplitude.play()
  } else if (item.musiccommand == 'seek') {
    Amplitude.setSongPlayedPercentage(item.songname)
  } else if (item.setvolume !== undefined) {
  if (item.setvolume >= 0.0 && item.setvolume <= 1.0) {
    var vol = item.setvolume;
    var corrigir = vol.toFixed(2);
    var resultado = (corrigir).replace('.','');
    var menosum = (resultado).substr(1);
    Amplitude.setVolume(menosum)
    }
  }
})
  document.onkeyup = function (data) {
      if (data.key == "Escape") {
          $.post('http://lhdc_djplayer/exit', JSON.stringify({}));
          return
      }
  };
  document.getElementsByClassName('down-header')[0].addEventListener('click', function(){
      var list = document.getElementById('list');
      list.style.height = ( parseInt( document.getElementById('flat-black-player-container').offsetHeight ) - 135 ) + 'px';
      document.getElementById('list-screen').classList.remove('slide-out-top');
      document.getElementById('list-screen').classList.add('slide-in-top');
      document.getElementById('list-screen').style.display = "block";
    });
  document.getElementsByClassName('hide-playlist')[0].addEventListener('click', function(){
      document.getElementById('list-screen').classList.remove('slide-in-top');
      document.getElementById('list-screen').classList.add('slide-out-top');
      document.getElementById('list-screen').style.display = "none";
    });
    
  document.getElementById('song-played-progress').addEventListener('click', function( e ){
      var offset = this.getBoundingClientRect();
      var x = e.pageX - offset.left;
      Amplitude.setSongPlayedPercentage( ( parseFloat( x ) / parseFloat( this.offsetWidth) ) * 100 );
      $.post("http://lhdc_djplayer/seek", JSON.stringify({
        pos: ((parseFloat(x) / parseFloat(this.offsetWidth)) * 100)
    }))
    });
  document.getElementById('previous').addEventListener('click', function( e ){
      Amplitude.setVolume(0)
      $.post("http://lhdc_djplayer/newsong", JSON.stringify({
        song: Amplitude.getActiveIndex()
      }))
    });
  document.getElementById('next').addEventListener('click', function( e ){
      Amplitude.setVolume(0)
      $.post("http://lhdc_djplayer/newsong", JSON.stringify({
        song: Amplitude.getActiveIndex()
      }))
    });
  document.getElementById('play-pause').addEventListener('click', function( e ){
      let playPauseButtonClass = document.getElementById('play-pause').className
      if (playPauseButtonClass.includes("paused")) {
          $.post('http://lhdc_djplayer/pause', JSON.stringify({}));
          return
      } else {
          $.post('http://lhdc_djplayer/play', JSON.stringify({}));
          return
      }
    });
    // document.querySelector('img[data-amplitude-song-info="cover_art_url"]').style.height = document.querySelector('img[data-amplitude-song-info="cover_art_url"]').offsetWidth + 'px';
})