/** 
 * Global commons valiables or functions scripts
 */

if ( typeof $ == "undefined" && typeof jQuery != "undefined" ) var $ = jQuery.noConflict();



/**
 * PC / 모바일 식별하기 
 * @return {boolean}
 */
function isPC () {
  if ( /Mobile|Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) return false;
  else return true;
}

/**
 * 변수 또는 함수, 객체 등등 'undefined' 체크하기 
 * @param { any } value - all type values
 * @return { boolean }
 */
function isUndefined ( value ) {
  return typeof value == "undefined" ? true : false;
}

/**
 * 변수의 값이 유효한지 확인 
 * @param { any } value - object | undefined | boolean | number | bigint | string | symbol ...
 * @return { boolean }
 */
function isset ( value ) {
  return typeof value != "undefined" && value != null && value.trim() != "" ? true : false;
}

/**
 * URL 쿼리 파싱 (Parsing URL query string)
 * @param {string} search_key 
 * @param {null|string} url 
 * @return { SVGStringList }
 */
function getURIQuery (search_key, url) {
	// get current url
	if ( !url || typeof url === undefined ) url = document.location.href;
	
	// remove to '#(sharp)'
	if ( url.indexOf('#') !== -1 ) url = url.slice(0, url.indexOf('#'));
	var querys = (url.slice(url.indexOf("?") + 1, url.length)).split('&');

	var result; // find result value

	for ( var i in querys ) {
		var [key, value] =  querys[i].split('=');
		if ( typeof value == 'undefined' ) value = '';

		if ( key == search_key ) {
			result = value; // set result value
			break;
		}
	}

	return result ? result : '';
}



/**
 * Fetch [ GET / JSON ]
 * @param { string } url 
 * @param { Object } params
 * @param { function } cb_success 
 * @param { function } cb_error
 */
function fetchGetJSON ( url, params, cb_success = null, cb_error = null ) {
  /* ex. headers 
    headers: { 
      "Content-Type": "application/json", 
      "Authorization": "Bearer YOUR_ACCESS_TOKEN" 
    }
  */
  var defs = { method: "GET" };

  fetch( 
    url, 
    Object.assign( {}, defs, params ) 
  )
  .then( response => response.json() )
  .then( data => cb_success ? cb_success(data) : console.log(data) )
  .catch( err => cb_error ? cb_error(err) : console.error("Error:", err) );
}

/**
 * 
 */
async function fetchGetJSONAsync( url, params, cb_success = null, cb_error = null ) {

  try {
    
  }
  catch (error) {
  }

}


// async function getData() {
//   try {
//     const response = await fetch("https://jsonplaceholder.typicode.com/posts/1", {
//       method: "GET",
//       headers: {
//         "Content-Type": "application/json", // JSON 데이터 요청
//         "Authorization": "Bearer YOUR_ACCESS_TOKEN" // 인증 토큰 (필요한 경우)
//       }
//     });

//     const data = await response.json();
//     console.log(data);
//   } catch (error) {
//     console.error("Error:", error);
//   }
// }

// getData();

// getData();



/*--------------------------------------------------------------
 * 'String' Functions 
--------------------------------------------------------------*/

/**
 * 문자열을 글자 단위로 자르고 <span /> 테그에 넣는 함수
 * @param {string} value - 파싱 대상 문자열
 * @return {string} 
 */
function toSpannedLine ( value ) {

  var value = value.replace(/<(?!br\s*\/?)[^>]+>/gi, ''); // 모든 HTML 태그 제거, <br> 제외
  if ( ! value || value.trim() != '' ) return ''

  var lines = value.split( /<br\s*\/?>/i );  // <br> 기준으로 텍스트 분리
  var wrappedLines = lines.map( function( line ) {
    
    var count = -1;
    
    return Array.from( line ).map( function( char ) {

      count ++; 
      char = char.replace(/(\r\n|\n|\r)/g, '<br/>'); // <br/>
      
      if ( char == "<br/>" ) return char;
      else return `<span class='ch' data-index="${count}">${char}</span>` 

    } ).join('');

  } );

  return wrappedLines.join('<br>'); // <br>을 추가하여 원래 형식으로 반환
}



/*--------------------------------------------------------------
 * DOM Control Functions
--------------------------------------------------------------*/

// 스크립트 추가 (add script)
/**
 * Dom 에 <script> 추가하기
 * @param {string} url 
 */
function addScript (url) {
	var script = document.createElement('script');
	script.src = url;
	document.body.appendChild(script);
}

/**
 * 스크린(윈도우) 가로 반환 
 * @return {number} 
 */
function getDocumentWidth() { return window.innerWidth || document.body.clientWidth; }

/**
 * 스크린(윈도우) 세로 반환 
 * @return {number} 
 */
function getDocumentHeight() { return window.innerHeight || document.body.clientHeight; }

/**
 * 스크린(윈도우) Scroll Top 반환 
 * @return {number} 
 */
function getDocumentScrollTop() { return document.body.scrollTop || document.documentElement.scrollTop; }

/**
 * HTML 엘리멘트 오프셋(offset) 불러오기 
 * @param {HTMLElement | Element | undefined | null} elem - 파싱 대상 문자열
 * @return { { top: number, left: number } }
 */
function getOffset( elem ) {

  var top = 0;
  var left = 0;

  if ( typeof elem != 'undefined' && elem ) {

    while ( elem ) {
      top += elem.offsetTop;
      left += elem.offsetLeft;
      elem = elem.offsetParent; // 부모 요소로 이동
    }
  }

  return { top: top, left: left };
}


/**
 * 엘리멘트 이벤트 바인드 설정
 * @param { HTMLElement } elem 
 * @param { string | object } name 
 * @param { function } handler 
 * @param { object } options 
 * @returns 
 */
function setEventListener (elem, name, handler, options) {
  /*
    'options'
    - useCapture: boolean, 이벤트 캡처링을 여부 (기본값 false)
    - once : boolean, 단일 호출 (기본값 false)
    - passive : boolean, true 시 preventDefault()를 호출하지 않을 것을 알림 -> 스크롤 성능을 향상
  */
	if ( !elem ) return;
	if ( !options ) options = null;

	if ( elem instanceof NodeList ) {
		Array.prototype.slice.call(elem).forEach(function(item){ return setEventListener(item, name, handler, options); });
		return;
	}

	// window.attachEvent ? window.attachEvent("onload", handler) : window.addEventListener("load", handler, { once : true });
	elem.attachEvent
	? elem.attachEvent(typeof name == "string" ? name : name[0], handler)
	: elem.addEventListener(typeof name == "string" ? name : name[1], handler, options);
}

/**
 * 엘리멘트 이벤트 바인드 취소
 * @param { HTMLElement } elem 
 * @param { string | object } name 
 * @param { function } handler 
 * @returns 
 */
function resetEventListener (elem, name, handler) {
	if ( !elem ) return;

	if ( elem instanceof NodeList ) {
		Array.prototype.slice.call(elem).forEach(function(item){ return resetEventListener(item, name, handler); });
		return;
	}

	elem.detachEvent
	? elem.detachEvent(typeof name == "string" ? name : name[0], handler)
	: elem.removeEventListener(typeof name == "string" ? name : name[1], handler);
}