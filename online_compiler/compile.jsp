<%@ page import="java.io.*" %>

<%! 
  long hit = 0; 
  public void jspDestroy(){
    System.out.println("Connect lost");
  }
%>
<%
  hit++;
  String dirname = "/tmp/servercompiler/"+hit;
  Runtime rn = Runtime.getRuntime();
  rn.exec("mkdir -p "+dirname);
  rn.exec("touch "+dirname+"/Main.java");
  rn.exec("touch "+dirname+"/Main.class");
  rn.exec("chmod -R 777 "+dirname);
  FileWriter fw = new FileWriter(new File(dirname+"/Main.java"));
  PrintWriter pw = new PrintWriter(fw);
  int i=0;
  while(true){
    String value = request.getParameter("line"+ ++i);
    if(value == null){
      break;
    }
    pw.println(value);
  }
  pw.close();
  fw.close();
  Process ps = rn.exec("serverjavac "+dirname);
  BufferedReader output = new BufferedReader(new InputStreamReader(ps.getInputStream()));
  String execout;
  while(true){
    execout = output.readLine();
    if(execout != null){
      out.println(execout);  
    }
    else{
      break;
    }
  }
  rn.exec("rm -r "+dirname);
  output.close();
%>