xquery version "3.0";
module namespace app="busroute/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="busroute/config" at "config.xqm";

(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute: data-template="app:test" or class="app:test" (deprecated). 
 : The function has to take 2 default parameters. Additional parameters are automatically mapped to
 : any matching request or function parameter.
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:test($node as node(), $model as map(*)) {
    <p>Dummy template output generated by function app:test at {current-dateTime()}. The templating
        function was triggered by the data-template attribute <code>data-template="app:test"</code>.</p>
};

declare option exist:serialize "method=xhtml media-type=text/html";

let $my-doc := doc('ROUTE_BUS.xml')
return
<html>
    <head>
        <title>BUS ROUTE DISPLAY</title>
    </head>
    <body>
    <h1>Routes And Fares of Bus in Hong Kong</h1>    
    <p>Service Mode: <br/>A = whole day <br/>N = night <br/>NT = night and specific time <br/>R = regular/day <br/>T = regular and specific time </p>
    <br/>
    <p>Special Type: <br/>
    0 = Not applicable <br/>
    1 = Time or day specific services <br/>
    2 = Separate fare for weekend and Public Holidays <br/>
    3 = Time or day specific and separate fare for weekend and PHs</p>
    <br/>
    <table border="1">
    <thead>
      <tr>
          <th>Bus Route Number</th> 
		  <th>Bus Operator</th>
          <th>Start Station</th>
          <th>End Station</th>
          <th>Full Fare (HK$)</th>
          <th>Journey Time (mins)</th>  
          <th>Service Mode</th> 
          <th>Service Mode</th>           
      </tr>
    </thead>
    <tbody>{
       for $route at $count in $my-doc//ROUTE
            let $route-id := $route/ROUTE_ID/text()
            order by ($route/ROUTE_ID),($route/COMPANY_CODE)
       return
         <tr> {if ($count mod 2) then (attribute bgcolor {'Lavender'}) else ()}
           <td>{$route/ROUTE_NAMEE/text()}</td>
           <td>{$route/COMPANY_CODE/text()}</td>		   
           <td>{$route/LOC_START_NAMEE/text()}</td>
           <td>{$route/LOC_END_NAMEE/text()}</td>	
           <td>{$route/FULL_FARE/text()}</td>
           <td>{$route/JOURNEY_TIME/text()}</td> 
           <td>{$route//SERVICE_MODE}</td> 
           <td>{$route//SPECIAL_TYPE}</td> 
         </tr>
       }</tbody>
     </table>
   </body>
</html>