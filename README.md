# oracle-apex-calendar-heatmap-region-plugin
An oracle APEX region plugin to show a calendar heatmap.

Demo
https://kjwvivmv0n5reuj-apexkqor.adb.uk-london-1.oraclecloudapps.com/ords/r/test1/plugin/home?session=105323527211920

An Oracle APEX calendar region plugin using Apache ECharts an Open Source JavaScript Visualization Library to display a 
calendar heatmap in your APEX app. The example above displays 2022 data from the SQL demo code below. 
If you want 2021 data change the 'Year to display' attribute to 2021. 


The SQL creates a years worth of dates from today, you can change the year in attributes. You can also click on the legend to turn values on or off.

Instructions 
---------------------------------------------------
Download the plugin

Install the plugin - Shared Components->plugins->import

Create a new region with type calendar-heatmap

Change source type to SQL Query then copy the demo SQL in.


You can leave attributes blank to start as it will use default settings.

Demo SQL
---------------------------------------------------
SELECT TO_CHAR( TRUNC (SYSDATE - ROWNUM), 'MM/DD/YYYY' ) dt, round(dbms_random.value() * 10000) + 1 FROM DUAL CONNECT BY ROWNUM < 366

I use the following SQL to pull data into the plugin

select TO_CHAR( updated_date, 'MM/DD/YYYY' ), count(*) from pdr group by TO_CHAR( updated_date, 'MM/DD/YYYY' )

as I have maximum values of 10 a day I set max value to 8 so we get >8 in the legend.


Attributes
---------------------------------------------------
Chart name - empty shows no title

Year to display - defaults to 2022

Border width - defaults to 0.5

Max value - maximum value to display - defaults to 10000

Container name - if you have more than 1 then you need to set the container name so its unique - defaults to container


