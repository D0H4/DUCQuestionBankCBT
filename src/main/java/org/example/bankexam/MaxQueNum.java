package org.example.bankexam;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/MaxQueNum")
public class MaxQueNum extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int queNum = 0; // 객관식 index
        QuestionDAO queDAO = new QuestionDAO();
        ArrayList<QuestionDTO> dtos = queDAO.questionSelect();

        for (int i = 0; i < dtos.size(); i++) {
            QuestionDTO dto = dtos.get(i);

            queNum = dto.getQueNum();
        }

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(Integer.toString(queNum)); // 데이터 전송
    }
}