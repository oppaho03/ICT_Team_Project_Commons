/** 
 * 핸들러 스크립트 : GSAP
 * - https://gsap.com/docs/v3/Eases/
 */

class HandlerGSPA {

  moduels = {
    "CSSRulePlugin": 0,
    "CustomEase": 0,
    "Draggable": 0,
    "EaselPlugin": 0,
    "EasePack": 0,
    "Flip": 0,
    "gsap": 0,
    "MotionPathPlugin": 0,
    "Observer": 0,
    "PixiPlugin": 0,
    "ScrollToPlugin": 0,
    "ScrollTrigger": 0,
    "CSSRulePlugin": 0,
    "TextPlugin": 0
  };

  /**
   * 생성자
   * @returns 
   */
  constructor( params = {} ) {  
    // super()

    if ( ! params.gsap || typeof params.gsap == "undefined" ) return; 
    const moduels = Object.assign( { ...{}, ...this.moduels }, params ); 

    /* "GSAP" 플러그인 등록
    */
    Object.entries(moduels).forEach( function([key, value]) {

      if ( value && typeof value != "undefined" ) {
        gsap.registerPlugin( value );
        moduels[key] = 1;
      }
      else moduels[key] = 0;

    } );

    this.moduels = moduels; // updated modules

  } // constructor ()

  /**
   * 플러그인 초기화 
   * @returns 
   */
  reset() {
    if ( ! this.enabled() ) return;

    const moduels = this.moduels;

    Object.entries(moduels).forEach( function([key, value]) {

      if ( ! value ) return; 

      switch( key ) {
       
        case "gsap": // "gsap" 초기화 
          gsap.defaults({ duration: 1, ease: "power1.out" });
        break;

        case "ScrollTrigger": // "ScrollTrigger" 초기화
          ScrollTrigger.defaults({
            toggleActions: "restart pause resume pause",
            markers: false,
            scrub: true,
            pin: false,	
            pinSpacing: false,
          });
        break;
      }

       /// ScrollTrigger.refresh();

    }); // end forEach

  } // reset()

  /**
   * "gsap" 오브젝트 가져오기
   * @returns {object}
   */
  get() {
    return this.enabled() ? gsap : null; 
  }

  /**
   * 핸들러 사용 유무
   * @returns {boolean}
   */
  enabled() {
    return this.moduels['gsap'] ? true : false;
  }

  /**
   * 플러그인 등록 확인
   * @param {string} name - 플러그인 이름
   * @returns {boolean}
   */
  hasPlugin( name ) {
    if ( ! this.enabled() ) return false;
    else name = name.toLowerCase().replace( /plugin\b/g, "" );

    for (const pname in gsap.plugins) {
      if ( pname.toLowerCase() == name ) return true;
    }

    return false;
  } 

  /**
   * 옵션 템플릿(Option Template) 불러오기 
   * @param {string} name 
   * @param {object} params 
   * @returns {object | null}
   */
  getOptionTemplate( name, params ) {
    if ( ! this.enabled() ) return null;
    else if ( ! params || typeof params == "undefined" ) params = {};
    
    let options = {};

    switch( name.toLowerCase() ) {
      case "scrolltrigger": 
        options = {
          id: null,
          markers: false, 
          trigger: null,
          start: "top top",
          end: "bottom top",
          scroller: null,
          scrub: false,
          pin: false,
          pinSpacing: false,
          toggleId: null,
          toggleClass: null,
          horizontal: false,
          refreshPriority: 0, 
          anticipatePin: 0,
          snap: false,
          invalidateOnRefresh: false,
          fastScrollEnd: true,
          animation: null,
          once: false,
          onLeaveBack: null,
          onLeave: null,
          onEnterBack: null,
          onEnter: null,
          onUpdate: null,
          onToggle: null,
          endTrigger: null,
          onRefresh: null,
          onRefreshInit: null
        };
      break;

      case "timeline":
        options = {
          defaults: null,  
          repeat: 0,
          repeatDelay: 0, 
          paused: false, 
          yoyo: true,
          timeScale: 1, 
          onRepeat: null,
          onStart: null,
          onUpdate: null,
          onComplete: null,
        }
      break;
    }

    return { ...options, ...params };
  } // getOptionTemplate( ... )





}