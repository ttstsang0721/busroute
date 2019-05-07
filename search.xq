xquery version "3.1";
declare namespace functx = "http://www.functx.com";
declare function functx:contains-case-insensitive
  ( $arg as xs:string? ,
    $substring as xs:string )  as xs:boolean? {

   contains(upper-case($arg), upper-case($substring))
 } ;
 
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $title := 'Bus Route Search Result Page'
let $data := doc('ROUTE_BUS.xml')

(: get the search query string from the URL parameter :)
let $routeno := request:get-parameter('routeno', '')
let $startstation := request:get-parameter('startstation', '')
let $endstation := request:get-parameter('endstation', '')
let $operator := request:get-parameter('operator', '')

return
<html>
    <head>
       <title>{$title}</title>
     </head>
     <body>
        <h1><b>Searching in ROUTE_BUS.xml for:</b></h1>
        <p>Bus number starts with: {$routeno} <br/>Start Station Name contains: {$startstation} <br/>End Station Name contains: {$endstation} <br/>Operated by: {$operator} </p>
        <p> </p>
        <p> </p>
        <h1>Search Results: </h1>
        <p> </p> 
        <p>Service Mode: <br/>A = whole day <br/>N = night <br/>NT = night and specific time <br/>R = regular/day <br/>T = regular and specific time </p>        
        <p> </p> 
        <p> </p>
        <p>Special Type: <br/>
        0 = Not applicable <br/>
        1 = Time or day specific services <br/>
        2 = Separate fare for weekend and Public Holidays <br/>
        3 = Time or day specific and separate fare for weekend and PHs</p>
        <p> </p>       
        <table border="1">
        <thead>
        <tr> 
            <th>Route Number</th>
            <th>Bus Operator</th>
            <th>Start Station</th>
            <th>End Station</th>
            <th>Full Fare (HK$)</th>
            <th>Journey Time (mins)</th>
            <th>Service Mode</th> 
            <th>Specical Type</th> 
        </tr>
        </thead>
        <tbody>
        {
        if ($routeno = "")
        then (
            if ($operator = "All Operators")
            then (
                if ($startstation = "")
                then (
                    if ($endstation = "")
                        then (
                            for $route in $data//ROUTE
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td>
                            <td>{data($route//SERVICE_MODE)}</td>
                            <td>{data($route//SPECIAL_TYPE)}</td>                            
                            </tr>
                            )
                        else (
                            for $route in $data//ROUTE[functx:contains-case-insensitive(LOC_END_NAMEE/text(), $endstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td> 
                            <td>{data($route//SERVICE_MODE)}</td>  
                            <td>{data($route//SPECIAL_TYPE)}</td>                            
                            </tr>
                            )
                    )
                else if ($endstation = "")
                        then (
                            for $route in $data//ROUTE[functx:contains-case-insensitive(LOC_START_NAMEE/text(), $startstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td> 
                            <td>{data($route//JOURNEY_TIME)}</td> 
                            <td>{data($route//SERVICE_MODE)}</td>
                            <td>{data($route//SPECIAL_TYPE)}</td>                            
                            </tr>
                            )
                        else (
                            for $route in $data//ROUTE[functx:contains-case-insensitive(LOC_START_NAMEE/text(), $startstation)][functx:contains-case-insensitive(LOC_END_NAMEE/text(), $endstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td> 
                            <td>{data($route//JOURNEY_TIME)}</td>   
                            <td>{data($route//SERVICE_MODE)}</td>  
                            <td>{data($route//SPECIAL_TYPE)}</td>                            
                            </tr>
                            )
                    )
            else 
                if ($startstation = "")
                then (
                    if ($endstation = "")
                        then (
                            for $route in $data//ROUTE[COMPANY_CODE/text() = $operator]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td> 
                            <td>{data($route//JOURNEY_TIME)}</td>  
                            <td>{data($route//SERVICE_MODE)}</td>
                            <td>{data($route//SPECIAL_TYPE)}</td>                            
                            </tr>
                            )
                        else (
                            for $route in $data//ROUTE[COMPANY_CODE/text() = $operator][functx:contains-case-insensitive(LOC_END_NAMEE/text(), $endstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td>
                            <td>{data($route//SERVICE_MODE)}</td>  
                            <td>{data($route//SPECIAL_TYPE)}</td>                            
                            </tr>
                            )
                    )
                else if ($endstation = "")
                        then (
                            for $route in $data//ROUTE[COMPANY_CODE/text() = $operator][functx:contains-case-insensitive(LOC_START_NAMEE/text(), $startstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td>
                            <td>{data($route//SERVICE_MODE)}</td>  
                            <td>{data($route//SPECIAL_TYPE)}</td>                            
                            </tr>
                            )
                        else (
                            for $route in $data//ROUTE[COMPANY_CODE/text() = $operator][functx:contains-case-insensitive(LOC_START_NAMEE/text(), $startstation)][functx:contains-case-insensitive(LOC_END_NAMEE/text(), $endstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td>
                            <td>{data($route//SERVICE_MODE)}</td>   
                            <td>{data($route//SPECIAL_TYPE)}</td>                            
                            </tr>
                            )
        )
        else (
            if ($operator = "All Operators")
            then (
                if ($startstation = "")
                then (
                    if ($endstation = "")
                        then (
                            for $route in $data//ROUTE[starts-with(ROUTE_NAMEE/text(),upper-case($routeno))]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td>  
                            <td>{data($route//SERVICE_MODE)}</td>  
                            <td>{data($route//SPECIAL_TYPE)}</td>
                            </tr>
                            )
                        else (
                            for $route in $data//ROUTE[starts-with(ROUTE_NAMEE/text(),upper-case($routeno))][functx:contains-case-insensitive(LOC_END_NAMEE/text(), $endstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td>
                            <td>{data($route//SERVICE_MODE)}</td>  
                            <td>{data($route//SPECIAL_TYPE)}</td>
                            
                            </tr>
                            )
                    )
                else if ($endstation = "")
                        then (
                            for $route in $data//ROUTE[starts-with(ROUTE_NAMEE/text(),upper-case($routeno))][functx:contains-case-insensitive(LOC_START_NAMEE/text(), $startstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td> 
                            <td>{data($route//JOURNEY_TIME)}</td>    
                            <td>{data($route//SERVICE_MODE)}</td>   
                            <td>{data($route//SPECIAL_TYPE)}</td>
                            </tr>
                            )
                        else (
                            for $route in $data//ROUTE[starts-with(ROUTE_NAMEE/text(),upper-case($routeno))][functx:contains-case-insensitive(LOC_START_NAMEE/text(), $startstation)][functx:contains-case-insensitive(LOC_END_NAMEE/text(), $endstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td> 
                            <td>{data($route//JOURNEY_TIME)}</td>
                            <td>{data($route//SERVICE_MODE)}</td>    
                            <td>{data($route//SPECIAL_TYPE)}</td>
                            </tr>
                            )
                    )
            else 
                if ($startstation = "")
                then (
                    if ($endstation = "")
                        then (
                            for $route in $data//ROUTE[starts-with(ROUTE_NAMEE/text(),upper-case($routeno))][COMPANY_CODE/text() = $operator]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td> 
                            <td>{data($route//JOURNEY_TIME)}</td>   
                            <td>{data($route//SERVICE_MODE)}</td> 
                            <td>{data($route//SPECIAL_TYPE)}</td>
                            </tr>
                            )
                        else (
                            for $route in $data//ROUTE[starts-with(ROUTE_NAMEE/text(),upper-case($routeno))][COMPANY_CODE/text() = $operator][functx:contains-case-insensitive(LOC_END_NAMEE/text(), $endstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td> 
                            <td>{data($route//SERVICE_MODE)}</td>  
                            <td>{data($route//SPECIAL_TYPE)}</td>
                            </tr>
                            )
                    )
                else if ($endstation = "")
                        then (
                            for $route in $data//ROUTE[starts-with(ROUTE_NAMEE/text(),upper-case($routeno))][COMPANY_CODE/text() = $operator][functx:contains-case-insensitive(LOC_START_NAMEE/text(), $startstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td>   
                            <td>{data($route//SERVICE_MODE)}</td> 
                            <td>{data($route//SPECIAL_TYPE)}</td>
                            </tr>
                            )
                        else (
                            for $route in $data//ROUTE[starts-with(ROUTE_NAMEE/text(),upper-case($routeno))][COMPANY_CODE/text() = $operator][functx:contains-case-insensitive(LOC_START_NAMEE/text(), $startstation)][functx:contains-case-insensitive(LOC_END_NAMEE/text(), $endstation)]
                            return <tr> 
                            <td>{data($route//ROUTE_NAMEE)}</td>
                            <td>{data($route//COMPANY_CODE)}</td>
                            <td>{data($route//LOC_START_NAMEE)}</td>
                            <td>{data($route//LOC_END_NAMEE)}</td>
                            <td>{data($route//FULL_FARE)}</td>  
                            <td>{data($route//JOURNEY_TIME)}</td>  
                            <td>{data($route//SERVICE_MODE)}</td>
                            <td>{data($route//SPECIAL_TYPE)}</td>
                            </tr>
                        
                            )
        )            
            
        }   
    </tbody></table>
   </body>
</html>
