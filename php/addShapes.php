<html>

<head>
	<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
	<link rel="stylesheet" conten="text/css" href="style.css">
	<title>Shaping the city: Add Shapes.</title>
</head>

<body>
	<h1>Shaping the city: Add Shapes</h1>
	
	<?php
		
		if ($_POST['klmParser']) {
		
	?>
	
	<div>
		<ul>
		<?php
		
			//requires
			
			require_once("functions.php");
			$totalShapesAdded = 0;
			
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
				        
				        //split words - When file notation is "first_Second_Third_Word", search for "_" and replace by space
				        $name = str_replace("_", " ", $name);
				        
				        //to lower case
				        //$nameLowerCase = strtolower($name);
				        
				        //check whether the neighbourhood in the DB
				        $query = "SELECT id,name,period FROM neighbourhoods WHERE name = '$name'";
				        
				        $cloud = mysql_query($query);
				        
				        $result = mysql_fetch_assoc($cloud);
				        
				        
				        
				        //--------------if neigbourhood exists, get its ID------------------
						if (mysql_num_rows($cloud) == 1) {
							$neighbourhood_id = $result['id'];
							$nPeriod = $result['period'];
							
							$warning = 0;
							
							//--------------if neigbourhood has period------------------
					       if ($nPeriod == 0) {
								$warning = 1;
							}
							
							
						} else {
							$warning = 2;
							$newNeighbourhood = "NOT IN DB";
							$newNeighbourhood = addNeighbourhood($name);
						}
				       
				       if ($warning < 2) {
				       
					       ///--------------parse KML------------------
					       //open file
					       $kml = simplexml_load_file($filename);   /// PUT KML HERE
					       
					       
						   //----------loop shapes -----------
						    $numShapesAdded = 0;
						    $numErrors = 0;
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
							  // $shapeInfo = [];
							   $shapeInfo["latitue"] = $originLatitute;
							   $shapeInfo["longitude"] = $originLongitute;
							   $shapeInfo["coordinates"] = $shapeVertices;
							   $shapeInfo["nId"] = $neighbourhood_id;
							   
							   $addResult = addShape($shapeInfo);
							   
							   if ($addResult) {
									 $numShapesAdded++;						
								} else {
									$numErrors++;
									$warning = 3;
								}
								
								
							   
						    }
						}
					    
					    //print list item
			        	echo '<li class="neighbourhood">';
						switch ($warning) {
							case 0:
								echo '<div class="normal">'.$name.' ('.$nPeriod.'): '.$numShapesAdded . ' shapes added ('.$numErrors.' errors)';
								break;
							
							case 1:
								echo '<div class="warning1">'.$name.' (No Period): '.$numShapesAdded . ' shapes added ('.$numErrors.' errors)';
								break;
							
							case 2:
								echo '<div class="warning2">'.$name.' ('.$newNeighbourhood.'): no shape added';
								break;
								
							case 3:
								echo '<div class="warning3">'.$name.' ('.$nPeriod.'): '.$numShapesAdded . ' shapes added ('.$numErrors.' duplications was founded and removed)';
								break;
							
						}
						
						$totalShapesAdded += $numShapesAdded;
					    
					    //close list item
			        	echo "</div></li>";
			        
			        }
			    }
		
			
			    closedir($handle);
			    
			    echo "<h2>$totalShapesAdded was added</h2>";
			}
		   
		?>
		</ul>
	</div>
	
	<?php } else {
		echo "<h2>invalid request!</h2>";
		}
	?>

</body>
</html>