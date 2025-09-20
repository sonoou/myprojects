package cart;

import java.sql.*;

public class CartTable{

  private String productId;
  private String customerId;

  public long getCartQuantity() throws Exception{
    ResultSet rs1 = getStatement().executeQuery(
      "SELECT quantity FROM cart_table "+
      "WHERE customer_id='"+customerId+"'"
    );
    long totalCartQuantity = 0L;
    while(rs1.next()){
      totalCartQuantity += Long.parseLong(rs1.getString(1));
    }
    return totalCartQuantity;
  }

  private Statement getStatement(){
    try{
      Class.forName(System.getProperty("dbdriver"));
      Connection c = DriverManager.getConnection(
                          System.getProperty("dburl"),
                          System.getProperty("dbuser"),
                          System.getProperty("dbpass")
                        );
      return c.createStatement();
    }
    catch(Exception e){
      System.out.println("\nException in CartTable.getStatement()");
      System.out.println(e);
      return null;
    }
  }

  public void setProductId(String productId){
    this.productId = productId;
  }

  public void setCustomerId(String customerId){
    this.customerId = customerId;
  }

  public boolean add(String quantity){
    ResultSet rs;
    try{
      Statement st = getStatement();
      rs = st.executeQuery(
        "SELECT quantity FROM cart_table WHERE customer_id='"+
        customerId+"' AND product_id='"+productId+"'"
      );
    }
    catch(Exception e){
      System.out.println("\nException CartTable.add(), product quantity");
      System.out.println(e);
      return false;
    }
    
    try{
      if(rs.next()){
        try{
          long oldQuantity = Long.parseLong(rs.getString("quantity"));
          long newQuantity = Long.parseLong(quantity);
          long totalQuantity = oldQuantity + newQuantity;
          Statement st1 = getStatement();
          st1.executeUpdate(
            "UPDATE cart_table SET quantity='"+totalQuantity+
            "' WHERE customer_id='"+customerId+
            "' AND product_id='"+productId+"'"
          );
          
          long totalCartQuantity = getCartQuantity();
          return true;
        }
        catch(Exception e){
          System.out.println("\nException in CartTable.add() method, during cart update");
          System.out.println(e);
          return false;
        }
      }
      else{
        try{
          Statement st1 = getStatement();
          st1.executeUpdate(
            "INSERT INTO cart_table "+
            "VALUE(CONCAT('cart',NEXT VALUE FOR cartseq),'"+
            customerId+"','"+productId+"','"+quantity+"')"
          );
          return true;
        }
        catch(Exception e){
          System.out.println("\nException in CartTable.add(), during cart insert");
          System.out.println(e);
          return false;
        }
      }
    }
    catch(Exception e){
      System.out.println("\nException in CartTable.add(), when calling rs.next()");
      System.out.println(e);
      return false;
    }
  }

  public boolean remove(){
    try{
      Statement st = getStatement();
      st.executeUpdate(
        "DELETE FROM cart_table WHERE customer_id='"+customerId+
        "' AND product_id='"+productId+"'"
      );
      return true;
    }
    catch(Exception e){
      System.out.println("Exception in CartTable.remove()");
      System.out.println(e);
      return false;
    }
  }

  public boolean updateQuantity(String quantity){
    try{
      Statement st = getStatement();
      st.executeUpdate(
        "UPDATE cart_table SET quantity='"+quantity+"'"+
        " WHERE customer_id='"+customerId+"'"+
        " AND product_id='"+productId+"'"
      );
      return true;
    }
    catch(Exception e){
      System.out.println("\nException CartTable.upateQuantity");
      System.out.println(e);
      return false;
    }
  }

  public ResultSet getProductList(){
    Statement st = getStatement();
    ResultSet rs;
    try{
      rs = st.executeQuery(
        "SELECT products_table.id,products_table.image,products_table.name,"+
        "products_table.priceCents,cart_table.quantity FROM products_table "+
        "LEFT JOIN cart_table ON products_table.id=cart_table.product_id "+
        "WHERE cart_table.customer_id='"+customerId+"'"
      );
      return rs;
    }
    catch(Exception e){
      System.out.println("\nException in CartTable.getProductList()");
      System.out.println(e);
      return null;
    }
  }
}