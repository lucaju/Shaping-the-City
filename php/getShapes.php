<?php

	//requires
	require_once("db_connect.php");
	
	$shapes = array();
	
	//query
	if ($_GET['phase']) {
	
		//filter neighbourhoods
		$phase = $_GET['phase'];
		
		$nQuery = "SELECT * FROM neighbourhoods WHERE phase='$phase'";
			
		//results
		$nResult = mysql_query($nQuery);

		while($nRow = mysql_fetch_assoc($nResult)) {
		    $nId = $nRow['id'];
		    
		    $sQuery = "SELECT * FROM shapes WHERE id_neighbourhood='$nId'";
		    $sResult = mysql_query($sQuery);
		    while($sRow = mysql_fetch_assoc($sResult)) {
			    $shapes[] = $sRow;
			}
		    
		}
		
	} else {
		//take them all
		$sQuery = "SELECT * FROM shapes";
		$sResult = mysql_query($sQuery);
		
		while($sRow = mysql_fetch_assoc($sResult)) {
		    $shapes[] = $sRow;
		}
	}
	
	print json_encode($shapes);    
	
?>