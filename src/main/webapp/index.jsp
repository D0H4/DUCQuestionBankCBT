<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.example.bankexam.DbConnector" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>시험</title>
	<link rel="stylesheet" href=css/index.css>
</head>
<body>
    <h1>시험 페이지</h1>
    <form action="submit.jsp" method="post">
		<%
			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DbConnector.getConnection();
				String sql = "SELECT queNum, queCode, queTitle, options, answer, queType "+
						"FROM ( " +
						"SELECT "+
						"CONCAT(ROW_NUMBER() OVER (ORDER BY RAND())) AS queNum, "+
						"q.queCode AS queCode, "+
						"q.queTitle AS queTitle, "+
						"GROUP_CONCAT(o.optTxt ORDER BY RAND() ASC SEPARATOR '<br>') AS options, "+
						"q.queAnswer AS answer, "+
						"q.queType AS queType "+
						"FROM questionTbl q "+
						"JOIN optionTbl o ON q.queCode = o.queCode "+
						"WHERE q.queType = 'N' "+
						"GROUP BY q.queTitle, q.queAnswer, q.queCode "+
						"UNION "+
						"SELECT "+
						"CONCAT(ROW_NUMBER() OVER (ORDER BY RAND())) AS queNum, "+
						"q.queCode AS queCode, "+
						"q.queTitle AS queTitle, "+
						"'' AS options, "+
						"q.queAnswer AS answer, "+
						"q.queType AS queType "+
						"FROM questionTbl q "+
						"WHERE q.queType = 'T' "+
						") AS combined";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(sql);

				int questionCount = 0;
				while(rs.next()){
					if (questionCount % 3 == 0) {
		%>
		<div class="question-row">
			<%
				}
			%>
			<div class="question-item">
				<h3 class="question-title"><%=rs.getString("queNum") %>. <%=rs.getString("queTitle") %></h3>
				<input type="hidden" name="queCode" value="<%=rs.getString("queCode") %>">
				<%
					String queType = rs.getString("queType");
					String answer = "answer" + rs.getRow();
					String options = rs.getString("options");
					String[] optionArr = (options != null && !options.isEmpty()) ? options.split("<br>") : new String[0];

					if ("T".equals(queType)) {
				%>
				<input type="text" id="answer<%=rs.getRow() %>" name="<%=answer%>">
				<%
				} else {
					for (int i = 0; i < optionArr.length; i++) {
				%>
				<input type="radio" id="options" name="<%=answer%>" value="<%=optionArr[i]%>"><%=optionArr[i] %>
				<br>
				<%
						}
					}
				%>
			</div>
			<%
				questionCount++;
				if (questionCount % 3 == 0) {
			%>
		</div>
		<%
				}
			}
			if (questionCount % 3 != 0) {
		%>
		</div>
		<%
			}
		%>
		<br><br>
		<input type="submit" value="정답 제출">
		<%
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					if (rs != null) rs.close();
					if (stmt != null) stmt.close();
					if (conn != null) conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		%>
    </form>
	<form action="admin.jsp">
		<button>관리자 페이지로 이동</button>
	</form>
	<form action="test.jsp">
		<button>테스트 페이지로 이동</button>
	</form>
</body>
</html>
