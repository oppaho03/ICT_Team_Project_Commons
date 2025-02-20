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

  /* 바인드 : 폼 컨트롤 엘리멘트 초기화
  */ 
  App.prototype.binds.push( function( e ) {

    var sels = document.getElementsByTagName( "select" );
    Array.from( sels ).forEach( function(el) {
   
      // <Select> 복사 
      var elClone = el.cloneNode(true);

      // Wrapper 생성
      var wrap = document.createElement( "div" );
      wrap.className = "form-control-wrap";
      wrap.appendChild( elClone );

      /* <select> 인터페이스 생성
      */
      var prefix = "select-box";
      var root = document.createElement("div");
      if ( root ) {
        
        root.className = prefix;

        // 현재 값 (current)
        var cur = document.createElement( "div" );
        cur.className = `${prefix}__current`;
        cur.setAttribute('tabindex', '1'); 
        if ( cur ) {

        }
        root.appendChild(cur);

        
        // 리스트 
        var list = document.createElement( "ul" );
        list.className = `${prefix}__list`;
        if ( list ) {

          var f = document.createDocumentFragment();

          for( var opt of Array.from(elClone.options) ) {
            console.log(opt);

            var _li = document.createElement( "li" );
            
            var _lb = document.createElement( "label" );
            _lb.className = `${prefix}__option`;            
            _lb.setAttribute( 'for', '' );            
            _lb.setAttribute( 'aria-hidden', 'aria-hidden' );
            _lb.dataset['value'] = opt.value;
            _lb.textContent = opt.textContent;

            f.appendChild(_lb);

          }

          list.appendChild( f );
        }

        root.appendChild(list);
        


      }
      wrap.appendChild( root );
      


      el.insertAdjacentElement("afterend", wrap);
      el.remove(); // deleted 

      // if ( typeof select.get !== 'undefined' ) select = select.get(0);
  
      // // <common-selectBox>
      // var selectBox = select.parentNode; 
    
      // // common-selectBox > main-selectBox
      // var main = selectBox.querySelector('.main-selectBox');
      // if ( main ) main.remove();
    
      // main = document.createElement('ul');
      // main.className = "main-selectBox"; // main-selectBox
      // main.appendChild( document.createElement('li') );
    
      // var holder = document.createElement('a');
      // holder.className = "placeholder";
      // holder.innerText = "-";
      // main.querySelector('li').appendChild(holder);
    
      // // common-selectBox > sub-selectBox
      // var sub = document.createElement('ul');
      // sub.className = "sub-selectBox";
    
      // Array.prototype.slice.call(select.options).forEach( function(option, i){
      //   var _txt = option.innerText;
      //   var _val = option.value;
    
      //   if ( i == 0 ) {
      //     holder.innerText=_txt; // init placholder text
      //     if ( option.disabled ) return;
      //   }
    
      //   var _subItem = document.createElement('li');
      //   var _contents = document.createElement('a');
      //   _contents.className = "option";
      //   if ( i == 0 ) _contents.classList.addClass = "selected";
      //   _contents.href = '#' + _val;
      //   _contents.innerText = _txt;
    
      //   _subItem.appendChild(_contents);
      //   sub.appendChild(_subItem); // append sub-selectBox
      // } );
    
      // main.querySelector('li').appendChild(sub); // append to main-selectBox > li
      // selectBox.append(main);
    
      // // init element(css, bind)
      // // $(sub).css("top", String($(main).height()) + "px");
      // $(sub).css("top", String($(selectBox).height()) + "px");
    
      // $(holder).off().on('click', function(e){
    
      //   // select disabled
      //   if ( $(this).closest(".common-selectBox").hasClass("disabled") ) {
      //     return false;
      //   }
    
      //   $(this)
      //   .parent("li")
      //   .children(".sub-selectBox")
      //   .stop()
      //   .slideToggle(function () {
      //     $(this).parent("li").toggleClass("on");
      //   });
          
      //   return false; // cancel href
      // });
    
      // $(sub).find('.option').off().on('click', function() {
      //   var val = this.href.substring(this.href.indexOf('#') + 1);
      //   if ( val ) val = decodeURI(val);
      //   var select = $(selectBox).find('select');
      //   if ( select ) {
      //     select.val(val);
      //     select.change();
      //   }
      //   $(holder).click(); // close select-menus
      //   return false;// cancel href
      // });
    
      // $(select).off().on('change', function() {
      //   // target == .sub-selectBox > li > a.option
      //   var val = this.value;
    
      //   var target = $(selectBox).find('.sub-selectBox a:not([href="#' + val + '"]).selected');
      //   if ( target.length ) target.removeClass('selected');
    
      //   target = $(selectBox).find('.sub-selectBox a[href="#' + val + '"]');
      //   if( target.length  && !target.hasClass('selected')) target.addClass('selected');
        
      //   holder.href = "#" + val;
      //   // holder.innerText = val ? val : target.text();
      //   holder.innerText = target.text();
        
      // }).change();

    } );

    
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
    var prompt = document.getElementById("chat-prompt");
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
      setTimeout( function( prompt_value ) {

        /// Sample data 
        console.log( "request", prompt_value );

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
    setEventListener( input, 'keydown', function(e) {
      var self = this;
      var key = (String)(e.key || e.code).toLowerCase();

      // 채팅 프롬프트 : 폼(form)
      var form = self.closest( "#chat-prompt" );

      if ( form ) {
        var activated = form.classList.contains( "activated" );
        if ( ! activated ) {
          form.classList.add( "activated" );

          var formwrap = form.closest(".form-wrap");
          if ( formwrap ) formwrap.style.bottom =  (form.clientHeight / 2) + 'px';
        }
      }

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

    // 프롬프트 (prompt) 버튼 (submit)
    var btn = prompt.querySelector("button[type='submit']");
    setEventListener( btn, 'click', function(e) {

      // var self = e.target; 
      // var expanded = self.classList.toggle("expanded") ;

      // // self.setAttribute( 'aria-expanded', expanded );

      // /// 프롬프트 (prompt) 
      // var form = self.closest('form');
      // form.classList.toggle("activated") ;
      // // if ( ! form.classList.contains("activated") ) {
      // //   form.classList.add("activated"); // 활성화
      // // }
      
      // // 채팅 컨텐츠 활성화 및 비활성화 토글 (Toggled chat content)
      // var mcnt = document.getElementById( "content" );
      // var ccnt = document.getElementById( "chat-content" );
      // if ( expanded ) {
      //   // 채팅 컨텐츠 : 활성화
      //   var prevEl = ccnt.previousElementSibling;
      //   if ( prevEl ) {
      //     // console.log(prevEl);
      //     prevEl.style.marginLeft= String(-100) + "%";
      //   }

      // }
      // else {
      //   // 채팅 컨텐츠 : 비활성화 
      // }
        
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

