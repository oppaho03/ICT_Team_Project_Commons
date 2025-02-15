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

  /* 바인드 : 'Primary' 서랍 메뉴(Drawable Menu) 토글 버튼 / 스위치(체크박스)
  */ 
  App.prototype.binds.push( function( e ) {

    // 서랍 메뉴 토글 버튼 / 스위치(체크박스) 
    var btn, sw; 

    // 서랍 메뉴 토글 스위치(체크박스) 
    // input#primary-menu-toggle
    sw = document.getElementById("drawable-menu-toggle");
    if ( sw ) {
      setEventListener( sw, 'click', function(e) {
        // 스위치 (체크박스)
        var self = e.target;

        self.classList.toggle('extend'); 
        var extend = self.classList.contains('extend');
        self.setAttribute( 'aria-expanded', extend ); // aria-expanded 속성 토글
        
        document.body.classList.toggle('expanded-menu-drawable');

      }, { capture: true, passive: true } );

    } 

    // 서랍 메뉴(Drawable Menu) 토글 버튼
    // button#mobile-drawable-menu-toggle
    btn = document.getElementById("mobile-drawable-menu-toggle");
    if ( btn ) {
      // 스위치 델리게이
      setEventListener( btn, 'click', function(e) {
        var sw = document.getElementById("drawable-menu-toggle");
        if ( sw ) sw.click();
      }, { capture: true, passive: true } );
    }

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

