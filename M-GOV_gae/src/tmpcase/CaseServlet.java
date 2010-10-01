package tmpcase;

import gae.GAEDataBase;
import gae.GAENodeCase;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.*;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;

import com.google.appengine.api.datastore.Blob;

@SuppressWarnings("serial")
public class CaseServlet extends HttpServlet {
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world!");
	}

	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
			uploadData(req, resp);
	}

	private void uploadData(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		// upload photo and save in datastore
		String method = req.getParameter("method");
		if (method.equals("upload")) {
			ServletFileUpload upload = new ServletFileUpload();
			FileItemIterator iterator = null;
			try {
				iterator = upload.getItemIterator(req);
			} catch (FileUploadException e) {
				e.printStackTrace();
			}
			try {
				GAENodeCase node = new GAENodeCase();
				ArrayList<Blob> photos = new ArrayList<Blob>();
				int i = 0;

				while (iterator.hasNext()) {
					FileItemStream item = iterator.next();
					InputStream stream = item.openStream();

					if (item.isFormField()) {
						String field = item.getFieldName();
						byte b[] = new byte[100];
						stream.read(b);
						String value = new String(b,"utf-8");
						value= value.trim();
						
						if ("email".equals(field))				node.email = value;
						else if ("h_admit_name".equals(field)) 	node.h_admit_name = value;
						else if ("h_admiv_name".equals(field)) 	node.h_admiv_name = value;
						else if ("h_summary".equals(field)) 	node.h_summary = value;
						else if ("typeid".equals(field)) 		node.typeid = value;
						else if ("coordx".equals(field))		node.coordx = Double.valueOf(value);
						else if ("coordy".equals(field))		node.coordy = Double.valueOf(value);

						System.out.println(field + ":" + value);
						// Handle form field
					} else {
						// Handle the uploaded file
						Blob bImg = new Blob(IOUtils.toByteArray(stream));
						photos.add(bImg);

						String title = item.getName();
						// Photo photo = new Photo(title, date, bImg);
						// PhotoDao.getInstance().insertPhoto(photo);
					}
				}
				node.setPhoto(photos);

				GAEDataBase.store(node);

//				resp.sendRedirect("photo");
				Blob b = photos.get(0);
				resp.setContentType("image/jpeg;image/png;charset=utf-8");
				resp.getOutputStream().write(b.getBytes());
				resp.getOutputStream().close();
				
			} catch (FileUploadException e) {
				e.printStackTrace();
			}

		}
	}
}
