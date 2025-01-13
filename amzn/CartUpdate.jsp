<%@ page session="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%
  RequestDispatcher rd;
  HttpSession session = request.getSession(false);
  if(session == null){
    rd = request.getRequestDispatcher("Action.jsp?url=login.html");
    rd.forward(request,response);
  }
  else{
    String customerId = (String)session.getAttribute("customer_id");
    String productId = request.getParameter("productid");
    String quantity = request.getParameter("quantity");
%>
<jsp:useBean id="cartTable" class="cart.CartTable" />
<jsp:setProperty name="cartTable" property="customerId" value="<%= customerId %>" />
<jsp:setProperty name="cartTable" property="productId" value="<%= productId %>" />      
<%
    long totalCartQuantity = 0L;
    if(cartTable.add(quantity)){
      totalCartQuantity = cartTable.getCartQuantity();
    }
    rd = request.getRequestDispatcher("Action.jsp?url=total:"+totalCartQuantity);
    rd.forward(request,response);
  }
%>