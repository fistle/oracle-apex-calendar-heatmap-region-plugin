prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_220100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.2'
,p_default_workspace_id=>9850767432578500
,p_default_application_id=>144
,p_default_id_offset=>0
,p_default_owner=>'TEST1'
);
end;
/
 
prompt APPLICATION 144 - APEX plugins
--
-- Application Export:
--   Application:     144
--   Name:            APEX plugins
--   Date and Time:   07:25 Thursday August 25, 2022
--   Exported By:     DAVID
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 21515165615141251
--   Manifest End
--   Version:         22.1.2
--   Instance ID:     9750663202120450
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/region_type/glasgow_calendar_heatmap
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(21515165615141251)
,p_plugin_type=>'REGION TYPE'
,p_name=>'GLASGOW-CALENDAR-HEATMAP'
,p_display_name=>'calendar-heatmap'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/**',
'Function:       Region render',
'Create Date:    22/08/2022',
'Author:         David Lang davielang@gmail.com',
'Description     An Oracle APEX calendar region plugin using Apache ECharts an Open Source ',
'                JavaScript Visualization Library to display a calendar heatmap in your APEX app. ',
'',
'                See https://echarts.apache.org/',
'**/',
'',
'function render(',
'  p_region              in apex_plugin.t_region,',
'  p_plugin              in apex_plugin.t_plugin,',
'  p_is_printer_friendly in boolean) return apex_plugin.t_region_render_result is',
'',
'begin',
'declare',
'    l_app     NUMBER := v (''APP_ID'');',
'    l_session NUMBER := v (''APP_SESSION'');',
'',
'    query_result          apex_plugin_util.t_column_value_list;',
'',
'    -- get the custon attributes to style the region',
'    chartName VARCHAR(100) := nvl(p_region.attribute_01, '''');',
'    yearToDisplay VARCHAR(100) := nvl(p_region.attribute_03, ''2022'');',
'    borderWidth VARCHAR(100) := nvl(p_region.attribute_04, ''0.5'');',
'    maxValueNumber VARCHAR(100) := nvl(p_region.attribute_05, ''10000'');',
'    containerName VARCHAR(100) := nvl(p_region.attribute_06, ''container'');',
'   ',
'begin',
'  -- get the SQL source which we are going to insert into the JavaScript that renders the chart.',
'  query_result := apex_plugin_util.get_data (',
'    p_sql_statement      => p_region.source,',
'    p_min_columns        => 1,',
'    p_max_columns        => 20,',
'    p_component_name     => p_region.name); ',
'',
'-- include echarts lib',
'HTP.p (''<script src="https://fastly.jsdelivr.net/npm/echarts@5.3.3/dist/echarts.min.js"></script>'');',
'',
'-- this is where the chart will be displayed',
'HTP.p (''<div id="''||containerName||''" style="height: 250%"></div>'');',
'',
'-- declare the chart and insert attributes',
'HTP.p (''<script>'');',
'',
'HTP.p (''',
'    var dom = document.getElementById(''''''||containerName||'''''');',
'    var myChart = echarts.init(dom, null, {',
'      renderer: ''''canvas'''',',
'      useDirtyRect: false',
'    });',
'    var app = {};',
'    ',
'    var option;',
'',
'    option = {',
'      title: {',
'        top: 30,',
'        left: ''''center'''',',
'        text: ''''''||chartName||''''''',
'      },',
'      tooltip: {',
'        formatter: ''''{b0} {c0}''''',
'      },',
'      visualMap: {',
'        min: 0,',
'        max: '' || maxValueNumber || '',',
'        maxOpen: true,',
'        type: ''''piecewise'''',',
'        orient: ''''horizontal'''',',
'        left: ''''center'''',',
'        top: 65',
'      },',
'      calendar: {',
'        top: 120,',
'        left: 30,',
'        right: 30,',
'        cellSize: [''''auto'''', 13],',
'        range: '''''' || yearToDisplay || '''''',',
'        itemStyle: {',
'          borderWidth: '' || borderWidth || ''',
'        },',
'        yearLabel: { show: false }',
'      },',
'      series: {',
'        type: ''''heatmap'''',',
'        coordinateSystem: ''''calendar'''',',
'        data: getVirtulData()',
'      }',
'    };',
'',
'    if (option && typeof option === ''''object'''') {',
'      myChart.setOption(option);',
'    }',
'    window.addEventListener(''''resize'''', myChart.resize);',
''');',
'',
'-- declare the function that will get the data points from the SQL',
'HTP.p (''function getVirtulData() {'');',
'HTP.p (''var data = [];'');',
'',
'-- get the data from SQL source and put it into JS code.',
'for rowNumber in query_result(1).first .. query_result(1).last loop  ',
'    -- Get the SQL data as a Javascript date',
'    HTP.p (''var dateColumnValue =  Date.parse(''''''|| to_CHAR (query_result(1)(rowNumber)) || '''''',''''MM/DD/YYYY'''')'');',
'    HTP.p (''data.push(['');     ',
'        HTP.p (''echarts.format.formatTime(''''yyyy-MM-dd'''',dateColumnValue),'');',
'        HTP.p (''''|| query_result(2)(rowNumber) || '''');',
'    HTP.p ('']);'');',
'end loop;',
'HTP.p (''return data;'');',
'HTP.p (''}'');',
'HTP.p (''</script>'');',
'',
'return null;',
'end;',
'end;'))
,p_api_version=>2
,p_render_function=>'render'
,p_standard_attributes=>'SOURCE_LOCATION'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'<a target="_blank" href="https://kjwvivmv0n5reuj-apexkqor.adb.uk-london-1.oraclecloudapps.com/ords/r/test1/calendar-plugin/home?">demo</a>'
,p_version_identifier=>'1.0'
,p_about_url=>'https://kjwvivmv0n5reuj-apexkqor.adb.uk-london-1.oraclecloudapps.com/ords/r/test1/calendar-plugin/home'
,p_files_version=>24
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(21515348305141254)
,p_plugin_id=>wwv_flow_imp.id(21515165615141251)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Chart name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>100
,p_is_translatable=>false
,p_help_text=>'Will appear on the top of the heat map. Leave blank to remove'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(21515749201141254)
,p_plugin_id=>wwv_flow_imp.id(21515165615141251)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Year to display'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'If your data spans several year you must choose a year to display as the heatmap displays one calendars worth of data. Defaults to 2022'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(21516150131141255)
,p_plugin_id=>wwv_flow_imp.id(21515165615141251)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Border width'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_examples=>'0.2, 0.5, 1, 2 etc'
,p_help_text=>'Border width of the heat map - defaults to 0.5'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(21689201568964416)
,p_plugin_id=>wwv_flow_imp.id(21515165615141251)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Max Value'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(21930663324392662)
,p_plugin_id=>wwv_flow_imp.id(21515165615141251)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Container name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_std_attribute(
 p_id=>wwv_flow_imp.id(21516846460141258)
,p_plugin_id=>wwv_flow_imp.id(21515165615141251)
,p_name=>'SOURCE_LOCATION'
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
