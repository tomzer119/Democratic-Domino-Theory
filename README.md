### Author
##### Thomas Weil
##### Political Science and Geogrpahical Sciences Major
##### Uchicago Class of 2022


### Shiny App Link
https://tomzer216.shinyapps.io/DemocraticDomino/







### Project Overview
This project aims to give the viewer a tool to analyze the changes in political regimes over time, the spatial distriubtion of those political types, as well as the impact of US/UN democratically backed interventions on those changes. This is not the final step in determining the relationship between space, poltics, and intervnetions, but rather a first step, intended to challenge your thinking and excite curiosity as well as answer questions about the distribution of democracy and interventions. 

### Data Description
This project uses data from 3 individual sources. 
##### Polity Data
This data set (called the Polity V dataset) is provided by [The Center for Systematic Peace](https://www.systemicpeace.org/polityproject.html) and gives a numerical value for every country politics for every year of its existance. 10 repersents the most democratic (free speech, open political elections, human rights, ect) and -10 repersents the most autocratic (unfair elections, poltical repression, ect). Polity is gotten by subtracting the democratic value in a country by the autocratic value (both on a scale of 0-10). For countries not in existance, currently colonized, or in the midst of rebellion, Polity will not be listed here. 
##### Interventions Data
This data set is called the [International Military Intervention dataset (IMI)](https://www.k-state.edu/polsci/intervention/) which shows the intervener, target, type of intervention (described in the Shiny Application) and methodology of interventions (air support, troops, naval,  ect) for every intervention between 1947-2005. Paramilitaries, government backed forces, and private secuirty forces are exlcluded. The dataset was made in two iterations (1946-1988 and 1989 to 2005) by the Univeristy of Michicagan. This is the most up to date intervention data I could find. I chose to not include interventions that I know have happened/have continued to happen for consistentcy's state, but I plan on going back into this project with a reputable source/dataset on 2005-2020 in order to fill in the missing data. 
### World Geography Over Time Data
This data is from the [Cshapes library in R](http://nils.weidmann.ws/projects/cshapes/r-package.html). It can be accessed in by runnning "library(cshapes)" in your R studio. It uses geometries from the [Correlates of War](https://correlatesofwar.org/data-sets), a reputable source on the poltical science data. It has the start and end dates for the geoemtry of every country, allowing us to show the what the world looked like every year since 1947 until 2016.  


## What does this project include
### Histogram 
This allows you to select a year to see the frequency of each Polity value for every year around the world.

### Map
 This choropleth map shows a map of the world for the year you selected for the Polity values. 
 
 ### LISA
 This Cluster Map shows clusters of high or low polity values. I think that the methodology I used for finding the LISA might be messed up somehow because there are no "low-high" or "high-low" but this is a good start-place and a decent way to identify the strong clusters. I plan on coming back to this part of the analysis and perhaps incorporating GEOda images or waiting until the GEOda R link is available. 
 
 ### Map of Interventions
 
  This shows you what active interventions are occuring every year, as well as giving you a list of those intervnetions, the polity of those countries, and the type of intervention. This has one drawback, because there are some countries which have an intervnetion in a  year (for example Japan in 1950), but the geogrpahy data set only has the geometry for Japan starting in 1953. This means a few interventions are exlucded from this map and the list, but only really near the start of the data set (late 40's and early 50's). All interventions are included in the next data set. The colors for every type of intervention change so be careful. 
  
  ### Country Tracker
  This allows you to see the Polity Values for your selected country for all years in the Polity V dataset. It also has the type of intervention as the dot color, with -99 meaning no intervention in that year. This is a bit awkward, but the only way I could get it to show. I plan on cleaning this up as well. It also allows you to chose the scale of your analysis by selecting the start year, meaning if you want to zoom in to the past 70 years you could set the start date as later.  The colors for every type of intervention change so be careful. 
  
  
  ## Future Directions
  My original intention was to use a Spatial-Autoreggressive Regression to see if there was a democratic domino effect caused by democraticallly inclined powers intervening in the affairs of a country. This was inspired by the analysis by Peter T leeson and Andrea M. Dean in ["The Democratic Domino Theory: An Empirical Investigation"](https://www.peterleeson.com/Democratic_Domino_Theory.pdf). This showed a spatial lag in changes in poltics, however a weak one. 
  I has to abandon this endeavor in the short term because, as it turns out, it is very difficult to teach yourself spatiao-temporal regression on the side. However, this allowed me to get a better sense of the data and devlop an exploratory tool as a complement to regression research. In the future I hope to coninute studying these datasets to see if poltical changes brought on by foreign intervention lead to landing change in the country itself and surroudning regimes. 
  
  ## This Github
  
  ### Data
  The interventions and poltics datasets are available for download
  
  ### Shiny 
  
  My complete Shiny Workflow.
  The annotated complete workflow is in app.r
  
  ### Changes In Poltics + Lagged
  The start to my workflow when working from the Regression Angle
  
  
  
  
  


