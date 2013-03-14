<?php

	//requires
	require_once("db_connect.php");
	
	//query
	$query = "SELECT * FROM shapes";
		
	//results
	$result = mysql_query($query);
	
	$rows = array();
	while($r = mysql_fetch_assoc($result)) {
	    $rows[] = $r;
	}
	
	print json_encode($rows);
	
	//-----------path------------------
	$path = "kml/";
    
    
    //get files
    
    if ($handle = opendir('kml')) {
	
	    // This is the correct way to loop over the directory. 
	    while (false !== ($file = readdir($handle))) {
	        
	        if ($file != "." && $file != "..") {
	        	
	        	//-----------get filename fullpath------------------
	        	$filename = $path . $file;
	        	
	        	
		        //------------check neighbourhood using file name------------------
		        
		        //remove extension
		        $name = str_replace(".kml","",$file);
		        
		         //RegExp - When file notation is "firstSecondThirdWord", use regexp search uppercase and replace by space
		        //$pattern = "/(?<!\ )[A-Z]/";
		        //$pattern = "/(?<=[a-z]{2})[A-Z]/";
		        //echo preg_match($pattern , $name);
		        //$test = preg_replace($pattern,' $0', $name);
		        
		        //split words - When file notation is "first_Second_Third_Word", search for "_" and replace by space
		        $name = str_replace("_", " ", $name);
		        
		        //to lower case
		        //$nameLowerCase = strtolower($name);
		        
		        //check whether the neighbourhood in the DB
		        $query = "SELECT id,name FROM neighbourhoods WHERE name = '$name'";
		        
		        $cloud = mysql_query($query);
		        
		        $result = mysql_fetch_assoc($cloud);
		        
		        //--------------if neigbourhood exists, get its ID------------------
				if (mysql_num_rows($cloud) == 1) {
					$neighbourhood_id = $result['id'];
					echo "<br>".$name.":<br>";
				} else {
					echo "<p>------".$name." DOES NOT EXISTS!!!----<p>";
				}
		        
		       
		       
		       ///--------------parse KML------------------
		       //open file
		       $kml = simplexml_load_file($filename);   /// PUT KML HERE
		       
		       
			   //----------loop shapes -----------
			   foreach ($kml->Document->Placemark as $block) {
				   
				   //get coordinates 
				   $coordsString = $block->Polygon->outerBoundaryIs->LinearRing->coordinates;
				   
				   //remove white spaces before and after
				   $coordsString = trim($coordsString);
				   
				   //explode vertices - Array
				   $vertices = explode(" ", $coordsString);
				   
				   //get firts verices as origin
				   
				   //explode Origin vertice coords - Array
				   $originCoords = explode(",", $vertices[0]);
				   
				    //---------Define Latitude / Longitude
				   $originLatitute = $originCoords[1];
				   $originLongitute = $originCoords[0];
				   
				   
				   //---------get shape vertices
				   
				   $shapeVertices = "";
				   
				   //loop - verticee
				   foreach ($vertices as $vertice) {
				    
				    	//discard null values
				    	if (strlen($vertice) != 0) {
						    
						    //explode vertice coords - Array
						   	$vCoords = explode(",", $vertice);
					   		
					   		//-----Build shapes vertices-----
					   		$shapeVertices = $shapeVertices . $vCoords[1] . "," . $vCoords[0]." ";
				    	}
				    	
				    	
				    	
				   }
				   
				   
				   //----------------------insert to the date base
				   
				   $query = "INSERT INTO shapes (latitude, longitude, coordinates, id_neighbourhood) VALUES ('$originLatitute', '$originLongitute', '$shapeVertices', '$neighbourhood_id')";
				   
				   if (mysql_query($query, $db_pipeline)) {
						echo ".";
					} else {
						echo "x";
					}
					
				   
			    }
	        
	        }
	    }

	
	    closedir($handle);
	}
    
    
    
    
	
?>