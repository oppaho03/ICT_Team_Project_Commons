/** 
 * Componenets scripts
 */

( function( ) {

  /* 핸들러 초기화
  */

  var _HGSAP = new HandlerGSPA( { 
    "gsap": gsap, 
    "CSSRulePlugin": CSSRulePlugin, 
    "ScrollToPlugin": ScrollToPlugin,
    "ScrollTrigger": ScrollTrigger 
  } );

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

  /* 바인드 : 폼 컨트롤 엘리멘트 초기화
  */ 
  App.prototype.binds.push( function( e ) {


  } );

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

  /* 바인드 : 'prompt' (form) 초기화 
  */ 
  App.prototype.binds.push( function( e ) {
    // 프롬프트 (prompt) : 폼 (Form)
    var prompt = document.getElementById("chat-prompt"); // <form>
    if ( ! prompt ) return;
    setEventListener( prompt, 'submit', function(e) {

      e.preventDefault(); // submit 취소

      var prompt = e.target;
      var prompt_input = prompt.querySelector("input[name='s']");
      var prompt_value = prompt_input ? prompt_input.value.trim() : "";
      
      if ( !prompt_value || prompt_value == "" ) {
        if ( prompt_input ) 
          prompt_input.focus();

        return; // end submit
      }

      /* 대화 시작 : 질문 (Question) / 답변 (Answer)
      */  
      var cs = document.getElementById("chat-session");
      var cc = cs ? cs.querySelector("#chat-content") : null; 
      
      if ( ! cc ) return;

      var temp = cc.querySelector("#chat-template");
      if ( temp ) {
        
        // document.importNode(template.content, true)
        var content = temp.content.cloneNode(true);
        content = content.querySelectorAll(".chat-wrap"); // [ 0: 봇 , 1: 사용자 ]

        if ( ! content.length ) return;

        // 아이템 생성 (chat-list-item)
        var item = document.createElement('div');
        item.classList = "chat-list-item";
        for ( var el of content  ) { 
          item.appendChild( el ); // .chat 엘리멘트 추가
        }

        var fragmentItem = document.createDocumentFragment()
        fragmentItem.append(item);

        // 채팅 리스트 (Chat List)
        var list = cc.querySelector(".chat-list");
        if ( list ) {

          list.appendChild( fragmentItem ); 
         
          var items = list.children;
          var item = Array.from(items).slice(-1)[0]; // 마지막에 추가된 아이템 선택 
          
          /* 대화 입력 : 질문 (Question)
          */ 
          var cuser = item.querySelector(".chat.type-user");
          if ( cuser ) {
            var cuser_cc = cuser.querySelector(".chat-content"); 
            var cuser_cc_msgwrap = cuser_cc.querySelector(".messages");

            var _msg = document.createElement("p");
            _msg.setAttribute( "aria-label", "message" );
            _msg.innerText = prompt_value;

            cuser_cc_msgwrap.appendChild(_msg); /// append message
          } // cuser
        }
    
        prompt_input.value = ""; /// 초기화
      }
      else return;

      /* 대화 입력 : 답변 (Question)
      */
      // prompt_value
      console.log( "request", prompt_value );
      setTimeout( function(  ) {

        /* 샘플 데이터
          * - 서버 데이터 요청 
        */ 
        var data = {
          "id" : 7,
          "fileName": "HC-A-02781336",
          "disease_category": "귀코목질환",
          "disease_name": {
              "kor": "급성 중이염",
              "eng": "Acute otitis media"
          },
          "department": [
              "이비인후과"
          ],
          "intention": "약물",
          "answer": {
              "intro": "급성 중이염의 치료는 대부분 약물을 사용하여 이루어지며, 항생제와 진통제의 사용이 필요합니다.",
              "body": "일반적으로 의사는 급성 중이염의 치료를 위해 항생제를 처방할 것입니다. 항생제는 세균 감염에 의한 경우 가장 효과적인 약물 중 하나입니다. 항생제 치료는 의사의 처방을 받고 정해진 기간 동안 지속되어야 합니다. 또한, 귀 통증을 완화하기 위해 아세트아미노펜 또는 이부프로펜과 같은 진통제를 사용할 수 있습니다. 중이 내 분비물을 관리하기 위해 이어 플러그를 사용하는 것도 중요한 치료 방법입니다.",
              "conclusion": "만약 환자의 증상이 호전되지 않거나 악화된다면 의사와 상담하여 추가적인 치료 옵션을 고려해야 합니다. 의사는 환자의 개별적인 상황을 평가하고 적절한 치료 계획을 수립할 것입니다."
          },
          "num_of_words": 88
        };

        var cs = document.getElementById("chat-session");
        var cc = cs ? cs.querySelector("#chat-content") : null; 
        
        var t = cc ? cc.querySelector(".chat.type-bot[data-status='pending']") : null; /// 'pending' 상태 채팅 선택
        if ( ! t ) return;

        // 데이터 파싱 
        t.dataset['id'] = data.id;
        t.dataset['fileName'] = data.fileName ?? '';

        var data_answer = { 
          ...{ "intro" : "", "body" : "", "conclusion" : "" }, 
          ...( data.hasOwnProperty("answer") ? data.answer : {} ) 
        };
        
        /// 답변 : type-bubble
        var msgsbub = t.querySelector(".messages.type-bubble");
        if ( msgsbub ) {
          if ( ! isUndefined( msgsbub.replaceChildren ) ) msgsbub.replaceChildren();
          else msgsbub.innerHTML = "";

          var _val = data_answer.intro; /// 답변 'intro'

          if( _val.trim() ) {
            var _msg = document.createElement("p");
            _msg.setAttribute( "aria-label", "message" );
            _msg.innerText = _val;

            msgsbub.appendChild( _msg );
          }
          else msgsbub.classList.add("d-none");
          
        } 

        /// 답변 : type-main
        var msgs = t.querySelector(".messages.type-main");
        if ( msgs ) {

          var msgsf = document.createDocumentFragment(); 

          // 답변 :  'body', 'conclusion'
          Object.entries(data_answer).forEach( function([_key, _val]) {

            if ( ['body', 'conclusion'].indexOf( _key ) === -1 ) return;

            var _msg = document.createElement("p");

            _msg.setAttribute( "aria-label", "message" );
            _msg.innerText = _val;

            msgsf.appendChild( _msg ); 
          } );

          if ( ! isUndefined( msgs.replaceChildren ) ) msgs.replaceChildren();
          else msgs.innerHTML = "";

          msgs.appendChild( msgsf );

          /// 답변 :  'conclusion'

        }

        t.dataset['status'] = "fulfilled"; /// 상태 변경 (pending -> fulfilled)
        
      }, 3000 );

      
    }, {} );

    // 프롬프트 (prompt) : 입력창 
    var input = prompt.querySelector("input[name='s']");

    // 프롬프트 (prompt) : 입력창 'focus' / 'blur'
    for( var _type of ["focus", "blur"] ) {

      setEventListener( input, _type, function(e) {

        var self = this;
        var e_type = e.type;

        // 채팅 프롬프트 : 폼(form)
        var form = self.closest( "#chat-prompt" );
        if ( form.classList.contains( 'activated' ) ) return; 

        // .form-wrap#chat-content-bar
        var wrap = form.closest(".form-wrap");
        var cbef = wrap ? wrap.querySelector(".form-before") : null;
        var caft = wrap ? wrap.querySelector(".form-after") : null;

        if ( e_type.toLowerCase() == "focus" ) {
          // on focus
          if ( wrap && ! wrap.classList.contains("focused") ) wrap.classList.add("focused");

          if ( cbef ) { 

            // 헤드라인 (Headline)
            var hl = cbef.querySelector(".headline"); // headline
            var el = hl.nextElementSibling;
            while ( el != null ) {

              if ( ! el.querySelector("span") )  
                el.innerHTML = toSpannedLine(el.textContent);

              /* GSPA 애니메이션 정의 */
              if ( _HGSAP.enabled() ) {

                var _items = el.querySelectorAll("span");

                gsap.to( _items , {
                  ease: "power1.inOut",
                  delay: 0.3,
                  duration: 0.6, 
                  opacity: 0,
                  y: '-0.5em',
                  stagger: { amount: 0.3, from: "start" }
                });
              }
              else el.style.display = 'none';

              el = el.nextElementSibling;
            } // while ( el != null )

          } // cbef
          
        }
        else if ( e_type.toLowerCase() == "blur" ) {
          // on blur
          if ( wrap && wrap.classList.contains("focused") ) wrap.classList.remove("focused");

          if ( cbef ) {
            // 헤드라인 (Headline) 
            var hl = cbef.querySelector(".headline"); // headline
            var el = hl.nextElementSibling;
            while ( el != null ) {

              var _items = el.querySelectorAll("span");

              /* GSPA 애니메이션 정의 */
              if ( _HGSAP.enabled() ) {

                var _items = el.querySelectorAll("span");

                gsap.to( _items , {
                  ease: "power1.inOut",
                  duration: 0.6, 
                  opacity: 1,
                  y: 0,
                  stagger: { amount: 0.3, from: "start" }
                });
              }
              else el.style.display = 'block';

              el = el.nextElementSibling;
            } // while ( el != null )

          } // cbef
        }

      }, { capture: false, passive: true } );

    } // for( var _type of ["focus", "blur"] ) 

    // 프롬프트 (prompt) : 입력창 'keydown'
    setEventListener( input, 'keydown', function(e) {
      var self = this;
      var key = (String)(e.key || e.code).toLowerCase();

      // 채팅 프롬프트 : 폼(form)
      var form = self.closest( "#chat-prompt" );
      if ( form ) {
        var activated = form.classList.contains( "activated" );
        if ( ! activated ) {
          
          /* GSPA 애니메이션 정의 */
          if ( _HGSAP.enabled() ) { 

            var filters = [];

            for ( var cnt of form.querySelectorAll(".form-filter") ) {
              filters = filters.concat( Array.from( cnt.querySelectorAll( ".form-control, form-select, .form-switch" ) ) );
            }

            if ( filters.length ) {

              var attrs = {
                opacity: 0, 
                y: '100%',
                scale: 0.5
              }
              gsap.set( filters, attrs );

              attrs = Object.assign( attrs, {
                opacity: 1,
                y: 0,
                scale: 1,
                duration: 1,
                delay: 0.6,
                ease: "bounce.out",
                stagger: { amount: 0.5, from: "start" }
              } );

              gsap.to( filters , attrs );
            } // if ( filters.length )
            
          } // GSPA 애니메이션 정의 

          var formwrap = form.closest(".form-wrap");
          if ( formwrap ) formwrap.style.bottom =  (form.clientHeight / 2) + 'px';

          form.classList.add( "activated" ); // "activated" 토글
        } // "activated" 토글
      }

      // 채팅 컨텐츠 영역 
      var cc = document.getElementById("chat-content");
      var ccList = cc ? cc.querySelector(".chat-list") : null;
      if ( ccList ) {

        // 초기 대화(chat) d-none 해제
        for( var item of ccList.querySelectorAll(".chat-list-item.d-none") ) { item.classList.remove('d-none'); }


      } // ccList
 
      var expts = [ "enter", "escape" ]; // 예외 키
      if ( ! expts.includes( key ) ) return;

      switch ( key ) {
        case "enter" :
          // pass
          break;
        
        case "escape" :
          self.value = "";
          break;

      }

    }, { capture: false, passive: true } ); 
    

    // 프롬프트 (prompt) 필터 : 셀렉트
    var filters = prompt.querySelectorAll( 
      [ ".form-control", ".form-select" ]
      .map( function( val ) { return ".form-filter " + val; } )
      .join(",")
    );

    Array.from(filters).forEach( function(el) {

      if ( el.classList.contains( "form-select" ) ) { // : <select>

        var input = el.querySelector("select");
        if ( ! input ) return; 

        setEventListener( input, 'change', function(e) {
          
          var t = e.target; 
          var name = t.name;
          var value = t.value;

          var txt = t.options[t.selectedIndex].text;

          if ( ['department', 'disease'].indexOf( name ) !== -1 ) {

            // 진료과목 -> 질병종류 목록 갱신
            if ( name == "department" ) { // 진료과목 

              /* 샘플 데이터
               * - 서버 데이터 요청 
              */ 
              var _datas = {
                "dep1": {
                  "dis11": "HIV 감염",
                  "dis12": "결핵",
                  "dis13": "곰팡이 감염",
                  "dis14": "말라리아",
                  "dis15": "발진티푸스",
                },
                "dep2": {
                  "dis21": "고막염",
                  "dis22": "난청",
                  "dis23": "만성 비염",
                  "dis24": "수면 무호흡증",
                },
                "dep3": {
                  "dis31": "괴혈병",
                  "dis32": "납 중독",
                  "dis33": "대사 증후군",
                  "dis34": "비만",
                  "dis35": "춘곤증",
                },
              } // _data
  
              /// 질병종료 셀렉트 불러오기
              var sel = t.closest("form").querySelector("select[name='disease']");
              if ( sel )  {
  
                sel.innerHTML = '<option value="">전체</option>';
  
                if ( _datas.hasOwnProperty(value) ) {
  
                  Object.entries(_datas[value]).forEach( function([_key, _val]) {
  
                    var _opt = document.createElement( "option" );
                    _opt.value = _key;
                    _opt.textContent = _val;
  
                    sel.appendChild( _opt );
  
                  }); 
  
                }
                
  
              } // if (sel)
  
              console.log( txt );
  
            }

          } // 진료과목, 질병종류

        }, { capture: false, passive: false } );

      }
      else return;

    } );


    // if ( filters.length ) {

    //   var attrs = {
    //     opacity: 0, 
    //     y: '100%',
    //     scale: 0.5
    //   }
    //   gsap.set( filters, attrs );

    //   attrs = Object.assign( attrs, {
    //     opacity: 1,
    //     y: 0,
    //     scale: 1,
    //     duration: 1,
    //     delay: 0.6,
    //     ease: "bounce.out",
    //     stagger: { amount: 0.5, from: "start" }
    //   } );

    //   gsap.to( filters , attrs );

    //////
   

    // 프롬프트 (prompt) 버튼 (submit)
    var btn = prompt.querySelector("button[type='submit']");
    setEventListener( btn, 'click', function(e) {
        
    }, { capture: false, passive: false } );
  });

  // new Swiper('.swiper', {
  //   slidesPerView: 2,
  //   spaceBetween: 30,
  //   centeredSlides: false,
  //   loop: true,
  //   // If we need pagination
  //   pagination: {
  //     el: '.swiper-pagination',
  //     clickable: true,
  //   },

  //   // Navigation arrows
  //   navigation: {
  //     nextEl: '.swiper-button-next',
  //     prevEl: '.swiper-button-prev',
  //   },
  // });

  
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

