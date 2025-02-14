/** 
 * Componenets scripts
 */

( function( ) {

  /* App 객체 
  */ 
  var App = function () {
    this.binds;
    this.resizes;
    this.scrolls;
  }

  App.prototype.binds = []
  App.prototype.resizes = []
  App.prototype.scrolls = []

  /* 바인드 : Drawable Menu(사이드 메뉴) 토글 버튼 
  */ 
  App.prototype.binds.push( function( e ) {

    // 토글 버튼( <button> )
    var btn = document.getElementById("drawable-menu-toggle");
    if ( ! btn ) return; 

    setEventListener( btn, 'click', function(e) {
      var t = e.target; // or this 

      t.classList.toggle('opened'); // 'opended' toggled 
      
      var toggled = t.classList.contains('opened');
      t.setAttribute( 'aria-expanded', toggled );

      

    }, { capture: true, passive: true } );

    // 체크박스( <input> )
    var sw = document.getElementById( "drawable-menu-switch" );

    setEventListener( sw, 'change', function(e) {
      var t = e.target; // or this 

      var checked = t.checked ?? false;
      console.log(checked);

      // <button> 선택
      var btn = document.getElementById("drawable-menu-toggle");
      if ( btn ) {
        btn.click();
      }
      

    }, { capture: true, passive: true } );

  } );
  
  
  var __APP = new App();
    
  /* window event bind object
  */
  setEventListener( window, "load", function (e) {

    for ( var cb of __APP.binds ) {
      cb(e);
    }

  }, { once: true, passive: true } );
  setEventListener( window, "resize", function(e) {
    
    for ( var cb of __APP.resizes ) {
      cb(e);
    }

  }, { capture: true, passive: true } );
  setEventListener( window, "scroll", function(e) {
    
    for ( var cb of __APP.scrolls ) {
      cb(e);
    }

  }, { capture: true, passive: true } );



} () )

