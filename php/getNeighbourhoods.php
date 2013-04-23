<?php

	//requires
	require_once("db_connect.php");
	
	//query
	if ($_GET['phase']) {
		$phase = $_GET['phase'];
		$query = "SELECT * FROM neighbourhoods WHERE phase='$phase'";
	} else {
		$query = "SELECT * FROM neighbourhoods";
	}
		
	//results
	$result = mysql_query($query);
	
	$rows = array();
	while($r = mysql_fetch_assoc($result)) {
	    $rows[] = $r;
	}
	
	print json_encode($rows);    
	
?>