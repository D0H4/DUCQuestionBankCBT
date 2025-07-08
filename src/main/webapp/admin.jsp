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
<h1>관리자 기능</h1>

<h2>CSV 파일 업로드</h2>
<form action="admin.jsp" method="post" enctype="multipart/form-data">
  <h3>QuestionTbl (문제) 데이터 업로드</h3>
  <input type="file" name="questionCsvFile" accept=".csv">
  <br><br>
  <h3>OptionTbl (객관식 보기) 데이터 업로드</h3>
  <input type="file" name="optionCsvFile" accept=".csv">
  <br><br>
  <input type="submit" value="업로드 및 저장">
</form>

<hr>

<h2>데이터 전체 삭제</h2>
<p style="color: red;">
  <strong>경고: 이 작업은 모든 문제 및 객관식 보기 데이터를 영구적으로 삭제합니다.</strong>
</p>
<form action="admin.jsp" method="post" onsubmit="return confirm('정말 데이터를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다!');">
  <input type="hidden" name="action" value="deleteAllData">
  <input type="submit" value="모든 데이터 삭제" style="background-color: red; color: white; padding: 10px 20px; border: none; cursor: pointer;">
</form>
<%
  request.setCharacterEncoding("UTF-8");

  Connection connection = null;
  PreparedStatement pstmtQuestion = null;
  PreparedStatement pstmtOption = null;
  Statement stmt = null;

  String action = request.getParameter("action");

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    connection = DbConnector.getConnection();
    connection.setAutoCommit(false);

    if ("deleteAllData".equals(action)) {
      out.println("<h2>데이터 전체 삭제 중...</h2>");
      stmt = connection.createStatement();

      try {
        int deletedOptions = stmt.executeUpdate("DELETE FROM optionTbl");
        out.println("<p style='color: green;'>OptionTbl에서 " + deletedOptions + "개의 레코드를 삭제했습니다.</p>");

        int deletedQuestions = stmt.executeUpdate("DELETE FROM questionTbl");
        out.println("<p style='color: green;'>QuestionTbl에서 " + deletedQuestions + "개의 레코드를 삭제했습니다.</p>");

        connection.commit();
        out.println("<p style='color: green;'><strong>모든 문제 및 보기 데이터가 성공적으로 삭제되었습니다.</strong></p>");

      } catch (SQLException e) {
        connection.rollback();
        out.println("<p style='color: red;'>데이터 삭제 중 오류 발생: " + e.getMessage() + "</p>");
        e.printStackTrace();
      }

    } else {
      out.println("<h2>CSV 파일 데이터베이스 삽입 결과</h2>");
      out.println("<h3>QuestionTbl 데이터 처리</h3>");
      Part questionFilePart = request.getPart("questionCsvFile");
      if (questionFilePart != null && questionFilePart.getSize() > 0) {
        InputStream questionFileContent = questionFilePart.getInputStream();
        Reader questionReader = new InputStreamReader(questionFileContent, "UTF-8");
        CSVParser questionCsvParser = new CSVParser(questionReader, CSVFormat.DEFAULT.withFirstRecordAsHeader());

        String sqlQuestion = "INSERT INTO questionTbl (queCode, queType, queTitle, queAnswer) VALUES (?, ?, ?, ?)";
        pstmtQuestion = connection.prepareStatement(sqlQuestion);

        int successCountQuestion = 0;
        int failCountQuestion = 0;

        for (CSVRecord record : questionCsvParser) {
          try {
            String queCode = record.get("queCode");
            String queType = record.get("queType");
            String queTitle = record.get("queTitle");
            String queAnswer = record.get("queAnswer");

            pstmtQuestion.setString(1, queCode);
            pstmtQuestion.setString(2, queType);
            pstmtQuestion.setString(3, queTitle);
            pstmtQuestion.setString(4, queAnswer);
            pstmtQuestion.addBatch();
            successCountQuestion++;
          } catch (IllegalArgumentException e) {
            out.println("<p style='color: orange;'>QuestionTbl CSV 헤더 오류 또는 데이터 누락 (레코드 건너뜀): " + e.getMessage() + "</p>");
            failCountQuestion++;
          } catch (Exception e) {
            out.println("<p style='color: red;'>QuestionTbl 레코드 처리 중 오류 (레코드 건너뜀): " + e.getMessage() + "</p>");
            failCountQuestion++;
          }
        }
        pstmtQuestion.executeBatch();
        out.println("<p style='color: green;'>QuestionTbl 데이터 삽입 완료!</p>");
        out.println("<p style='color: green;'>성공적으로 삽입된 레코드: " + successCountQuestion + "개</p>");
        if (failCountQuestion > 0) {
          out.println("<p style='color: orange;'>오류로 건너뛴 레코드: " + failCountQuestion + "개</p>");
        }
      } else {
        out.println("<p>QuestionTbl CSV 파일이 선택되지 않았거나 비어 있습니다. 건너뜁니다.</p>");
      }
      out.println("<h3>OptionTbl 데이터 처리</h3>");
      Part optionFilePart = request.getPart("optionCsvFile");
      if (optionFilePart != null && optionFilePart.getSize() > 0) {
        InputStream optionFileContent = optionFilePart.getInputStream();
        Reader optionReader = new InputStreamReader(optionFileContent, "UTF-8");
        CSVParser optionCsvParser = new CSVParser(optionReader, CSVFormat.DEFAULT.withFirstRecordAsHeader());

        String sqlOption = "INSERT INTO optionTbl (queCode, optTxt) VALUES (?, ?)";
        pstmtOption = connection.prepareStatement(sqlOption);

        int successCountOption = 0;
        int failCountOption = 0;

        for (CSVRecord record : optionCsvParser) {
          try {
            String queCode = record.get("queCode");
            String optTxt = record.get("optTxt");

            pstmtOption.setString(1, queCode);
            pstmtOption.setString(2, optTxt);
            pstmtOption.addBatch();
            successCountOption++;
          } catch (IllegalArgumentException e) {
            out.println("<p style='color: orange;'>OptionTbl CSV 헤더 오류 또는 데이터 누락 (레코드 건너뜀): " + e.getMessage() + "</p>");
            failCountOption++;
          } catch (SQLIntegrityConstraintViolationException e) {
            out.println("<p style='color: red;'>OptionTbl 외래 키 오류 (queCode 불일치 또는 없음): " + e.getMessage() + " - 레코드 건너뛰기</p>");
            failCountOption++;
          } catch (Exception e) {
            out.println("<p style='color: red;'>OptionTbl 레코드 처리 중 오류 (레코드 건너뜀): " + e.getMessage() + "</p>");
            failCountOption++;
          }
        }
        pstmtOption.executeBatch();
        out.println("<p style='color: green;'>OptionTbl 데이터 삽입 완료!</p>");
        out.println("<p style='color: green;'>성공적으로 삽입된 레코드: " + successCountOption + "개</p>");
        if (failCountOption > 0) {
          out.println("<p style='color: orange;'>오류로 건너뛴 레코드: " + failCountOption + "개</p>");
        }
      } else {
        out.println("<p>OptionTbl CSV 파일이 선택되지 않았거나 비어 있습니다. 건너뜁니다.</p>");
      }

      connection.commit();
    }

  } catch (SQLException e) {
    if (connection != null) {
      try {
        connection.rollback();
      } catch (SQLException ex) {
        ex.printStackTrace();
      }
    }
    out.println("<p style='color: red;'>데이터베이스 오류: " + e.getMessage() + "</p>");
    e.printStackTrace();
  } catch (Exception e) {
    out.println("<p style='color: red;'>파일 처리 또는 요청 처리 중 오류: " + e.getMessage() + "</p>");
    e.printStackTrace();
  } finally {
    if (stmt != null) { try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); } }
    if (pstmtQuestion != null) { try { pstmtQuestion.close(); } catch (SQLException e) { e.printStackTrace(); } }
    if (pstmtOption != null) { try { pstmtOption.close(); } catch (SQLException e) { e.printStackTrace(); } }
    if (connection != null) { try { connection.close(); } catch (SQLException e) { e.printStackTrace(); } }
  }
%>