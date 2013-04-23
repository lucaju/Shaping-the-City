<?php

require_once("db_connect.php");

//************** ADD NEIGHBOURHOOD *******************

function addNeighbourhood($name) {

	$query = "INSERT INTO neighbourhoods (name, period, phase) VALUES ('$name', '0000', '2')"; 
						  
	if (mysql_query($query)) {
		return "Added";						
	} else {
		return "Error";
	}
	
}


//************** ADD SHAPE *******************

function addShape($shapeInfo) {

	$lat = $shapeInfo["latitue"];
	$long = $shapeInfo["longitude"];
	$coordinates = $shapeInfo["coordinates"];
	$nID = $shapeInfo["nId"];
	
	if (!testShapeDuplication($lat,$long,$coordinates)) {
	
		$query = "INSERT INTO shapes (latitude, longitude, coordinates, id_neighbourhood) VALUES ('$lat', '$long', '$coordinates', '$nID')";
							   
		if (mysql_query($query)) {
			return true;						
		} else {
			return false;
		}
	}
	
	return false;
	
}

//************** CHECK FOR SHAPE DUPLICATION *******************

function testShapeDuplication($lat,$long,$coords) {
	 $query = "SELECT latitude,longitude,coordinates FROM shapes WHERE latitude = '$lat' AND longitude = '$long' AND coordinates = '$coords'";
				        
	 $cloud = mysql_query($query);
	 $result = mysql_fetch_assoc($cloud);
	 if (mysql_num_rows($cloud) == 1) {
	 	return true;
	 } else {
		 return false;
	 }
}

//************** Get Number of shapes of neighbourhood *******************

function getShapeNumByNeigbourhood($n) {
	$query = "SELECT id_neighbourhood FROM shapes WHERE id_neighbourhood = '$n'";
				        
	 $cloud = mysql_query($query);
	 $num = mysql_num_rows($cloud);
	 
	 return $num;

}


//************** Get All Neighbourhoods Info *******************

function getAllNeighbourhoodsInfo() {
	
	$query = "SELECT * FROM neighbourhoods ORDER BY phase,name";
	$cloud = mysql_query($query);
	
	$currentPhase = 0;
	$nTotal = 0;
	$sTotal = 0;
	
	while($row = mysql_fetch_assoc($cloud)) {
		
		$liClass = "";
		
		//save variables
		$id = $row['id'];	
		$name = $row['name'];
		$period = $row['period'];
		$phase = $row['phase'];
		
		$nTotal++;
		
		if ($currentPhase != $phase) {
			
			if ($currentPhase != 0) {
				
				echo '<li class="'.$liClass.'">'."\n";
				echo '<div class="nPeriod">TOTAL</div>'."\n";
				echo '<div class="nName"><b>'.$nTotal.' Neighbourhoods</b></div>'."\n";
				echo '<div class="nShapes"><b>'.$sTotal.' shapes</b></div>'."\n";
				echo '</li>'."\n";
				
				echo '</ul>'."\n";
				echo '</div>'."\n";
				
				$nTotal = 0;
				$sTotal = 0;
			}
			
			$currentPhase = $phase;
			echo '<div class="phase'.$phase.'">'."\n";
			echo '<p>Phase '.$phase.'</p>'."\n";
			echo '<ul class="neighbourhood">'."\n";
		}
		
		
		if ($phase == 1) {		
			if ($period == 0) {
				$liClass = "warning1";
				$period = "0000";
			} else {
				$liClass = "normal";
			}
		} else {
			$period = "";
		}
		
		echo '<li class="'.$liClass.'">'."\n";
		echo '<div class="nPeriod">'.$period.'</div>'."\n";
		echo '<div class="nName">'.$name.'</div>'."\n";
		echo '<div class="nShapes">'.getShapeNumByNeigbourhood($id).' shapes</div>'."\n";
		echo '</li>'."\n";
		
		$sTotal += getShapeNumByNeigbourhood($id);
		
	}
	
	echo '<li class="'.$liClass.'">'."\n";
	echo '<div class="nPeriod">TOTAL</div>'."\n";
	echo '<div class="nName"><b>'.$nTotal.' Neighbourhoods</b></div>'."\n";
	echo '<div class="nShapes"><b>'.$sTotal.' shapes</b></div>'."\n";
	echo '</li>'."\n";	
	
	echo '</ul>'."\n";
	echo '</div>'."\n";
}



?>