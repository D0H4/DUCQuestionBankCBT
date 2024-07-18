<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.example.bankexam.DbConnector" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>시험 결과 페이지</title>
</head>
<body>
    <h1>시험 결과 페이지</h1>
    <%
    request.setCharacterEncoding("utf-8");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // MySQL 드라이버 로딩
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DbConnector.getConnection();

        Enumeration<String> parameterNames = request.getParameterNames();

        String[] queCodeArr = request.getParameterValues("queCode");

        Map<String, Integer> questionScores = new HashMap<>();

        String sql = "SELECT queCode, queAnswer, queType " +
                "FROM questionTbl " +
                "WHERE queCode = ?";

        stmt = conn.prepareStatement(sql);

        for (int i = 1; i <= queCodeArr.length; i++) {

            String queCode = queCodeArr[i - 1];
            String answerName = "answer" + i;
            String answer = request.getParameter(answerName);

            if (answer != null && !answer.isEmpty()) {
                int score = 0;

                stmt.setString(1, queCode);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    String queType = rs.getString("queType");
                    String correctAnswer = rs.getString("queAnswer");

                    if ("T".equals(queType)) { // 주관식 문제인 경우
                        if (answer.equals(correctAnswer)) {
                            out.println("사용자가 입력한 주관식 답: <br>" + answer + "은(는) 정답입니다. <br><br>");
                            score = 1;
                        } else {
                            out.println("사용자가 입력한 주관식 답: <br>" + answer + "은(는) 오답입니다. 정답은 " + correctAnswer + "입니다. <br><br>");
                        }
                    } else { // 객관식 문제인 경우
                        if (answer.equals(correctAnswer)) {
                            out.println("사용자가 입력한 객관식 답: <br>" + answer + "은(는) 정답입니다. <br><br>");
                            score = 1;
                        } else {
                            out.println("사용자가 입력한 객관식 답: <br>" + answer + "은(는) 오답입니다. 정답은 " + correctAnswer + "입니다. <br><br>");
                        }
                    }

                    questionScores.put(queCode, score);
                }
            }
        }

        int totalScore = questionScores.values().stream().mapToInt(Integer::intValue).sum();
        out.println("총점: " + totalScore + "점 입니다");

    } catch (Exception e) {
        e.printStackTrace();
    }
    finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    %>
</body>
</html>
