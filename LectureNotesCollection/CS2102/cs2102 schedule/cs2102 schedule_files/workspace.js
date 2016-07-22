var popupWin_1 = new Array();
var popupWin_2 = new Array();

function winopen(url, w, h, AcceptMyParam) {
    //Set the default such that all will use the same size
    if (AcceptMyParam === undefined) {
        w = 990;
        h = 600;
    }

    var left = (screen.width) ? (screen.width-w)/2 : 0;
    var top  = (screen.height) ? (screen.height-h)/2 : 0;

  window.open(url, "_blank", "width="+w+",height="+h+",left="+left+",top="+top+",resizable=yes,scrollbars=yes");
  
  return;
}

function winopen2(url,target, w, h) {
    //Set the default such that all will use the same size
    w = 990;
    h = 600;

  var left = (screen.width) ? (screen.width-w)/2 : 0;
  var top  = (screen.height) ? (screen.height-h)/2 : 0;


 if(popupWin_2[target] != null)
	if(!popupWin_2[target].closed)
		popupWin_2[target].focus();
	else
		popupWin_2[target] = window.open(url, target, "width="+w+",height="+h+",left="+left+",top="+top+",resizable=yes,scrollbars=yes");
  else
	popupWin_2[target] = window.open(url, target, "width="+w+",height="+h+",left="+left+",top="+top+",resizable=yes,scrollbars=yes");
  
  return;
}

function winopen_small(url) {

    //Set the default such that all will use the same size
    w = 400;
    h = 300;

    var left = (screen.width) ? (screen.width - w) / 2 : 0;
    var top = (screen.height) ? (screen.height - h) / 2 : 0;

    window.open(url, "_blank", "width=" + w + ",height=" + h + ",left=" + left + ",top=" + top + ",resizable=yes,scrollbars=yes");

    return;
}

//This function not used anymore.
//function winopencustom(url, target, p) 
//{
//  window.open(url, target, p);
//  return;
//}

function winopenprompt(url, w, h,resize,scrollbar) {

    //Set the default such that all will use the same size
    w = 990;
    h = 600;

  var left = (screen.width) ? (screen.width-w)/2 : 0;
  var top  = (screen.height) ? (screen.height-h)/2 : 0;


  window.open(url, "_blank", "width="+w+",height="+h+",left="+left+",top="+top+",resizable="+resize+",scrollbars="+scrollbar);
  
  return;
}

function winopen_ann(url) {
    var w = 620, h = 600;

    var left = (screen.width) ? screen.width - w - 20 : 0;
    var top = (screen.height) ? (screen.height - h) / 2 : 0;

    window.open(url, "_blank", "width=" + w + ",height=" + h + ",left=" + left + ",top=" + top + ",resizable=yes,scrollbars=yes");

    return;
}

//This function not used anymore.
//function winopenprompt2(url,target, w, h,resize,scrollbar) 
//{
//  var left = (screen.width) ? (screen.width-w)/2 : 0;
//  var top  = (screen.height) ? (screen.height-h)/2 : 0;

//  if(popupWin_1[target] != null)
//	if(!popupWin_1[target].closed)
//		popupWin_1[target].focus();
//	else
//		popupWin_1[target] = window.open(url, target, "width="+w+",height="+h+",left="+left+",top="+top+",resizable="+resize+",scrollbars="+scrollbar);
//  else
//	popupWin_1[target] = window.open(url, target, "width="+w+",height="+h+",left="+left+",top="+top+",resizable="+resize+",scrollbars="+scrollbar);
//  
//  return;
//}

function ToggleDisplayWks(button, item, cid, isreverse) {
    var ReverseFunction = false
    if (isreverse) {
        ReverseFunction = isreverse;
    }

  if (button.src.indexOf("dot.gif") == -1 ) {
    if (!ReverseFunction && ((item.style.display == "") || (item.style.display == "none"))) {
      item.style.display = "block";
      button.src = "/images/wk_minus.gif";
	  writecookie('WkSpaceTree', cid, 0)
	} else {
      item.style.display = "none";
  	  button.src = "/images/wk_plus.gif";
	  writecookie('WkSpaceTree', cid, 1)
    }
  }
  return false;
}

function getcookie(cookiename) 
{   
  var search = cookiename + "="   
  if (document.cookie.length > 0) {       
   offset = document.cookie.indexOf(search)       
   if (offset != -1) {           
     offset += search.length                  
     end = document.cookie.indexOf(";", offset)       
     if (end == -1)             
       end = document.cookie.length         
     return unescape(document.cookie.substring(offset, end))      
    }    
  }
}

function writecookie(cookiename,item,newvalue) 
{   
	if((document.cookie.indexOf(cookiename + "=")) != -1)
	{
		var cookiearray = getcookie(cookiename).split("&")
		
		var cookiefound = false
		
		// loop through the array and checks or the identifier equals the item paramater
        // if yes replace the current value for the newvalue parameter 
		for (var i = 0; i < cookiearray.length; i++)
		{
			var string2check = cookiearray[i].split("=")
			if (string2check[0] == item)
				{
					string2check[0]
					cookiearray[i] = string2check[0] + "=" + newvalue
					cookiefound = true
				}
		}
		
		//Add new value to the array
		if (cookiefound == false)
			cookiearray[cookiearray.length] = item + "=" + newvalue
		
		//Build a new cookiestring
		var newcookie = ""
		
		for (var i = 0; i < cookiearray.length; i++)
			if (cookiearray[i] != "")
  			newcookie = newcookie +  cookiearray[i]	+ "&"		
	
    document.cookie = cookiename + "=" + newcookie;
	}
	else
  	document.cookie = cookiename + "=" + item + "=" + newvalue + "&";
}

//changes the current location to url
function loadurl(url) {
    document.location.href = url;
}

//grabs the content of the url and calls function to call
//function functiontocall(Content) {
function grabContent(theURL, FunctionToCall) {
    var request = new Sys.Net.WebRequest();
    request.set_httpVerb("GET");
    request.set_url(theURL);
    request.add_completed(function(executor) {
        if (executor.get_responseAvailable()) {
            var content = executor.get_responseData();
            FunctionToCall(content);
        }
    });

    var executor = new Sys.Net.XMLHttpExecutor();
    request.set_executor(executor);
    executor.executeRequest();
}

function ActiveTabChanged(sender, e) {
    sender.get_clientStateField().value = sender.saveClientState();
}

//hide an element id
function $hide(id) {
    var element = document.getElementById(id);
    if (element == null) {
        //alert(id + " is invalid");
    }
    else
        element.style.display = "none";
}

//show an element id
function $show(id, style, focus) {
    var element = document.getElementById(id);
    var displayStyle = "block";
    if (style && style != "IGNORE") {
        if (style == "NONE")
            displayStyle = "";
        else
            displayStyle = style;
    }

    if (element == null) {
        //alert(id + " is invalid");
    }
    else
        element.style.display = displayStyle;

    if (focus) {
        try {
            //do a try catch in case element not even visible
            element.focus();
        }
        catch (ex) {
        }
    }
}

/* Cookie Functions */
function createCookie(name, value) {
    document.cookie = name + "=" + value + "; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}
/* Cookie Functions */

/* JSON functions */
function installScript(script) { if (!script) return; if (window.execScript) window.execScript(script); else window.setTimeout(script, 0); }
var jsonp_CallBacks = new Array();function jsonp_AddCallBack(callBackFunctionName, scriptElement){var obj = new Object();obj.callBackFunctionName = callBackFunctionName;obj.ScriptElement = scriptElement;jsonp_CallBacks.push(obj);}
function jsonp_RemoveCallBack(callBackFunctionName) {for (var i = 0; i < jsonp_CallBacks.length; i++) {if (jsonp_CallBacks[i].callBackFunctionName == callBackFunctionName) {            document.body.removeChild(jsonp_CallBacks[i].ScriptElement);jsonp_CallBacks.splice(i, 1);i--;}}}
function jsonp(url,callback,name, query)
{                
    if (url.indexOf("?") > -1)
        url += "&jsonp=" 
    else
        url += "?jsonp=" 
    url += name + "&";
    if (query)
        url += encodeURIComponent(query) + "&";   
    url += new Date().getTime().toString(); // prevent caching        
    
    var script = document.createElement("script");        
    script.setAttribute("src",url);
    script.setAttribute("type","text/javascript");                
    document.body.appendChild(script);
jsonp_AddCallBack(name, script);
}
/* JSON functions */

var ivle_p_id = 0;
var ivle_p_elem = null;
var ivle_p_ivle = "";
function ivle_b(Friends, Announcement)
{
    if (Friends == null) Friends = 0;
    if (Announcement == null) Announcement = 0;
    //winopen('/announcement/popup_new.aspx', 450, 420);
    if (Friends == 0 && Announcement == 0) {
        ivle_p_elem.style.display = "none";
    }
    else {
        var sb = new Sys.StringBuilder("");
        sb.append("<div style='display:inline;' onmouseover='Tip(&quot;Contacts&lt;br /&gt;");
        sb.append(Friends + " new message(s)");
        sb.append("&quot;);' onmouseout='UnTip();'");
        if (Friends > 0) {
            sb.append(" onclick='winopen(&quot;/friends/popup_new.aspx&quot;, 450, 420);'");
        }
        sb.append("><img src='/images/live/contacts.jpg' border='0' style='vertical-align:middle' /> ");
        sb.append(Friends);
        sb.append("</div>");

        sb.append("<div style='display:inline;' onmouseover='Tip(&quot;Announcement");
        if (Announcement > 0) {
            sb.append("&lt;br /&gt;" + Announcement + " new announcement(s). Click to view them.");
        }
        sb.append("&quot;);' onmouseout='UnTip();'");
        if (Announcement > 0) {
            sb.append(" onclick='winopen(&quot;/announcement/popup_new.aspx&quot;, 450, 420);'");
        }

        sb.append("><img src='/images/live/ann.gif' border='0' style='vertical-align:middle' /> " + Announcement + "</div>");
        ivle_p_elem.innerHTML = sb.toString();
        ivle_p_elem.style.display = "block";
    }
}
function ivle_p(result) {
    if (result.isLoggedIn) {
        jsonp_RemoveCallBack("ivle_p");
        //update cookie Last Call
        createCookie("t", result.LastCall);

        //There are new Messages
        //ivle_b(result.Friends.Total, result.Total_Announcement);
        ivle_b(result.Total_Friends, result.Total_Announcement);

        if (result.isLoggedIn) {
            //queue next check in 1 minute
            ivle_p_id = window.setTimeout("ivle_p_l()", 60000);
        }
    }
    else {
        //logged out
        loadurl("/default.aspx");
    }
}

function ivle_p_r() {
    if (ivle_p_id > 0) clearTimeout(ivle_p_id);
    ivle_p_l();
}
function ivle_p_l() {
    if (document.location.protocol == "http:")
        jsonp(document.location.protocol + "//live." + document.location.host + "/ivle.ashx?k=" + ivle_p_ivle + "&t=" + readCookie('t'), "ivle_p", "");
}
function ivle_p_div()
{
   if (ivle_p_elem == null)
   {
       ivle_p_elem = document.createElement("div");
       ivle_p_elem.id = "fixme";
       ivle_p_elem.style.whiteSpace = "nowrap";
       ivle_p_elem.className = "fixme";
       ivle_b();
       document.body.appendChild(ivle_p_elem);
   }
}
/* IVLE Poll Service Functions */
