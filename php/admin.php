<html>
<head>
	<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
	<link rel="stylesheet" conten="text/css" href="style.css">
	<title>Shaping the city: The back door.</title>
</head>
<body>
	<?php require_once("functions.php"); ?>
	<h1>Shaping the city: The back door.</h1>
	<h2>Neighbourhoods</h2>
	<div>
	<form method="post" action="addShapes.php">
		<input type="submit" name="klmParser" value="klmParser">
	</form>
	</div>
	<div>
		<?php getAllNeighbourhoodsInfo() ?>
	</div>
</body>
</html>