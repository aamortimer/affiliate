<%
  function preg_match( text, pattern, ignore_case )
  	dim objRegExp
  	set objRegExp = new regExp

  	with objRegExp
  		.Pattern = pattern
  		.IgnoreCase = ignore_case
  		.Global = true
  	end with

  	set preg_match = objRegExp.Execute(text)

  	set objRegExp = nothing
  end function
  
  function preg_replace( text, pattern, replacement, ignore_case )
  	if text <> "" and pattern <> "" then
  		dim objRegExp
  		set objRegExp = new RegExp

  		with objRegExp
  			.Pattern = pattern
  			.IgnoreCase = ignore_case
  			.Global = true
  		end with

  		preg_replace = objRegExp.replace( text, replacement )

  		set objRegExp = Nothing
  	else
  		preg_replace = text
  	end if
  end function
  
  dim user_agent, bots, affid
  user_agent = lcase(request.servervariables("HTTP_USER_AGENT"))
  bots = lcase("googlebot|slurp|msnbot")
  affid = request.querystring("affid")

  set matches = preg_match(user_agent, bots, true)
  if matches.count > 0 then
    dim s
    if request.servervariables("HTTPS") = "on" then
      s = "s"
    end if
  
    dim script_name
    if request.servervariables("HTTP_X_REWRITE_URL") <> "" then
      script_name = request.servervariables("HTTP_X_REWRITE_URL")
    else
      script_name = request.servervariables("REQUEST_URI")
    end if
    
    page = preg_replace(script_name, "affid=[^&]*", "", true)
    page = replace(page, "?", "")
    page = preg_replace(page, "(\/&+?)", "/?", true)

    url = "http" & s & "://" & request.servervariables("HTTP_HOST") & page

  	response.clear()
		response.status = "301 Moved Permanently" 
		response.addHeader "Location", url
		response.end
  else
    ' Add the protocol on if not found
    set matches = preg_match(affid, "https?://", true)
    if matches.count = 0 then
      affid = "http://" & affid
    end if
  
  	response.clear()
  	response.status = "301 Moved Permanently" 
  	response.addHeader "Location", affid
  	response.end
  end if
%>