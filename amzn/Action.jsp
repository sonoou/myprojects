<%@ page session="false" %>
<%
  String url = request.getParameter("url");
  String message = request.getParameter("message");
  RequestDispatcher rd;
  
  if(url.equals("Validate")){
    rd = request.getRequestDispatcher("Validate.jsp");
    rd.forward(request,response);
  }
  else if(url.equals("register")){
    rd = request.getRequestDispatcher("Register.jsp");
    rd.forward(request,response);
  }
  else if(url.equals("cartupdate")){
    rd = request.getRequestDispatcher("CartUpdate.jsp");
    rd.forward(request,response);
  }
  else if(url.equals("singleproduct")){
    rd = request.getRequestDispatcher("SingleProduct.jsp");
    rd.forward(request,response);
  }
  else{
    out.println(url);
  }
%>