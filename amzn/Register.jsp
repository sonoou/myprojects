<%@ page session="false" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>

<%
  String firstname = request.getParameter("fname");
  String lastname = request.getParameter("lname");
  String email = request.getParameter("email");
  String contact = request.getParameter("contact");
  String pass = request.getParameter("pass");
  RequestDispatcher rd;
  if(lastname.equals("")){
    lastname = "null";
  }
  
  Class.forName("com.mysql.cj.jdbc.Driver");
  Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/amazon","sonu","15061999");
  Statement st = c.createStatement();
  ResultSet rs = st.executeQuery("SELECT email FROM customer_table WHERE email='"+email+"'");
  if(rs.next()){
    rs = st.executeQuery("SELECT contact FROM customer_table WHERE contact='"+contact+"'");
    if(rs.next()){
      rd = request.getRequestDispatcher("Action.jsp?url=same_both");
      rd.forward(request,response);
    }
    else{
      rd = request.getRequestDispatcher("Action.jsp?url=same_email");
      rd.forward(request,response);
    }
  }
  else{
    rs = st.executeQuery("SELECT contact FROM customer_table WHERE contact='"+contact+"'");
    if(rs.next()){
      rd = request.getRequestDispatcher("Action.jsp?url=same_contact");
      rd.forward(request,response);
    }
    else{
      st.executeUpdate("INSERT INTO customer_table VALUES(CONCAT('c',NEXT VALUE FOR cseq),'"+firstname+"','"+lastname+"','"+email+"','"+contact+"','"+pass+"')");
      rd = request.getRequestDispatcher("Action.jsp?url=login.html");
      rd.forward(request,response);
    }
  }
%>