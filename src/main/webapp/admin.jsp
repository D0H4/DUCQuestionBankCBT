<%--
  Created by IntelliJ IDEA.
  User: doha
  Date: 7/17/24
  Time: 1:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.io.*,java.sql.*,java.util.*" %>
<%@ page import="org.apache.commons.*" %>
<%@ page import="org.apache.commons.csv.CSVParser" %>
<%@ page import="org.apache.commons.csv.CSVFormat" %>
<%@ page import="org.apache.commons.csv.CSVRecord" %>
<%@ page import="org.example.bankexam.DbConnector" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<form action="admin.jsp" method="post" enctype="multipart/form-data">
  <input type="file" name="file" accept=".csv">
  <input type="submit" value="questionTbl">
</form>
<form action="admin.jsp" method="post" enctype="multipart/form-data">
  <input type="file" name="file" accept=".csv">
  <input type="submit" value="questionTbl">
</form>
<%
  Statement stmt = null;
  ResultSet rs = null;

  Connection connection = null;
  PreparedStatement preparedStatement = null;

  String sql = "INSERT INTO questionTbl (column1, column2, column3) VALUES (?, ?, ?)";

  try {
    // 파일 업로드 처리
    Part filePart = request.getPart("file");
    InputStream fileContent = filePart.getInputStream();

    // CSV 파일 파싱
    Reader reader = new InputStreamReader(fileContent);

    CSVParser csvParser = new CSVParser(reader, CSVFormat.DEFAULT.withFirstRecordAsHeader());

    // 데이터베이스 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    connection = DbConnector.getConnection();
    preparedStatement = connection.prepareStatement(sql);

    // CSV 레코드를 데이터베이스에 삽입
    for (CSVRecord record : csvParser) {
      preparedStatement.setString(1, record.get("column1"));
      preparedStatement.setString(2, record.get("column2"));
      preparedStatement.setString(3, record.get("column3"));
      preparedStatement.executeUpdate();
    }


  } catch (Exception e) {
    e.printStackTrace();
  } finally {
    // 리소스 해제
    if (preparedStatement != null) preparedStatement.close();
    if (connection != null) connection.close();
  }
%>