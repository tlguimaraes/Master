package com.crossover.trial.properties;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import java.util.Properties;
import java.util.Set;

/**
 * A dummy implementation of TrialAppProperties, this clearly doesn't work. Candidates SHOULD change 
 * this class to add their implementation. You are also free to create additional classes
 *
 * note: a default constructor is required.
 *
 * @author code test administrator
 */
public class TrialAppProperties implements AppProperties {
	
	private Properties prop = null;

    @Override
    public List<String> getMissingProperties() {
        return Collections.emptyList();
    }

    @Override
    public List<String> getKnownProperties() {
        return Collections.emptyList();
    }

    @Override
    public boolean isValid() {
        return true;
    }

    @Override
    public void clear() {

    }

    @Override
    public Object get(String key) {
        return "dummy";
    }

	@Override
	public String getPropertyType(String propertyName) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	// Get and organize property detail by each property.
	public String getPropertyDetails(String propertyName) {
		System.out.println("=======================================================================");
		System.out.println("GET EACH PROPERTY DETAILS");
		System.out.println("=======================================================================");
		Properties prop = null;
		String strValue = "";
		InputStream in = null;
		//Loading it....
        try {
            prop = new Properties();
            in = this.getClass().getResourceAsStream(propertyName);
            prop.load(in);
            System.out.println("Loading it....");
           
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(prop.keySet());
        System.out.println("All values of the property file : ");
        @SuppressWarnings("rawtypes")
		Enumeration em = prop.keys();
        while(em.hasMoreElements()){
        String str = (String)em.nextElement();
        System.out.println(str + ", "+typeProperty((Object)prop.get(str))+", " + prop.get(str));
        }
        System.out.println("============================END========================================");
        System.out.println("=======================================================================");
		return strValue;
	}

	
	@Override
	public void setPropertybyType(String propertyName, String type) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<String> getMultipleProperties() {
		// TODO Auto-generated method stub
		return null;
	}

	
	 
	    

	@Override
	public String getPropertyValue(String key) {
		// TODO Auto-generated method stub
		return this.prop.getProperty(key);
	}

	@Override
	public Set<Object> getAllKeys(){
        Set<Object> keys = prop.keySet();
        return keys;
 }

	@Override
	// Get each property type by analysing the content value. 
	public String typeProperty(Object o) {
		String type ="";	
		if (o instanceof String)
	    {
			type= "java.lang.String";
	    } else if (o instanceof Integer)
	    {
	    	type= "java.lang.Integer";
	    }else if(Boolean.valueOf(o.toString())){
	    	type= "java.lang.boolean";
		}
		
		return type;
	}

}

