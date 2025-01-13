<%@ page session="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html lang="en">
<body>
  <% 
    HttpSession session = request.getSession(false);
    String customerId = "";
    String customerName = "";
    long totalCartQuantity = 0L;
    String cartQuantityStr = "";
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection c = DriverManager.getConnection(
      "jdbc:mysql://localhost:3306/amazon",
      "sonu",
      "15061999"
    );

    if(session != null){
      customerId = (String)session.getAttribute("customer_id");
      ResultSet rs1 = c.createStatement().executeQuery(
        "SELECT customer_table.fname, cart_table.quantity "+
        "FROM customer_table LEFT JOIN cart_table ON "+
        "customer_table.id=cart_table.customer_id WHERE "+
        "customer_table.id='"+customerId+"'"
      );
      
      rs1.next();
      customerName = rs1.getString(1);
  %>
  <jsp:useBean id="cartTable" class="cart.CartTable" />
  <jsp:setProperty name="cartTable" property="customerId" value="<%= customerId %>" />
  <%
      totalCartQuantity = cartTable.getCartQuantity();
    }

    if(totalCartQuantity < 10L){
      cartQuantityStr = "0"+totalCartQuantity;
    }
    else{
      cartQuantityStr = new Long(totalCartQuantity).toString();
    }
  %>
  <div class="navbar-container display-flex">
    <a href="Amazon.jsp" class="logo-container">
      <img src="images/amazon-logo-white.png" atl="amazon-logo">
    </a>
    <div class="search-container display-flex">
      <input type="text" id="search-box" placeholder="Search">
      <button class="search-button">
        <img src="images/icons/search-icon.png" atl="search-icon">
      </button>
    </div>
    <div class="login-container font-white">
      <% 
        if(session == null){
      %>
        <a href="login.html" class="display-flex font-white text-decoration-none">Login</a>
      <%
        }
        else{
      %>
        <%= customerName %>
      <%
        }
      %>
    </div>
    <div class="orders-cart-container display-flex">
      <a href="#" class="orders-container font-white">
        <div>Return</div>
        <div>& Orders</div>
      </a>
      <a href="CartView.jsp" class="cart-container font-white display-flex">
        <img src="images/icons/cart-icon.png" alt="cart-icon">
        <div class="cart-quantity"><%= cartQuantityStr %></div>
        <div class="cart-label">Cart</div>
      </a>
    </div>
  </div>
</body>
</html>