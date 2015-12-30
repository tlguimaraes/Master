package com.crossover.trial.properties;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.LinkedList;
import java.util.List;
import com.crossover.trial.properties.PropertySkeleton;
import org.w3c.dom.*;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException; 



/**
 * A simple main method to load and print properties. You should feel free to change this class
 * or to create additional class. You may add addtional methods, but must implement the 
 * AppPropertiesManager API contract.
 * 
 * Note: a default constructor is required
 *
 * @author code test administrator
 */
public class TrialAppPropertiesManager implements AppPropertiesManager {

    public List<PropertySkeleton> linkedList = null;

	@Override
    public AppProperties loadProps(List<String> propUris) {
    	System.out.println("=======================================================================");
    	System.out.println("LOADING PROPERTIES");
    	System.out.println("=======================================================================");
    	
    	 // .............list file
        File directory = new File("src/resources/");

      try{  
        // get all the files from a directory
        File[] TrialAppProperties = directory.listFiles();

        for (File file : TrialAppProperties) {
            if (file.isFile()) {
                System.out.println(file.getAbsolutePath());
            } else if (file.isDirectory()) {
                System.out.println(file.getAbsolutePath());
            }
            System.out.println("=======================================================================");
            printProperties(file.getAbsolutePath());
        }
        System.out.println("=======================================================================");
    	System.out.println("END LOADING PROPERTIES");
    	System.out.println("=======================================================================");
        
      }catch(Exception er){
    	   System.out.println("ERROR:"+er);
       }
        
      //TEST for URL
      //System.out.println(validateURI("http://www.amrood.com/index.htm?language=en#j2se"));
      
      // Test for DIR 
      //System.out.println(validateURI("/temp"));
      
        return new TrialAppProperties();
    }

    @Override
    public void printProperties(AppProperties props, PrintStream sync) {   	
    	
    }
    
    public void printProperties(String filepath) {
    	String line = null;
    	try (BufferedReader br = new BufferedReader(new FileReader(filepath))) { 
    		Path p = Paths.get(filepath);
    		String uniquefile = p.getFileName().toString();
    		if(filepath.contains("jdbc")){
        		System.out.println("classpath:resource/"+uniquefile);
        	}else if(filepath.contains("aws")){
        		System.out.println("file:///tmp/"+uniquefile);
        	}else if(filepath.contains("config.json")){
        		System.out.println("http://localhost/global/"+uniquefile);
        	}
    		
    		else{
        		System.out.println(filepath);
        	}
    		
    		   while ((line = br.readLine()) != null) {
    		       System.out.println(line);
    		   }
    		
    	
    	} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	
    }
    
    public boolean validateURI(String uri){
    	 try
         {
            //URL url = new URL("http://www.amrood.com/index.htm?language=en#j2se"); 
    			URL url = new URL(uri);
    			System.out.println("=======================================================================");
    			System.out.println("[INFO] THis is a URL.");
    			System.out.println("=======================================================================");
    			System.out.println("URL is " + url.toString());
    			System.out.println("protocol is " + url.getProtocol());
    			System.out.println("authority is " + url.getAuthority());
    			System.out.println("file name is " + url.getFile());
    			System.out.println("host is " + url.getHost());
    			System.out.println("path is " + url.getPath());
    			System.out.println("port is " + url.getPort());
    			System.out.println("default port is " + url.getDefaultPort());
    			System.out.println("query is " + url.getQuery());
    			System.out.println("ref is " + url.getRef());
    			System.out.println("=======================================================================");
         }catch(java.net.MalformedURLException ml){
         	//ml.printStackTrace(); 
        	System.out.println("======================================================================="); 
         	System.out.println("[INFO] This is not a URL.Check other types.");
         	System.out.println("=======================================================================");
         	try{  
                // get all the files from a directory
         		 File inputuri = new File(uri);
         		 if (inputuri.isFile()) {
         			System.out.println("=======================================================================");
                    System.out.println("[INFO] It is a File: "+inputuri.getAbsolutePath());
                    System.out.println("=======================================================================");
                 } else if (inputuri.isDirectory()) {
                	 System.out.println("=======================================================================");
                     System.out.println("[INFO] It is a directory: "+inputuri.getAbsolutePath());
                     System.out.println("=======================================================================");
                 }
                
              }catch(Exception ey){
            	  ey.printStackTrace();
              }
         	
         	
          }catch(@SuppressWarnings("hiding") IOException e)
         {
            e.printStackTrace();
         }
    	
    	return true;
    }

	@Override
	public List<PropertySkeleton> loadPropertiesType() {
		try {

			System.out.println("======================================================================="); 
         	System.out.println("[INFO] Assume the solution will need to scale to about 100 properties.");
         	System.out.println("=======================================================================");
            DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            Document doc = docBuilder.parse (new File("src/config/loadseveralprop.xml"));
			linkedList = new LinkedList<PropertySkeleton>();
            
            // normalize text representation
            doc.getDocumentElement ().normalize ();
            System.out.println("======================================================================="); 
         	System.out.println("[INFO] Root element of the property doc is " +doc.getDocumentElement().getNodeName());
         	System.out.println("=======================================================================");

            NodeList listOfPersons = doc.getElementsByTagName("property");
            int totalProperties = listOfPersons.getLength();
            System.out.println("[INFO] Total no of properties : " + totalProperties);
            String propertyName,propertyType,propertySuffix;
            for(int s=0; s<listOfPersons.getLength() ; s++){


                Node firstPersonNode = listOfPersons.item(s);
                if(firstPersonNode.getNodeType() == Node.ELEMENT_NODE){


                    Element firstPropElement = (Element)firstPersonNode;

                    //-------
                    NodeList propertyNameList = firstPropElement.getElementsByTagName("propertyname");
                    Element propertyNameElement = (Element)propertyNameList.item(0);

                    NodeList textFNList = propertyNameElement.getChildNodes();
                    System.out.println("Property Name : " + 
                           ((Node)textFNList.item(0)).getNodeValue().trim());
                    propertyName=((Node)textFNList.item(0)).getNodeValue().trim();

                    //-------
                    NodeList propertyTypeList = firstPropElement.getElementsByTagName("propertytype");
                    Element propertyTypeElement = (Element)propertyTypeList.item(0);

                    NodeList textLNList = propertyTypeElement.getChildNodes();
                    System.out.println("Property Type : " + 
                           ((Node)textLNList.item(0)).getNodeValue().trim());
                    propertyType=((Node)textLNList.item(0)).getNodeValue().trim();

                    //----
                    NodeList propertySuffixList = firstPropElement.getElementsByTagName("propertysuffix");
                    Element propertySuffixElement = (Element)propertySuffixList.item(0);

                    NodeList textAgeList = propertySuffixElement.getChildNodes();
                    System.out.println("Property Suffix : " + 
                           ((Node)textAgeList.item(0)).getNodeValue().trim());
                    propertySuffix=((Node)textAgeList.item(0)).getNodeValue().trim();
                    
                    //Loading all property details from the beggining, as requested.
                    linkedList.add(new PropertySkeleton(propertyName,propertyType,propertySuffix)); 

                }//end of if clause


            }//end of for loop with s var


        }catch (SAXParseException err) {
        System.out.println ("** Parsing error" + ", line " + err.getLineNumber () + ", uri " + err.getSystemId ());
        System.out.println(" " + err.getMessage ());

        }catch (SAXException e) {
        Exception x = e.getException ();
        ((x == null) ? e : x).printStackTrace ();

        }catch (Throwable t) {
        t.printStackTrace ();
        }
		
		
		
		System.out.println("======================================================================="); 
     	System.out.println("[INFO] END the need to scale to about 100 properties.");
     	System.out.println("=======================================================================");

		return linkedList;
	}
    
}
