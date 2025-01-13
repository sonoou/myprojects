<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page session="false" %>

<%
  String user = request.getParameter("user");
  String pass = request.getParameter("pass");
  Class.forName("com.mysql.cj.jdbc.Driver");
  Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/amazon","sonu","15061999");
  Statement st = c.createStatement();
  ResultSet rs = st.executeQuery("SELECT * FROM customer_table WHERE contact='"+user+"' AND pass='"+pass+"' OR email='"+user+"' AND pass='"+pass+"'");
  RequestDispatcher rd;
  if(rs.next()){
    String url = "Action.jsp?url=Amazon.jsp";
    rd = request.getRequestDispatcher(url);
    HttpSession session = request.getSession();
    session.setAttribute("customer_id",rs.getString(1));
    session.setAttribute("user",user);
    session.setAttribute("pass",pass);
    rd.forward(request,response);
    System.setProperty("dbdriver","com.mysql.cj.jdbc.Driver");
    System.setProperty("dburl","jdbc:mysql://localhost:3306/amazon");
    System.setProperty("dbuser","sonu");
    System.setProperty("dbpass","15061999");
  }
  else{
    String url = "Action.jsp?url=invalid";
    rd = request.getRequestDispatcher(url);
    rd.forward(request,response);
  }
%>