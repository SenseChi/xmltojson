package com.channelsoft.xmltojson;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import net.sf.json.xml.XMLSerializer;

/**
 * @author typ
 *
 */
@Controller
@RequestMapping(value = "/file")
public class UploadController
{

	/**
	 * ??????????????????
	 *
	 * @param request
	 * @param response
	 * @param model
	 * @throws IOException
	 */
	@RequestMapping(value = "/upload")
	public ModelAndView upload(HttpServletRequest request, HttpServletResponse response, ModelMap model)
	        throws IOException
	{
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile mFile = multipartRequest.getFile("file");
		String path = request.getSession().getServletContext().getRealPath("/WEB-INF/");
		String filename = mFile.getOriginalFilename();
		InputStream inputStream = mFile.getInputStream();
		byte[] b = new byte[1048576];
		int length = inputStream.read(b);
		path += "\\" + filename; // ?????÷????·????÷??
		FileOutputStream outputStream = new FileOutputStream(path);
		outputStream.write(b, 0, length);
		inputStream.close();
		outputStream.close();

		String fileContent = read(path,"UTF-8");

		System.out.println("????"+path);
		String str = new XMLSerializer().read(fileContent).toString();
		System.out.println(str);
		return new ModelAndView("message", "str", str);

	}

	public static String read(String path, String encoding) throws IOException
	{
		String content = "";
		File file = new File(path);
		BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), encoding));
		String line = null;
		while ((line = reader.readLine()) != null)
		{
			content += line;
		}
		reader.close();
		return content;
	}
}