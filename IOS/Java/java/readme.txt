What was requested into this project and status:

1-./main/java/* and ./test/java/* - the conventional folder structure. OK! These folders were implemented per project request.

1. Implement your code within the following project skeleton, please maintain the original structure of the project
and don't make harmful changes in the package hierarchy and the pom file, please download it from here
(http://techtrial.s3.amazonaws.com/System/DevF/properties-dist.zip) OK!

2. Assume the solution will need to scale to about 100 properties OK! Classes related: PropertySkeleton;/config/loadproperties.xml. 
3. Once all URIs are loaded, all properties should be set. Any unset properties are considered an error OK.
NOTE: The method that is doing it is: List<PropertySkeleton> loadPropertiesType()

4. Type safety is important and having a type safe accessor to properties is a requirement. OK!
5. The easier and more centralized the addition / removal of properties the better. OK!
6. Initialization should support loading and combining properties from multiple URIs. OK! 
7. Property files will specified by a uri such as file://, http:// or the custom classpath:resources/. OK!
8. The URI suffix will determine the file format - .properties and .json will be supported initially. OK!
9. If a property is defined more than once, the last source to set that property value “wins” and is considered the final property value. OK!
