#Read in Libraries
library(rgdal)
library(sf)
library(dplyr)
library(plyr)
library(tmap)
library(gridExtra)
library(shinythemes)
library(RColorBrewer)
library(ggplot2)
library(tidyr) 
library(spdep)
library(cshapes)
#Read In data
cshp<-cshp(date=NA, useGW=TRUE)
polity<-read.csv("data/polity5part2.csv")
#Call for UI
ui <- fluidPage(theme=shinytheme("superhero"),
  titlePanel("Democratic Domino Theory"),
  
  #Set up Panel System
  tabsetPanel(
    tabPanel("Introduction",fluid=TRUE,
             
             
             # Sidebar layout with input and output definitions ----
             sidebarLayout(
               
               # Sidebar panel for inputs ----
               sidebarPanel( 
                 
                 # Create Input- this one a slider
                 sliderInput(inputId = "bins",
                             label = "Number of bins:",
                             min = 1,
                             max = 20,
                             value = 30),
                 selectInput("Year2", label="Select a Year to display",choices= c(1800:2016)) ,
               #Sidepanel Information
                 h6("Last edited June 14th, 2020"), h4(" Polity Data Set"), p("Center for Systemic Peace. Polity 5 Polity-Case format, 1800-2018 www.systemicpeace.org/inscrdata.html 2020. Accessed 3 May 2020. "),  tags$b("Data Download:"), a("Polity Dataset", href="http://www.systemicpeace.org/inscr/p5v2018d.xls", target="_blank"),
                 h4("Borders Data Set"), p("Nils B. Weidmann , Doreen Kuse & Kristian Skrede Gleditsch (2010) The Geography of the International System: The CShapes Dataset, International Interactions, 36:1, 86-106, DOI: 10.1080/03050620903554614"),  tags$b("Website:"), a("Cshapes Description", href="https://cran.r-project.org/web/packages/cshapes/cshapes.pdf", target="_blank"),
                h4("Interventions Data Set"), p("Pearson, Frederic S., and Robert A. Baumann.  1993.  “International Military Intervention, 1946-1988.”  Inter-University Consortium for Political and Social Research, Data Collection No 6035, University of Michigan, Ann Arbor //// Kisangani, Emizet F., and Jeffrey Pickering.  2008.  “International Military Intervention, 1989-2005.”  Inter-University Consortium for Political and Social Research, Data Collection No 21282, University of Michigan, Ann Arbor. "),  tags$b("Data Download:"), a("Interventions 1947-2005", href="https://www.k-state.edu/polsci/intervention/MergedIMIData1947-2005.xls", target="_blank")
                
                 
                 
                 
                 
                  ),
               
               # Main panel for displaying outputs ----
               mainPanel(h1("Histogram"),
                 
                 # Output: Histogram/Main Panel Description
                 plotOutput(outputId = "distPlot"), h1("Project Description")
                 ,p("This project aims to give the viewer a tool to analyze the changes in political regimes over time, the spatial distriubtion of those political types, as well as the impact of US/UN democratically backed interventions on those changes. This is not the final step in determining the relationship between space, poltics, and intervnetions, but rather a first step, intended to challenge your thinking and excite curiosity as well as answer questions about the distribution of democracy and interventions.")
                , h2("Polity"), p(" Polity is a variable from the Polity IV dataset which is a composite of the variables Democraticy and Autocraticy. These two variables measure the degree to which the government of a country is democratic (allowing free speech, press, election, ect) and autocratic (repressing speech,rigging elections, ect). Autocracy is subtracted from Democracy to give Polity, on scale from -10 to 10, 10 being the most democratic")
                 
                 , h2("Whats in this Shiny App?"), h4("Histogram"),p("This allows you to select a year to see the frequency of each Polity value for every year around the world.")
                , h4("Map"), p("This shows a map of Polity values around the world for the year selected")
                , h4("Lisa"), p("This shows a LISA cluster map of cluster values around the world for the year selected")
                ,h4("Interventions"),p("This gives a map of and list of all countries with an active intervention by the US or UN")
                , h4("Country Tracker"),p("This allows you to see the Polity Values for your selected country for all years in the Polity V dataset. It also has the type of intervention as the dot color, with -99 meaning no intervention in that year.")
                 , h2("Credits"),p("This Shiny app was put together by Thomas Weil"), p("Political Science and Geogrpahical Sciences Major- Class of 2022"),p ("tweil@uchicago.edu"),
                h2("More Info"),  a("Project Github", href="https://github.com/tomzer119/Democratic-Domino-Theory", target="_blank")
               )
             )
    ),
    
    
    #Map Panel
    tabPanel("Map",fluid=TRUE,
             sidebarLayout(
               
               # Sidebar panel for inputs ----
               sidebarPanel(
                 #Selection panel rather than a slider
                 selectInput("Year1", label="select a Year to display",choices= c(1946:2016))
                 
                 
               
                 
               ),
               # Main panel for displaying outputs ----
               mainPanel(h1("Choropleth Map"), 
                         plotOutput(outputId="PolityMap"), h3("Description"),p("Polity values by year"), h3("Disclaimer"),p("Greyed out/whited out countries either have no Polity value or do not exist in that year"),p("The legend histogram size unfortunately cannot change. If you are looking for a specific country in southern South America, try going to the Country Tracker tab")
                         
                         
                         
               ))), 
    #Lisa Panel
    tabPanel("Lisa", fluid=TRUE, 
                             sidebarLayout(
                               sidebarPanel(
                                 selectInput("Year3", label="select a Year to display",choices= c(1947:2016)),
                               ),
                               mainPanel(h1("Lisa Map"), plotOutput(outputId="LISA"), h3("Description"),p("Cluster analysis by year"), h3("Discalimer"),p("The goal of this analysis is to identify if certain poltical patterns emerge regionally. This analysis needs to be refined.")
                               ),
                             )
                             
               ),
    #Interventions Panel
    tabPanel("Interventions",fluid=TRUE,
             sidebarLayout(
               
               # Sidebar panel for inputs ----
               sidebarPanel(
                 
                 selectInput("Year4", label="select a Year to display",choices= c(1947:2005)),
                 
                 h3("Interventions Guide"),p("0-Neutral Intervention"),p("1-Support government/resist coup"),p("2-Oppose rebels "),p("3-Oppose Government"),p("4-Support rebel"),p("5-Support or oppose 3rd party government"),p("6-support or oppose rebel groups in sanctuary")
                 
                 
               ),
               
               # Main panel for displaying outputs ----
               #You can have more than one ouput to plot. Here i will plot Int and List
               mainPanel(h1("Map of UN/US interventions"), 
                         plotOutput(outputId="int"), h3(paste("List of interventions")),plotOutput(outputId="list")
                         
                         
               ))),
    #Country Tracker Paenel
    tabPanel("Country Tracker", fluid=TRUE, 
             sidebarLayout(
               sidebarPanel(
                 
                 selectInput("Year6", label="Lower Limit",choices= c(1800:2005)),
                 #Select Input for Country, need to list them all out
                 selectInput("Country", label="Select a Country to display",choices= c("United States" ,           "Canada"                  
                                                                                       ,  "Cuba"         ,            "Haiti"                   
                                                                                       , "Dominican Republic" ,      "Jamaica"                 
                                                                                       ,"Trinidad and Tobago"  ,    "Mexico"                  
                                                                                       ,"Guatemala"                ,"Honduras"                
                                                                                       ,"El Salvador"              ,"Nicaragua"               
                                                                                       ,"Costa Rica"               ,"Panama"                  
                                                                                       ,"Colombia"                 ,"Venezuela"               
                                                                                       ,"Guyana"                   ,"Suriname"                
                                                                                       ,"Ecuador"                  ,"Peru"                    
                                                                                       ,"Brazil"                   ,"Bolivia"                 
                                                                                       , "Paraguay"             ,    "Chile"                   
                                                                                       ,"Argentina"              ,  "Uruguay"                 
                                                                                       , "United Kingdom"    ,       "Ireland"                 
                                                                                       , "Netherlands"           ,   "Belgium"                 
                                                                                       , "Luxembourg"           ,    "France"                  
                                                                                       , "Switzerland"             , "Spain"                   
                                                                                       , "Portugal"                , "Germany"                 
                                                                                       , "Germany West"      ,       "Germany East"            
                                                                                       , "Poland"                  , "Austria"                 
                                                                                       , "Hungary"                 , "Czechoslovakia"          
                                                                                       , "Czech Republic"      ,     "Slovakia"                
                                                                                       , "Italy"                 ,   "Albania"                 
                                                                                       , "Kosovo"             ,      "Serbia"                  
                                                                                       , "Macedonia"        ,        "Croatia"                 
                                                                                       , "Yugoslavia"         ,      "Bosnia"                  
                                                                                       , "Serbia and Montenegro" ,   "Montenegro"              
                                                                                       , "Slovenia"               ,  "Greece"                  
                                                                                       , "Cyprus"                  , "Bulgaria"                
                                                                                       , "Moldova"                 , "Romania"                 
                                                                                       , "USSR"                   ,"Russia"                  
                                                                                       , "Estonia"         ,         "Latvia"                  
                                                                                       , "Lithuania"       ,         "Ukraine"                 
                                                                                       , "Belarus"          ,        "Armenia"                 
                                                                                       , "Georgia"          ,        "Azerbaijan"              
                                                                                       , "Finland"            ,      "Sweden"                  
                                                                                       , "Norway"             ,      "Denmark"                 
                                                                                       , "Cape Verde"       ,        "Guinea-Bissau"           
                                                                                       , "Equatorial Guinea" ,       "The Gambia"              
                                                                                       , "Mali"          ,           "Senegal"                 
                                                                                       , "Benin"        ,            "Mauritania"              
                                                                                       , "Niger"          ,          "Ivory Coast"             
                                                                                       , "Cote D'Ivoire"  ,          "Guinea"                  
                                                                                       , "Burkina Faso"  ,           "Liberia"                 
                                                                                       , "Sierra Leone"    ,         "Ghana"                   
                                                                                       , "Togo"                  ,   "Cameroon"                
                                                                                       , "Nigeria"              ,    "Gabon"                   
                                                                                       , "Central African Republic", "Chad"                    
                                                                                       , "Congo"            ,        "Congo, DRC"              
                                                                                       , "Uganda"           ,        "Kenya"                   
                                                                                       , "Tanzania"           ,      "Burundi"                 
                                                                                       , "Rwanda"             ,      "Somalia"                 
                                                                                       , "Djibouti"      ,           "South Sudan"             
                                                                                       , "Ethiopia"      ,           "Eritrea"                 
                                                                                       , "Angola"         ,          "Mozambique"              
                                                                                       , "Zambia"         ,          "Zimbabwe"                
                                                                                       , "Malawi"           ,        "South Africa"            
                                                                                       , "Namibia"          ,        "Lesotho"                 
                                                                                       , "Botswana"        ,         "Swaziland"               
                                                                                       , "Madagascar"     ,          "Comoros"                 
                                                                                       , "Mauritius"           ,     "Morocco"                 
                                                                                       , "Algeria"               ,   "Tunisia"                 
                                                                                       , "Libya"                  ,  "Sudan"                   
                                                                                       , "Sudan-North"       ,       "Iran"                    
                                                                                       , "Turkey"        ,           "Iraq"                    
                                                                                       ,"Egypt"            ,        "Syria"                   
                                                                                       ,"Lebanon"        ,          "Jordan"                  
                                                                                       ,"Israel"              ,     "Saudi Arabia"            
                                                                                       ,"Yemen North"   ,           "Yemen"                   
                                                                                       ,"Yemen South"   ,           "Kuwait"                  
                                                                                       ,"Bahrain"             ,     "Qatar"                   
                                                                                       ,"United Arab Emirates" ,    "Oman"                    
                                                                                       ,"Afghanistan"          ,    "Turkmenistan"            
                                                                                       , "Tajikistan"       ,        "Kyrgyzstan"              
                                                                                       ,"Uzbekistan"      ,         "Kazakhstan"              
                                                                                       ,"China"               ,     "Mongolia"                
                                                                                       ,"Taiwan"               ,    "North Korea"             
                                                                                       ,"South Korea"     ,         "Japan"                   
                                                                                       ,"India"               ,     "Bhutan"                  
                                                                                       ,"Pakistan"         ,        "Bangladesh"              
                                                                                       ,"Myanmar"         ,         "Sri Lanka"               
                                                                                       ,"Nepal"              ,      "Thailand"                
                                                                                       ,"Cambodia"         ,        "Laos"                    
                                                                                       ,"Vietnam North"   ,         "Vietnam South"           
                                                                                       ,"Vietnam"              ,    "Malaysia"                
                                                                                       ,"Singapore"            ,    "Philippines"             
                                                                                       , "Indonesia"             ,   "East Timor"              
                                                                                       ,"Timor Leste"            ,  "Australia"               
                                                                                       ,"Papua New Guinea"   ,      "New Zealand"             
                                                                                       ,"Solomon Islands"        ,  "Fiji"                    
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                                       
                 )),              h3("Interventions Guide"),p("0-Neutral Intervention"),p("1-Support government/resist coup"),p("2-Oppose rebels "),p("3-Oppose Government"),p("4-Support rebel"),p("5-Support or oppose 3rd party government"),p("6-support or oppose rebel groups in sanctuary"),p("-99- No intervention by UN/US"),
               ),
               mainPanel(h1("Country Tracker"), plotOutput(outputId="Track"), p("*Intervention data starts in 1947 and only goes to 2005- This will be updated"))))
    
    
    
  ))












#Call to server
server <- function(input, output) {
  #Read in Data again (not needed)
  polity<-read.csv("data/polity5part2.csv")
  
  #Call the histogram function
  
  output$distPlot <- renderPlot({
    #Selec yeart
    
    z<- polity[polity$year==input$Year2,]
    #Z will just be a list of all the polity values for that year
    z<- z$polity2
    z<- na.omit(z)
    x<-z
    
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    #Graph histogram, title with selected input. 
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Polity",
         main = paste("Histogram of Polity Through Time-", as.character(input$Year2)))
    
  })
  
  output$PolityMap <- renderPlot({
    #select only what we need
   
    polity<-select(polity, country,year, polity2)

    #Fix country names
    p<-polity %>% mutate(country2 = (ifelse(country=="Gambia", "The Gambia", country))) %>% mutate(country3=(ifelse(country2=="Congo Brazzaville", "Congo", country2)))%>% mutate(country4=(ifelse(country3=="Congo Kinshasa", "Congo, DRC", country3)))%>% mutate(country5=(ifelse(country4=="Korea North", "North Korea", country4)))%>% mutate(country6=(ifelse(country5=="Korea South", "South Korea", country5))) %>% mutate(country7=(ifelse(country6=="Myanmar (Burma)", "Myanmar", country6)))%>% mutate(country8=(ifelse(country7=="Slovak Republic", "Slovakia", country7))) %>% mutate(country9=(ifelse(country8=="UAE", "United Arab Emirates", country8)))%>% mutate(country10=(ifelse(country9=="Yemen, North", "Yemen Arab Emirates", country9)))
    #Select out variable names
    p<- select(p, -c(country,country2, country3,country4,country5,country6, country7,country8, country9))
    
    p<- plyr::rename(p, c("country10"="country"))
    
  #Select year
    p<- filter(polity, year==input$Year1)
  #Get rid dof Na's
    p=na.omit(p)
    
    p<-plyr::rename(p, c("country"="CNTRY_NAME"))
    
    

 
    #Read in Cshapes
    cshp<- cshp[cshp@data$COWEYEAR>=input$Year1,]
    cshp<- cshp[cshp@data$COWSYEAR<=input$Year1,]
    #Merge
    cshp<- merge(cshp, p, by="CNTRY_NAME", duplicateGeoms = TRUE,all.x=TRUE, all.y=TRUE)
    
    
    g<-cshp
    tmap_mode("plot")
    #Plot

    tm_shape(g)+tm_fill("polity2", legend.hist=TRUE,  palette = "RdBu", breaks=c(-10,-7,-5,0,5,7,10))+tm_legend(legend.position = c("left", "bottom"))+ tm_layout(legend.hist.size = .5,main.title = paste("Global Poility",as.character(input$Year1)))+ tm_credits("Center for Systemic Peace. Polity 5 Polity-Case format, 1800-2018 www.systemicpeace.org/inscrdata.html 2020. Accessed 3 May 2020.///Compiled by Thomas Weil", size=.75)
    
  })
  
  
  output$LISA <- renderPlot({
    polity<-select(polity, country,year, polity2)
    p<-polity %>% mutate(country2 = (ifelse(country=="Gambia", "The Gambia", country))) %>% mutate(country3=(ifelse(country2=="Congo Brazzaville", "Congo", country2)))%>% mutate(country4=(ifelse(country3=="Congo Kinshasa", "Congo, DRC", country3)))%>% mutate(country5=(ifelse(country4=="Korea North", "North Korea", country4)))%>% mutate(country6=(ifelse(country5=="Korea South", "South Korea", country5))) %>% mutate(country7=(ifelse(country6=="Myanmar (Burma)", "Myanmar", country6)))%>% mutate(country8=(ifelse(country7=="Slovak Republic", "Slovakia", country7))) %>% mutate(country9=(ifelse(country8=="UAE", "United Arab Emirates", country8)))%>% mutate(country10=(ifelse(country9=="Yemen, Noth", "Yemen Arab Emirates", country9)))
    
    p<- select(p, -c(country,country2, country3,country4,country5,country6, country7,country8))
    
    p<- plyr::rename(p, c("country10"="country"))
    p
    p
    p<- polity[p$year==input$Year3,]
    
    p=na.omit(p)
    p<-plyr::rename(p, c("country"="CNTRY_NAME"))
    
    
    library(cshapes)
    cshp<-cshp(date=NA, useGW=TRUE)
    
    cshp<- cshp[cshp@data$COWEYEAR>=input$Year3,]
    cshp<- cshp[cshp@data$COWSYEAR<=input$Year3,]
    cshp<- merge(cshp, p, by="CNTRY_NAME", duplicateGeoms = TRUE)
    
    
    
    
    
    
    
    
    #Convert to SF object
    df <- st_as_sf(x = cshp,                         
                   coords = c("CAPLONG", "CAPLAT"),
                   crs = projcrs)
    
    df<- select(df, CNTRY_NAME, polity2 )
    df<- na.omit(df)
    #Create weight matrix
    soco_nbq<-poly2nb(df, queen=TRUE)
    #df_c<-  st_centroid(st_geometry(df), of_largest_polygon=TRUE)
    #soco_nbq<-dnearneigh(df_c, 0, 1000, row.names= NULL)
    
    soco_nbq_w <- nb2listw(soco_nbq, style="W", zero.policy=TRUE)
    #Run local morans
    locm <- localmoran(df$polity2, soco_nbq_w)
    #Create lagged variable
    df$s_Polity <- scale(df$polity2) %>% as.vector()
    df$lag_s_Polity <- lag.listw(soco_nbq_w, df$s_Polity)
    
    df2<- df
    df2
    df2 <- st_as_sf(df2) %>% 
      mutate(quad_sig = ifelse(df2$s_Polity > 0 & 
                                 df2$lag_s_Polity > 0 & 
                                 locm[,5] <= 0.05, 
                               "high-high",
                               ifelse(df2$s_Polity <= 0 & 
                                        df2$lag_s_Polity <= 0 & 
                                        locm[,5] <= 0.05, 
                                      "low-low", 
                                      ifelse(df2$s_Polity > 0 & 
                                               df2$lag_s_Polity<= 0 & 
                                               locm[,5] <= 0.05, 
                                             "high-low",
                                             ifelse(df2$s_Polity<= 0 & 
                                                      df2$lag_s_Polity > 0 & 
                                                      locm[,5] <= 0.05,
                                                    "low-high", 
                                                    "non-significant")))))
    
    
    
    #PLot Lisa
    tm_shape(df2)+tm_polygons("quad_sig")+tm_legend(legend.position = c("left", "bottom"))+ tm_layout(main.title = paste("Polity Clusters",as.character(input$Year3)))+ tm_credits("Center for Systemic Peace. Polity 5 Polity-Case format, 1800-2018 www.systemicpeace.org/inscrdata.html 2020. Accessed 3 May 2020.///Compiled by Thomas Weil", size=.75)

    
    
    
    
    
    
    
    
    
    
    
    
    
  })
  
  
  output$int <- renderPlot({
  
    library(cshapes)
    cshp<-cshp(date=NA, useGW=TRUE)
    
    cshp<- cshp[cshp@data$COWEYEAR>=input$Year4,]
    cshp<- cshp[cshp@data$COWSYEAR<=input$Year4,]

    df <- st_as_sf(x = cshp,                         
                   coords = c("CAPLONG", "CAPLAT"),
                   crs = projcrs)
    
    
    
    df<- mutate(df, year=input$Year4)
    #Manually input data from Interventions dataset into CSHP dataset
    df$intervention<- ifelse(df$COWCODE %in% 450 & df$year %in% 1947, 2,ifelse(df$intervention !="None",df$intervention, "None") )             
    df$intervention<-ifelse(df$COWCODE %in% 100 & df$year %in% 1948, 0, ifelse(df$intervention !="None",df$intervention,"None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 732 & df$year %in% 1950, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 731 & df$year %in% 1950, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in%  710 & df$year %in% 1950, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<-ifelse(df$COWCODE %in% 365 & df$year %in% 1950, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 840 & df$year %in% 1951, 2, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 740 & df$year %in% 1953, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 713 & df$year %in% 1955, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 710 & df$year %in% 1955, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 666 & df$year %in% 1956, 0,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<-ifelse(df$COWCODE %in% 663 & df$year %in% 1956, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year %in% 1956, 0, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1957, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 640 & df$year %in% 1957, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    
    df$intervention<-ifelse(df$COWCODE %in% 663 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    
    df$intervention<- ifelse(df$COWCODE %in% 40 & df$year %in% 1958, 2, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 710 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 713 & df$year %in% 1958, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 663 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 95 & df$year %in% 1959, 2,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 42 & df$year %in% 1961, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 800 & df$year %in% 1962, 5,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 210 & df$year %in% 1962, 0,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 750 & df$year %in% 1962, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 41 & df$year %in% 1963, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 670 & df$year %in% 1963, 1,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<-ifelse(df$COWCODE %in% 511 & df$year %in% 1964, 0, ifelse(df$intervention !="None",df$intervention,"None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 481 & df$year %in% 1964, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year %in% 1967, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 517 & df$year %in% 1967, 6,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 352 & df$year %in% 1974, 0,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 800 & df$year %in% 1975, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 811 & df$year %in% 1975, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 110 & df$year %in% 1978, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1976, 0,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 93 & df$year %in% 1979, 0, ifelse(df$intervention !="None",df$intervention, "None")) 
    
    df$intervention<-ifelse(df$COWCODE %in% 94 & df$year %in% 1979, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 145 & df$year %in% 1979, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 630 & df$year %in% 1980, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 31 & df$year %in% 1980, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 420 & df$year %in% 1981, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1982, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 483 & df$year %in% 1983, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    #hey
    
    df$intervention<-ifelse(df$COWCODE %in% 55 & df$year %in% 1983, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 625 & df$year %in% 1984, 5, ifelse(df$intervention !="None",df$intervention, "None"))      
    
    df$intervention<-ifelse(df$COWCODE %in% 670 & df$year %in% 1984, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year %in% 1984, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 625 & df$year %in% 1985, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in%  325 & df$year %in% 1985, 6, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 620 & df$year %in% 1986, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 145 & df$year %in% 1986, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 90 & df$year %in% 1987, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 91 & df$year %in% 1988, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 95 & df$year %in% 1988, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 770 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 630 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 645 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 660 & df$year %in% 1989, 0,  ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 840 & df$year %in% 1989, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 645 & df$year %in% 1991, 3, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 451 & df$year %in% 1992, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year %in% 1994, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 517 & df$year %in% 1994, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 690 & df$year %in% 1994, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 450 & df$year %in% 1996, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 482 & df$year %in% 1996, 0,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 690 & df$year %in% 1996, 1, ifelse(df$intervention !="None",df$intervention,"None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 339 & df$year %in% 1997, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 451 & df$year %in% 1997, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 484 & df$year %in% 1997, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 531 & df$year %in% 1998, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 910 & df$year %in% 1998, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 710 & df$year %in% 1998, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 625 & df$year %in% 1998, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year %in% 1998, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 450 & df$year %in% 1998, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year %in% 2001, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 437 & df$year %in% 2002 , 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 41 & df$year %in% 2004, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 770 & df$year %in% 2004, 6, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 780 & df$year %in% 2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 41 & df$year %in% 2005, 0,  ifelse(df$intervention !="None",df$intervention, "None") )
    
    df
    #GAP
    df$intervention<- ifelse(df$COWCODE %in% 740 & df$year>=1947  & df$year<=1953, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 850 & df$year>=1947  & df$year<=1951, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 350 & df$year>=1948  & df$year<=1954, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 660 & df$year>=1948  & df$year<=1998, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 663 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 652 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 666 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 750 & df$year>=1949  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 770 & df$year>=1949  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 732 & df$year>=1950  & df$year<=1953, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 731 & df$year>=1950  & df$year<=1953, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 731 & df$year>=1953 & df$year<=1984, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year>=1956  & df$year<=1967, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 40 & df$year>=1959  & df$year<=1960, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year>=1960  & df$year<=1961, 5, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 812 & df$year>=1961  & df$year<=1962, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 817 & df$year>=1961  & df$year<=1965, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 678 & df$year>= 1963 & df$year<=1964, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 670 & df$year>=1963  & df$year<=1964, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 352 & df$year>=1964  & df$year<=1974, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 811 & df$year>=1964  & df$year<=1969, 6, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 812 & df$year>=1964  & df$year<=1973, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 816 & df$year>=1964  & df$year<=1975, 3, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year>=1964  & df$year<=1965, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    
    df$intervention<- ifelse(df$COWCODE %in% 817 & df$year>=1965  & df$year<=1973, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 42 & df$year>=1965  & df$year<=1966, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 770 & df$year>=1965  & df$year<=1966, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 750 & df$year>=1965  & df$year<=1966, 0, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 800 & df$year>=1966  & df$year<=1976, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 811 & df$year>=1969  & df$year<=1973, 6, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year>=1973  & df$year<=1979, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 666 & df$year>=1973  & df$year<=1979, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 652 & df$year>=1974  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 352 & df$year>=1974  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 660 & df$year>=1978  & df$year<=1988, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year>=1978  & df$year<=1979, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 92 & df$year>=1983  & df$year<=1988, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 31 & df$year>=1985  & df$year<=1999, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 91 & df$year>=1986  & df$year<=1, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 95 & df$year>=1989  & df$year<=1990, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 450 & df$year>=1990  & df$year<=19901, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 670 & df$year>=1990  & df$year<=1991, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 690 & df$year>=1990  & df$year<=1991, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 520 & df$year>=1992  & df$year<=1994, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 346 & df$year>=1993  & df$year<=1996, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 41 & df$year>=1994  & df$year<=1995, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year>=2001  & df$year<=2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 645 & df$year>=2003  & df$year<=2005, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 800 & df$year>=2004  & df$year<=2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 850 & df$year>= 2004  & df$year<=2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 770 & df$year>=2005  & df$year<=2006, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$intervention=="None", NA, df$intervention)
    df$intervention<- as.character(df$intervention)                                                                      
    
    
 
    
    tmap_mode("plot")
  #Plot
    tm_shape(df)+tm_fill("intervention", palette="Dark2",  textNA = "No Intervention",)+ tm_legend(legend.position = c("left", "bottom"))+ tm_layout(main.title = paste("Interventions",as.character(input$Year4)))+ tm_credits("Center for Systemic Peace. Polity 5 Polity-Case format, 1800-2018 www.systemicpeace.org/inscrdata.html 2020. Accessed 3 May 2020.///Compiled by Thomas Weil", size=.75)
    
  })
  
  output$list <- renderPlot({
    #Merge polity to CSHP then to Interventions
    polity<-select(polity, country,year, polity2)
    p<-polity %>% mutate(country2 = (ifelse(country=="Gambia", "The Gambia", country))) %>% mutate(country3=(ifelse(country2=="Congo Brazzaville", "Congo", country2)))%>% mutate(country4=(ifelse(country3=="Congo Kinshasa", "Congo, DRC", country3)))%>% mutate(country5=(ifelse(country4=="Korea North", "North Korea", country4)))%>% mutate(country6=(ifelse(country5=="Korea South", "South Korea", country5))) %>% mutate(country7=(ifelse(country6=="Myanmar (Burma)", "Myanmar", country6)))%>% mutate(country8=(ifelse(country7=="Slovak Republic", "Slovakia", country7))) %>% mutate(country9=(ifelse(country8=="UAE", "United Arab Emirates", country8)))%>% mutate(country10=(ifelse(country9=="Yemen, Noth", "Yemen Arab Emirates", country9)))
    
    p<- select(p, -c(country,country2, country3,country4,country5,country6, country7,country8))
    
    p<- plyr::rename(p, c("country10"="country"))
    #Select Year
    p<- polity[p$year==input$Year4,]
  
    p=na.omit(p)
    p<-plyr::rename(p, c("country"="CNTRY_NAME"))

    
    cshp<- cshp[cshp@data$COWEYEAR>=input$Year4,]
    cshp<- cshp[cshp@data$COWSYEAR<=input$Year4,]
    cshp<- merge(cshp, p, by="CNTRY_NAME", duplicateGeoms = TRUE)
    
    
    df <- st_as_sf(x = cshp,                         
                   coords = c("CAPLONG", "CAPLAT"),
                   crs = projcrs)
    df<-as.data.frame(df)
    df$polity2<-ifelse(df$polity2 %in% NA, -99, df$polity2)
    df$year<- input$Year4
    
    
    df$intervention<- ifelse(df$COWCODE %in% 450 & df$year %in% 1947, 2,ifelse(df$intervention !="None",df$intervention, "None") )             
    df$intervention<-ifelse(df$COWCODE %in% 100 & df$year %in% 1948, 0, ifelse(df$intervention !="None",df$intervention,"None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 732 & df$year %in% 1950, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 731 & df$year %in% 1950, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in%  710 & df$year %in% 1950, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<-ifelse(df$COWCODE %in% 365 & df$year %in% 1950, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 840 & df$year %in% 1951, 2, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 740 & df$year %in% 1953, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 713 & df$year %in% 1955, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 710 & df$year %in% 1955, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 666 & df$year %in% 1956, 0,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<-ifelse(df$COWCODE %in% 663 & df$year %in% 1956, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year %in% 1956, 0, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1957, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 640 & df$year %in% 1957, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    
    df$intervention<-ifelse(df$COWCODE %in% 663 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    
    df$intervention<- ifelse(df$COWCODE %in% 40 & df$year %in% 1958, 2, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 710 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 713 & df$year %in% 1958, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 663 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 95 & df$year %in% 1959, 2,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 42 & df$year %in% 1961, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 800 & df$year %in% 1962, 5,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 210 & df$year %in% 1962, 0,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 750 & df$year %in% 1962, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 41 & df$year %in% 1963, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 670 & df$year %in% 1963, 1,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<-ifelse(df$COWCODE %in% 511 & df$year %in% 1964, 0, ifelse(df$intervention !="None",df$intervention,"None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 481 & df$year %in% 1964, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year %in% 1967, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 517 & df$year %in% 1967, 6,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 352 & df$year %in% 1974, 0,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 800 & df$year %in% 1975, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 811 & df$year %in% 1975, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 110 & df$year %in% 1978, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1976, 0,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 93 & df$year %in% 1979, 0, ifelse(df$intervention !="None",df$intervention, "None")) 
    
    df$intervention<-ifelse(df$COWCODE %in% 94 & df$year %in% 1979, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 145 & df$year %in% 1979, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 630 & df$year %in% 1980, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 31 & df$year %in% 1980, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 420 & df$year %in% 1981, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1982, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 483 & df$year %in% 1983, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    #hey
    
    df$intervention<-ifelse(df$COWCODE %in% 55 & df$year %in% 1983, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 625 & df$year %in% 1984, 5, ifelse(df$intervention !="None",df$intervention, "None"))      
    
    df$intervention<-ifelse(df$COWCODE %in% 670 & df$year %in% 1984, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year %in% 1984, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 625 & df$year %in% 1985, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in%  325 & df$year %in% 1985, 6, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 620 & df$year %in% 1986, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 145 & df$year %in% 1986, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 90 & df$year %in% 1987, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 91 & df$year %in% 1988, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 95 & df$year %in% 1988, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 770 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 630 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 645 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 660 & df$year %in% 1989, 0,  ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 840 & df$year %in% 1989, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 645 & df$year %in% 1991, 3, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 451 & df$year %in% 1992, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year %in% 1994, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 517 & df$year %in% 1994, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 690 & df$year %in% 1994, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 450 & df$year %in% 1996, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 482 & df$year %in% 1996, 0,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 690 & df$year %in% 1996, 1, ifelse(df$intervention !="None",df$intervention,"None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 339 & df$year %in% 1997, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 451 & df$year %in% 1997, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 484 & df$year %in% 1997, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 531 & df$year %in% 1998, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 910 & df$year %in% 1998, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 710 & df$year %in% 1998, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 625 & df$year %in% 1998, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year %in% 1998, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 450 & df$year %in% 1998, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year %in% 2001, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 437 & df$year %in% 2002 , 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 41 & df$year %in% 2004, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 770 & df$year %in% 2004, 6, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 780 & df$year %in% 2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 41 & df$year %in% 2005, 0,  ifelse(df$intervention !="None",df$intervention, "None") )
    
    df
    #GAP
    
    df$intervention<- ifelse(df$COWCODE %in% 850 & df$year>=1947  & df$year<=1951, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 740 & df$year>=1947  & df$year<=1953, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 350 & df$year>=1948  & df$year<=1954, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 660 & df$year>=1948  & df$year<=1998, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 663 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 652 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 666 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 750 & df$year>=1949  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 770 & df$year>=1949  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 732 & df$year>=1950  & df$year<=1953, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 731 & df$year>=1950  & df$year<=1953, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 731 & df$year>=1953 & df$year<=1984, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year>=1956  & df$year<=1967, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 40 & df$year>=1959  & df$year<=1960, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year>=1960  & df$year<=1961, 5, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 812 & df$year>=1961  & df$year<=1962, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 817 & df$year>=1961  & df$year<=1965, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 678 & df$year>= 1963 & df$year<=1964, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 670 & df$year>=1963  & df$year<=1964, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 352 & df$year>=1964  & df$year<=1974, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 811 & df$year>=1964  & df$year<=1969, 6, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 812 & df$year>=1964  & df$year<=1973, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 816 & df$year>=1964  & df$year<=1975, 3, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year>=1964  & df$year<=1965, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    
    df$intervention<- ifelse(df$COWCODE %in% 817 & df$year>=1965  & df$year<=1973, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 42 & df$year>=1965  & df$year<=1966, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 770 & df$year>=1965  & df$year<=1966, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 750 & df$year>=1965  & df$year<=1966, 0, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 800 & df$year>=1966  & df$year<=1976, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 811 & df$year>=1969  & df$year<=1973, 6, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year>=1973  & df$year<=1979, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 666 & df$year>=1973  & df$year<=1979, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 652 & df$year>=1974  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 352 & df$year>=1974  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 660 & df$year>=1978  & df$year<=1988, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year>=1978  & df$year<=1979, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 92 & df$year>=1983  & df$year<=1988, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 31 & df$year>=1985  & df$year<=1999, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 91 & df$year>=1986  & df$year<=1, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 95 & df$year>=1989  & df$year<=1990, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 450 & df$year>=1990  & df$year<=19901, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 670 & df$year>=1990  & df$year<=1991, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 690 & df$year>=1990  & df$year<=1991, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 520 & df$year>=1992  & df$year<=1994, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 346 & df$year>=1993  & df$year<=1996, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 41 & df$year>=1994  & df$year<=1995, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year>=2001  & df$year<=2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 645 & df$year>=2003  & df$year<=2005, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 800 & df$year>=2004  & df$year<=2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 850 & df$year>= 2004  & df$year<=2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 770 & df$year>=2005  & df$year<=2006, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$intervention=="None", NA, df$intervention)
    df$intervention<- as.character(df$intervention)                                                                      
    
    df3<- df
    df2<- na.omit(df3)
    #Create dataframe
    y <- data.frame(row.names=paste(df2$CNTRY_NAME))
    #Put stuff in dataframe
    y[,1]<-df2$intervention
    y[,2]<-df2$CAPNAME
    y[,3]<-df2$polity2
    #Set colnames
    colnames(y)<-c("Intervention type" ,"Capital", "Polity")
    #PLot
    grid.table(y)
    
    
  })
  

  output$Track <- renderPlot({
    #Merge polity and interventions
    polity<-select(polity,country,year, polity2, ccode)
    polity<- filter(polity, country==input$Country)
    
    p<-polity %>% mutate(country2 = (ifelse(country=="Gambia", "The Gambia", country))) %>% mutate(country3=(ifelse(country2=="Congo Brazzaville", "Congo", country2)))%>% mutate(country4=(ifelse(country3=="Congo Kinshasa", "Congo, DRC", country3)))%>% mutate(country5=(ifelse(country4=="Korea North", "North Korea", country4)))%>% mutate(country6=(ifelse(country5=="Korea South", "South Korea", country5))) %>% mutate(country7=(ifelse(country6=="Myanmar (Burma)", "Myanmar", country6)))%>% mutate(country8=(ifelse(country7=="Slovak Republic", "Slovakia", country7))) %>% mutate(country9=(ifelse(country8=="UAE", "United Arab Emirates", country8)))%>% mutate(country10=(ifelse(country9=="Yemen, Noth", "Yemen Arab Emirates", country9)))
    
    p<- select(p, -c(country,country2, country3,country4,country5,country6, country7,country8, country9))
    
    p<- plyr::rename(p, c("country10"="country"))
    
    df<-p
    
    df$polity2<-ifelse(df$polity2 %in% NA, -99, df$polity2)
    df<- mutate(df, COWCODE= ccode)
    
    
    df$intervention<- ifelse(df$COWCODE %in% 450 & df$year %in% 1947, 2,ifelse(df$intervention !="None",df$intervention, "None") )             
    df$intervention<-ifelse(df$COWCODE %in% 100 & df$year %in% 1948, 0, ifelse(df$intervention !="None",df$intervention,"None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 732 & df$year %in% 1950, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 731 & df$year %in% 1950, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in%  710 & df$year %in% 1950, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<-ifelse(df$COWCODE %in% 365 & df$year %in% 1950, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 840 & df$year %in% 1951, 2, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 740 & df$year %in% 1953, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 713 & df$year %in% 1955, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 710 & df$year %in% 1955, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 666 & df$year %in% 1956, 0,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<-ifelse(df$COWCODE %in% 663 & df$year %in% 1956, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year %in% 1956, 0, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1957, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 640 & df$year %in% 1957, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    
    df$intervention<-ifelse(df$COWCODE %in% 663 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    
    df$intervention<- ifelse(df$COWCODE %in% 40 & df$year %in% 1958, 2, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 710 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 713 & df$year %in% 1958, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 663 & df$year %in% 1958, 5,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 95 & df$year %in% 1959, 2,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 42 & df$year %in% 1961, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 800 & df$year %in% 1962, 5,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 210 & df$year %in% 1962, 0,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 750 & df$year %in% 1962, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 41 & df$year %in% 1963, 3,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 670 & df$year %in% 1963, 1,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<-ifelse(df$COWCODE %in% 511 & df$year %in% 1964, 0, ifelse(df$intervention !="None",df$intervention,"None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 481 & df$year %in% 1964, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year %in% 1967, 1,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 517 & df$year %in% 1967, 6,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 352 & df$year %in% 1974, 0,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 800 & df$year %in% 1975, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 811 & df$year %in% 1975, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 110 & df$year %in% 1978, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1976, 0,ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 93 & df$year %in% 1979, 0, ifelse(df$intervention !="None",df$intervention, "None")) 
    
    df$intervention<-ifelse(df$COWCODE %in% 94 & df$year %in% 1979, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 145 & df$year %in% 1979, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 630 & df$year %in% 1980, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 31 & df$year %in% 1980, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 420 & df$year %in% 1981, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 660 & df$year %in% 1982, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 483 & df$year %in% 1983, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    #hey
    
    df$intervention<-ifelse(df$COWCODE %in% 55 & df$year %in% 1983, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 625 & df$year %in% 1984, 5, ifelse(df$intervention !="None",df$intervention, "None"))      
    
    df$intervention<-ifelse(df$COWCODE %in% 670 & df$year %in% 1984, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year %in% 1984, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 625 & df$year %in% 1985, 5, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in%  325 & df$year %in% 1985, 6, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 620 & df$year %in% 1986, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 145 & df$year %in% 1986, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 90 & df$year %in% 1987, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 91 & df$year %in% 1988, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 95 & df$year %in% 1988, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 770 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 630 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 645 & df$year %in% 1988, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 660 & df$year %in% 1989, 0,  ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 840 & df$year %in% 1989, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 645 & df$year %in% 1991, 3, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 451 & df$year %in% 1992, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year %in% 1994, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 517 & df$year %in% 1994, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 690 & df$year %in% 1994, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 450 & df$year %in% 1996, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 482 & df$year %in% 1996, 0,ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 690 & df$year %in% 1996, 1, ifelse(df$intervention !="None",df$intervention,"None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 339 & df$year %in% 1997, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 451 & df$year %in% 1997, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 484 & df$year %in% 1997, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 531 & df$year %in% 1998, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 910 & df$year %in% 1998, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 710 & df$year %in% 1998, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 625 & df$year %in% 1998, 3, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year %in% 1998, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 450 & df$year %in% 1998, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year %in% 2001, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 437 & df$year %in% 2002 , 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 41 & df$year %in% 2004, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<-ifelse(df$COWCODE %in% 770 & df$year %in% 2004, 6, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 780 & df$year %in% 2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 41 & df$year %in% 2005, 0,  ifelse(df$intervention !="None",df$intervention, "None") )
    
    df
    #GAP
    
    df$intervention<- ifelse(df$COWCODE %in% 850 & df$year>=1947  & df$year<=1951, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 740 & df$year>=1947  & df$year<=1953, 0, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 350 & df$year>=1948  & df$year<=1954, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 660 & df$year>=1948  & df$year<=1998, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 663 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 652 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 666 & df$year>=1948  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 750 & df$year>=1949  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 770 & df$year>=1949  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 732 & df$year>=1950  & df$year<=1953, 1, ifelse(df$intervention !="None",df$intervention, "None"))
    
    df$intervention<- ifelse(df$COWCODE %in% 731 & df$year>=1950  & df$year<=1953, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 731 & df$year>=1953 & df$year<=1984, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year>=1956  & df$year<=1967, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 40 & df$year>=1959  & df$year<=1960, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year>=1960  & df$year<=1961, 5, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 812 & df$year>=1961  & df$year<=1962, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 817 & df$year>=1961  & df$year<=1965, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 678 & df$year>= 1963 & df$year<=1964, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 670 & df$year>=1963  & df$year<=1964, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 352 & df$year>=1964  & df$year<=1974, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 811 & df$year>=1964  & df$year<=1969, 6, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 812 & df$year>=1964  & df$year<=1973, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 816 & df$year>=1964  & df$year<=1975, 3, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year>=1964  & df$year<=1965, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    
    df$intervention<- ifelse(df$COWCODE %in% 817 & df$year>=1965  & df$year<=1973, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 42 & df$year>=1965  & df$year<=1966, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 770 & df$year>=1965  & df$year<=1966, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 750 & df$year>=1965  & df$year<=1966, 0, ifelse(df$intervention !="None",df$intervention,"None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 800 & df$year>=1966  & df$year<=1976, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 811 & df$year>=1969  & df$year<=1973, 6, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 651 & df$year>=1973  & df$year<=1979, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 666 & df$year>=1973  & df$year<=1979, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 652 & df$year>=1974  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 352 & df$year>=1974  & df$year<=1988, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 660 & df$year>=1978  & df$year<=1988, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 490 & df$year>=1978  & df$year<=1979, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 92 & df$year>=1983  & df$year<=1988, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 31 & df$year>=1985  & df$year<=1999, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 91 & df$year>=1986  & df$year<=1, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 95 & df$year>=1989  & df$year<=1990, 2, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 450 & df$year>=1990  & df$year<=19901, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 670 & df$year>=1990  & df$year<=1991, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 690 & df$year>=1990  & df$year<=1991, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 520 & df$year>=1992  & df$year<=1994, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 346 & df$year>=1993  & df$year<=1996, 0, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 41 & df$year>=1994  & df$year<=1995, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 700 & df$year>=2001  & df$year<=2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    
    df$intervention<- ifelse(df$COWCODE %in% 645 & df$year>=2003  & df$year<=2005, 3, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 800 & df$year>=2004  & df$year<=2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 850 & df$year>= 2004  & df$year<=2005, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    
    df$intervention<- ifelse(df$COWCODE %in% 770 & df$year>=2005  & df$year<=2006, 1, ifelse(df$intervention !="None",df$intervention, "None") )
    #Set NA values to -99
    df[is.na(df)]<--99
    df$country<- as.character(df$country)
    df$intervention<- as.character(df$intervention) 
    
    df<-filter(df, polity2>=-11)
    #Plot
    ggplot(df, aes(x=year, y=polity2))+geom_point(aes(color=intervention))+coord_cartesian(xlim = c(as.numeric(input$Year6), 2020), ylim = c(-10, 10))+theme_minimal()+labs(title=paste("Country Polity Tracker-",input$Country, input$Year6,"to 2018")) +theme(plot.title = element_text(color = "black", size = 15, face = "bold"))
   
  })
  
}

#Run app
shinyApp(ui = ui, server = server)

