Severe weather could be a threat for flight journeys which also results in delay or cancellation of flights. Most of the aviation accidents occurring every year are weather related. It is the responsibility of Aviation Weather Center to provide relevant information about weather conditions to avoid dangerous accidents.
BACKGROUND OF AWC:
Aviation Weather Center (AWC) provides aviation weather forecasts, warnings and advisories with the primary mission to protect life and property and a secondary mission to promote commerce. It is located in Kansas City of Missouri state and operates 24 hours per day, year around. 
AWC provides weather information for worldwide aviation operations and is recognized as one of the two world area forecast centers by The International Civil Aeronautical Organization (ICAO). AWC also conducts a weather collaboration to ensure that the aviation forecasts are consistent with Regional Area Forecast Centers.
This project is to develop an iPad application allowing pilots to provide flight information to use the AWC App. The users of this system are pilots. Pilot may use the application, after providing valid credentials, to send weather reports to the ground station and to view the reports retrieved from the ground station. AWC App uses iOS framework to create an iPad application which provides the optimal viewing experience to the pilots on iPads.

AWC APP
AWC App is an iPad application which will provide pilots useful and valid aviation weather hazard information for all phases of flight. The app provides significant weather hazard information for pre-flight planning. This app is used by pilots to send aviation information to the ground station and also to view weather information at his/her desired location. The aviation information would consist of weather forecasts and hazards. The iPad application receives and displays meteorological text information. It also delivers consistent, timely and accurate weather information for the airspace systems.
The application consists of six tabs namely PIREP tab, PIREP Send tab, METARs tab, TAF tab, Hazards tab, Radar and Satellite View tab and Settings tab. PIPER, PIREP Send, METARs, TAF, Hazards, Radar & Satellite tabs are used to report weather conditions or to view weather information. Settings tab is used to change the pilot or flight information. The weather information will be sent to the ground station in the form of reports. The reports are stored in a file on the server or on a database, for later use, and then sent to the ground station.
The pilot will be prompted to enter credentials of the flight in order to use the app. He/she is also prompted to enter his/her valid password for authentication purpose. If the pilot is a returning user, that is, if the pilot is using the app on the iPad for the second time, he/she could see the existing pilot information at the bottom of the welcome screen.

AWC App Tabs
Welcome Screen
Pilot enters relevant information about flight to use the app. The user may be a first time user or a returning user. If the user is using the app for the first time, he/she has to enter valid information to use the app. The information consists of Name, Aircraft type, Tail Number and License. No field can be left empty. If the pilot leaves a field to be empty, he/she cannot use the application and a message will be displayed not to leave any of the fields empty. He/she has to enter his/her valid password for authentication purpose.
If the pilot is a returning user, he/she can find the existing information, at the bottom of the page. The returning user may continue with the same information by clicking the ‘continue’ button or can make changes to the details by clicking the ‘change’ button.

PIREP Tab
Weather information gathered from a pilot is displayed as a PIREP. A PIREP is a part of aviation weather. It is a pilot report of actual weather conditions encountered during the flight path. A pilot can view PIREPs to know weather information at any desired location.
The PIREP tab provides aviation information to the pilot on the iPad. When the pilot clicks the PIREP tab, a request for PIREP data is sent to two sources. One of the two sources is the Aviation Weather Center which consists of actual PIREPs, and the other source is the University’s repository consisting of user generated PIREPs. In both cases, the data obtained from the two sources is in Geo-JSON format which is parsed to produce annotations. The application generates an annotation for each PIREP and is displayed on the map. Each PIREP annotation is set to its symbol and is displayed on the map. Existing/actual PIREPs are represented with a PIREP symbol and the user generated PIREPs are represented with a user symbol.
While PIREPs are loading on to the map, a loading status is shown. When a particular PIREP is clicked, detailed information is displayed on a pop-up view. The information consists of License Number, Time of Report, Aircraft Type, Tail Number, Sky Condition, Weather Condition, Location and Pilot Report. When sending a pilot report it must consist of at least one weather element (chop/turbulence/mountain wave/icing).


PIREP-Send Tab
The PIREP-Send tab allows a pilot to send the pilot report, that is, a PIREP to the ground. A PIREP consists of weather information that includes Icing, turbulence, Chop, Mountain wave. Each weather condition is reported based on its intensity. All four weather elements have intensities like light, moderate and severe. Icing includes a category along with intensity. On selecting each element and its intensity, a report of the selected elements is displayed at the bottom of the page.
ICING is an atmospheric condition that can lead to the formation of water ice on the surfaces of an aircraft.  
Categories:
CLEAR: It refers clear ice which is often clear and smooth. Super-cooled water droplets strike a surface but do not freeze instantly.
RIME: Rime ice is rough and opaque, formed by super-cooled drops rapidly freezing on impact.
MIXED: It is a combination of clear and rime.
Intensities:
ICING/TRACE: Ice becomes perceptible. De-icing/anti-icing equipment is not used unless encountered for an extended period of time (over 1 hour).
ICING/LIGHT: Rate of accumulation may create a problem if flight is prolonged in such an environment (over 1 hour). Occasional use of de-icing/anti-icing equipment removes or prevents accumulation.
ICING/MOD: The rate of accumulation is such that even short encounters become potentially hazardous, and use of de-icing/anti-icing equipment or diversion is necessary.
ICING/SEVERE: The rate of accumulation is such that de-icing/anti-icing equipment fails to reduce or control the hazard. Immediate diversion is necessary in such a case.
TURB (Turbulence) is the velocity or unsteady movement of air. It can be caused by thunderstorms or can also be experienced when flying close to a mountain range, or at higher altitudes. An aircraft can also experience turbulence when flying low to the ground (during takeoff or landing) where turbulence is formed by winds interacting with land masses.
TURB/LIGHT: Slight changes in altitude, occupants may feel slight strain against seat belts or shoulder straps.
TURB/MOD: Similar to light turbulence, but of greater intensity. Changes in altitude occur but aircraft remains in positive control. Occupants feel definite strains against seat belts.
TURB/SEVERE: There will be large, abrupt changes in altitude, causes large variations in indicated airspeed. Aircraft may be momentarily out of control.
CHOP is a weather condition that refers to bumps in flight. It has light, moderate and severe as intensity types. 
CHOP/LIGHT: Slight, rapid, rhythmic bumps without changes in altitude.
CHOP/MOD: Similar to light chop, greater intensity, still no changes in altitude.
CHOP/SEVERE: Serious bumps with light pressure, often difficult to walk in plane during severe chop.
MTNW (Mountain Wave) is a type of atmospheric gravity wave, generated when air blowing across a mountain range is forced up and over the top. It develops as winds become stronger, which causes significant damage to the structure of aircraft and results in loss of control. Intensities are classified depending on the severity of the wind like light, moderate or severe.

NEG: Removes the category that is selected from the report, before sending it. 
SEND PIREP: Used to send the selected query to the ground station.
Cancel:  Used to cancel the entire selected PIREP before going to the confirmation.
Confirmation: Once the required elements are selected, the pilot can click the send button to report it to the ground station. On clicking the send button, the app asks the pilot for confirmation whether to send the report or not. If the pilot is not sure to send the report, he/she can click NO. If the report is to be sent, the pilot can click on YES. On confirming YES to send the report, the report gets stored in a file which will be sent to the ground station.



METAR Tab: 
METAR stands for Meteorological Terminal Aviation Routine Weather Report. It is a weather information report of every hour. METARs are analyzed from the PIREP report. A pilot can retrieve METAR information from the ground station at his/her desired location of the flight journey. Available METARs are displayed on the map as circles, with each circle representing a METAR.
On clicking the METARs tab, a request is sent to the ground station asking for METARs data. The data obtained will be in Geo-JSON format. The METAR data may consist of a special property called WX property. If the METAR data has WX property then the application maps the WX value to its associated symbol to get the matching image. This image is displayed along with the METAR, on the map.
When the pilot touches a METAR, information about the METAR will be displayed. METAR information consists of Id (code used to identify airport), site information, time of observation, priority level, runway visual range, temperature, location and wind speed. This METAR tab implements a priority algorithm that determines the priority scheme. 
The priority algorithm is implemented to display METARs on the map. Priority scheme sets the zoom level which is used to display data as soon as possible. There are a total of eight zoom levels and they range from zero to seven. Zero has the zoom level of highest priority. When the pilot selects zero priority, METARs with zero priority are displayed. These METARs are of high importance. When the pilot zooms into the next level, that is, first level, METARs with zero and one priority will be displayed on the map.


Wind Bars:
Wind bars are used to show the direction of wind flowing in a location. Several symbols are used to display the wind speed. They are as follows.

When the pilot touches a Wind bar, information about the Windbar will be diplayed. It consists of site informantion, time of observation, priority level, runway visual range, temperature, location and wind speed. This wind bars tab implements a priority algorithm that determines the priority scheme. 



TAFs Tab:
TAF stands for Terminal Aerodrome Forecast. It is a format for reporting weather forecast information which is related to aviation. These TAFs are produced by a human forecaster on the ground. On clicking the TAF tab, a request is sent to the ground station. The ground station generates annotations which are displayed on the map. Each annotation represents the Terminal Aerodrome Forecast report. 
Each TAF report has a time group. The time group is the specific period of time in which specific TAFs are recorded. TAFs are displayed on the map depending on the time group selected. There are eight time groups. 
While TAFs are loading on to the map, loading status is shown. Once all TAFs are loaded, the pilot can click on a particular TAF to view the information associated with it. On clicking a TAF, the information will be displayed on a pop over view. Typical TAF information includes: Id (airport identifier), location, site information, raw data which indicates the airport to which the forecast belongs, issue time (time when TAF is reported) valid time from, valid time to and time group. 


Hazards Tab
The hazards tab is used by the pilot to view various hazardous weather conditions. The hazardous information is displayed as overlays, stretching out and covering particular area on the map in various colors. The hazardous contents that can be displayed are Icing, MTN OBSCN, Turbulence, Convective, ASH and IFR.
Icing is the formation of water ice on the surface of the aircraft. It is of two types – Engine Icing (Icing within the engine) and Airframe Icing (building up of ice on the airframe surface).
MTN OBSCN is the mountain obscuration or mountain ridge obscuration, the likely occurrences of the mountain ridges across the flight path. It is the low visibility at the mountain tops because of the formation of mountainous terrain clouds.
Turbulence is the unsteady movement of air. It can be experienced by the aircraft when the flight is flying low to the ground, where winds interact with landmasses, or when the aircraft is close to a mountain.
Convective is the information about convective SIGMET (Significant Meteorological Information). Any convective SIGMET implies severe or greater turbulence, severe icing and low level wind shear. The SIGMET may be issued for any convective situation which is hazardous to all categories of aircraft. AWC also issues hourly Convective SIGMET warnings for thunderstorms that are a threat to safe aircraft operations. These provide up to the minute information to pilots.
ASH is the Volcanic Ash. Volcanic ash is formed during explosive volcanic eruptions when dissolved gases expand and escape violently into the atmosphere. It can be represented as a SIGMET.
IFR is the Instrument Flight Rules. It is one of the two sets of regulations governing all aspects of civil aviation operations. It is the ceiling less than 1000 feet and visibility less than 3 miles.
The pilot can select all hazards to be displayed on the map or can select particular hazard content, through internal selection. On clicking the hazard tab, a request is sent to the ground station for hazard information. The ground station sends the hazard data in Geo-JSON format; it gets parsed and the application generates overlays for each hazard type in different colors. Overlays are two dimensional representations of the region where the hazards exist. The altitude component is not considered in the two dimensional overlays. The types/contents of the hazard are displayed on the map as an overlay represented in different colors for easy identification. 


Radar and Satellite View Tab:
This tab is used by the pilot for radar view which is an image representation of the radar reflexivity over layed on a location. Radar is the most effective tool to determine precipitation, especially thunderstorms. The colors represent the strength of returned energy to the radar expressed in the values of decibels(dBZ). These dBZ values equate to approximate rainfall rates indicated in the table.

.
Value of 20 dBZ is typically the point at which light rain begins. The values of 60 to 65 dBZ is about the level where ¾" hail can occur. However, a value of 60 to 65 dBZ does not mean that severe weather is occurring at that location.






Satellite View:
Displays the Earth similarly to how humans see it with their eyes or how typical cameras view it.

Settings Tab
The settings tab is used by the pilot to enter airplane information. The pilot can edit the existing information or enter new information. Typical information the pilot needs to enter consists of the Name, Aircraft Type, Tail Number and License. No field can be left empty. If the pilot leaves a field to be empty, he/she cannot use the application and a message will be displayed not to leave any of the fields empty. The information entered will be saved on the app, on clicking save. The information saved will be displayed as existing information at the bottom of the page. There is a link to the user manual at the bottom of the settings tab, which is useful for the pilot to go through the instructions to use the application.
