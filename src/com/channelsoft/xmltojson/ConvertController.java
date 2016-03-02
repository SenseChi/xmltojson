package com.channelsoft.xmltojson;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import net.sf.json.JSON;
import net.sf.json.JSONSerializer;
import net.sf.json.xml.XMLSerializer;

/**
 * @author zt
 *
 */
@Controller
@RequestMapping(value = "/convert")
public class ConvertController
{
	@RequestMapping(value = "/doConvert")
	@ResponseBody
	public String doConvert(String json, HttpServletRequest request, HttpServletResponse response, ModelMap model)
	{
		json = URLDecoder.decode(json);
		System.out.println(json);
		String xmlR = "";
		boolean needReplace = json.indexOf("\"@xmlns:xsi\":\"http://www.w3.org/2001/XMLSchema-instance\",\"@xsi:schemaLocation\":\"http://www.posc.org/schemas Units.xsd\"") > 0;
		if (needReplace) {
			String jsonR = json.replaceFirst("\"@xmlns:xsi\":\"http://www.w3.org/2001/XMLSchema-instance\",\"@xsi:schemaLocation\":\"http://www.posc.org/schemas Units.xsd\",", "");
			String xml = jsonToXml(jsonR);
			xmlR = xml.replaceFirst("xmlns=\"http://www.posc.org/schemas\"", "xmlns=\"http://www.posc.org/schemas\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.posc.org/schemas Units.xsd\"");
		} else {
			xmlR = jsonToXml(json);
		}
		System.out.println(xmlR);
		Date now = new Date();
		String filename = now.getTime() + ".xml";
		String path = request.getSession().getServletContext().getRealPath("/download/");
		try {
			FileOutputStream fos = new FileOutputStream(path + "/" + filename);
            fos.write(xmlR.getBytes());
            fos.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "/download/" + filename;
	}
	
	public static String jsonToXml(String json) {  
        try {  
            XMLSerializer serializer = new XMLSerializer();  
            JSON jsonObject = JSONSerializer.toJSON(json);
            return serializer.write(jsonObject);  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return null;  
    }
}