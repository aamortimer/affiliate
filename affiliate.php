<?php
  $user_agent = isset($_SERVER['HTTP_USER_AGENT']) ? strtolower($_SERVER['HTTP_USER_AGENT']) : false;
  $bots = strtolower('googlebot|slurp|msnbot|macintosh');
  preg_match("/affid=(.*)/", $_SERVER['REQUEST_URI'], $affid_match);
  $affid = ($affid_match) ? $affid_match[0] : false;

  if(preg_match("/$bots/", $user_agent) && $affid){
    if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS']=='on') {
  		$s ='s';
  	}
  	
    $page = str_replace('?'.$affid, '', $_SERVER['REQUEST_URI']);
  	$url = 'http'.$s.'://'.$_SERVER['HTTP_HOST'].$page;

    header( "HTTP/1.1 301 Moved Permanently");
    header( "Location: ".$url);
  }else{ 
    // Add the protocol on if not found
    preg_match("|https?://|", $affid, $matches);
    if(!$matches){
      $affid = 'http://'.$affid;
    }
    
    // do the redirect
    header( "HTTP/1.1 301 Moved Permanently");
    header( "Location: ".$affid);
  }
?>