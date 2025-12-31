<h1>Shaping the City</h1>

<p>This project was developed by Edmonton Pipelines Research Group at the University of Alberta and presented in a poster session at Hastac 2013.</p>
<p>Lear more: [https://lucianofrizzera.com/projects#shaping-the-city](https://lucianofrizzera.com/projects#shaping-the-city)
<br />Project website: http://shapingthecity.edmontonpipelines.org/
<br />Research group website: http://edmontonpipelines.org/</p>


<h2>What is it?</h2>
<p>We are looking for ways to visualize and interpret the shape of the city's map in a different perspective. Shaping the City deconstruct the map of the city, detaching the blocks from their original geo-location and reorganize them according whatever other information they carry on: size, community, period, population density, income, number of trees, venues, type of terrain, tweets and so on. It is a form of counter-mapping, in which other relevant data takes priority over geographical location.</p>
<p>Shaping the City is a prototype tool for researchers interested in history, geography and urban planning, which the goal is to enable comparison between different datasets using the shapes of the city as the main structure. It is also a playful curiosity-driven interactive visualization, in which the user is invited to explore, discover and learn more about how the city was planned and contrasting to how it has been evolving.</p>
<p>In the current version, we have mapped the core area of Edmonton, which includes 114 neighbourhoods and more than 4.000 shapes. The shapes are grouped by neighbourhoods and by the year when they were established. Although a small portion of them lack of the period data, overall experience is not affected. In the next phase, currently in progress, 95% of Edmonton area will be covered.</p>

<h2>Inspiration</h2>
<p>Shaping the city was inspired by the amazing work of Armelle Caron (http://www.armellecaron.fr/art/index.php?page=l-atelier). The artist re-arrange city blocks in order to expose similarities and differences in the built structure of the city.</p>

<h2>How it works</h2>
<p>Shaping the City is an intuitive and simple tool. There are three main possible actions in the current version:</p>
<ul>
<li><b>Highlight: </b>
You can highlight shapes either by communities or by periods. On the top left menu, choose one or more options (scroll if necessary). You will see the shapes belonging to your criteria highlight on the map. The selected criteria will be also displayed at the bottom. To remove the highlight you should either deselect the criteria on the sidebar or click on the criteria at the bottom.
</li>
<li><b>Select: </b>
You can highlight a single shape to follow during the visualization stages. Click on top of a shape to select and it will turn blue. Click outside or in another shape to deselect.
</li>
<li><b>Explode: </b>
This view deconstructs the map and reorganizes the shape by size. Turn it on by click on the button at the right bottom of the screen. If no community or period is highlighted, it shows a full list of shapes. On the other hand, if one or more criteria are set, you can compare shapes between periods and communities. Click on the period’s title to see a list of communities established at that span of time. Click again on the button to go back to the map view.
</li>
</ul>

<h2>How it was built</h2>
<h3>Phase 1: Print Poster</h3>
<p>We built this map by vectorizing each block of the city using Google Maps, which means that each block contains geolocational data. From there, we exported the data to KML files and then converted to SVG using QGIS. The next step was to load SVG files in Adobe Illustrator and graphically refined the shapes and adds aesthetic features to the poster.</p>
<h3>Phase 2: Dynamic Shapes</h3>
<p>The prototype was built with the same data used to produce the poster. However, instead of double converting the files, we parse KML as XML file into a database. Then we produce a series of sketches of the interface to illustrate what kind of interactivity we want to build. The algorithm was coded using Flash/Air technology. As we want to experiment with touch devices, we developed variations for three platforms: web, desktop and iPad.</p>

<h2>First experiment and future directions.</h2>
<p>At the first moment our efforts was an historical visualization of the city’s shape, organizing them according to neighbourhoods established date. It provided to us an alternative point of view upon the development of the city, producing new questions on the urban planning. In order to better understand city’s dynamic evolution, our next step will be to overlay a sort of different geolocated data and develop visualizations using demography, voting records, property values, and so on.</p>

<h2>Project Abstract</h2>

<p>A city map is a representation of its urban divisions and physical structures, containing, among other things, streets, blocks, landmarks, regions and natural barriers. Each one of these entities is delineated by a variety of shapes: squares, rectangles, circles and a different range of geometric forms. These representations are mere conventions and usually cannot express the full meaning of the area. In front of this, we are posing question regarding to the way in which the city got its current outline and what kind of information the shapes carry. In order to address these questions, we are proposing a visualization in which we can overlay different datasets upon the shape of the city.</p>
<p>Our project is inspired in Harpold’s (1999) concept of counter-mapping, in which he proposed that instead of using institutional political conventions, different results could emerge if people design their own maps using contextual information. Also, as Kevin Lynch (1964) stated, the boundaries and identity of a region is not singular defined by the constituent power, but socially produced by its dwellers (Lefebvre, 1992). Following Harpold and Lynch ideas, this proposal endeavors to carry forward a previous Edmonton Pipelines Project: Shaping the City.</p>
<p>In this project we have been working in an interactive visualization of the shapes of the city of Edmonton, in which each shape will be load up with data and dynamically organized in order to show different faces of the city. The options to filter and sorting the shapes allow the users to play with the data imposed upon the map in serendipitous way. This juxtaposition of data and locations could generate a range of extra relations and improve the comprehension of the city outline, posing questions, for instance, about the choices made by local authorities in order to accomplish development of Edmonton as city.</p>
