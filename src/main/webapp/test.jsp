<%@ page import="org.example.bankexam.QuestionDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.example.bankexam.QuestionDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>문제 관리 시스템</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="js/InputManager.js"></script>
    <link rel="stylesheet" href=css/admin_view.css>
</head>
<body>
<iframe id="iframe1" name="iframe1" style="display: none;"></iframe>
<form action="CreateSQL" method="post" target="iframe1">
    <%
        int queNum = 0;
        QuestionDAO queDAO = new QuestionDAO();
        ArrayList<QuestionDTO> dtos = queDAO.questionSelect();

        for (int i = 0; i < dtos.size(); i++) {
            QuestionDTO dto = dtos.get(i);
            queNum = dto.getQueNum();
            String queCode = dto.getQueCode();
            String queTitle = dto.getQueTitle();
            String queAnswer = dto.getQueAnswer();
            String[] queOptions = dto.getQueOptions();
            String queType = dto.getQueType();

            out.println("<div class=\"editorWrap\">");
            out.println("<input readonly class=\"editor queNum\" value=\"" + queNum + "\">");
            out.println("<input class=\"editor queCode\" value=\"" + queCode + "\" placeholder=\"문제 코드\">");
            out.println("<input class=\"editor queTitle\" value=\"" + queTitle + "\" placeholder=\"문제 제목\">");
            out.println("<input class=\"editor queAnswer\" value=\"" + queAnswer + "\" placeholder=\"정답\">");
            if (queType.equals("N")) {
                out.println("<input class=\"editor queType\" value=\"객관식\" readonly>");
                for (int j = 0; j < queOptions.length; j++)
                    out.println("<input class=\"editor queOptions\" value=\"" + queOptions[j] + "\" placeholder=\"보기 " + (j+1) + "\">");
            }
            else {
                out.println("<input class=\"editor queType\" value=\"주관식\" readonly>");
            }
            out.println("<button id=\"deleteQuestion\">삭제하기</button>");
            out.println("</div>");
        }
    %>
    <div id="inputFields1" class="editorWrap invisible"></div>
    <button id="saveSQL">저장하기</button>
</form>
<button id="addData">데이터 추가하기</button>
</body>
</html>