package org.example.bankexam;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CreateSQL")
public class CreateQuestion extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        addQuestions(request);
        updateQuestions(request);
        deleteQuestions(request);
    }

    private void addQuestions(HttpServletRequest request) {
        try {
            String[] queNums = request.getParameterValues("queNum");
            String[] queCodes = request.getParameterValues("queCode");
            String[] queTitles = request.getParameterValues("queTitle");
            String[] queAnswers = request.getParameterValues("queAnswer");
            String[] queTypes = request.getParameterValues("queType");
            String[] queOptions = null;
            QuestionDAO dao = new QuestionDAO();

            for (int i = 0; i < queNums.length; i++) {
                if (queTypes[i].equals("객관식")) {
                    queTypes[i] = "N";
                    queOptions = request.getParameterValues("queOptions");
                } else if (queTypes[i].equals("주관식")) queTypes[i] = "T";

                QuestionDTO question = null;

                try {
                    question = new QuestionDTO(Integer.parseInt(queNums[i]), queCodes[i], queTitles[i], queAnswers[i], queOptions, queTypes[i]);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }

                if (question != null) {
                    dao.insertQuestion(question);
                    System.out.println("문제 추가 완료");
                }
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
            System.out.println("추가하는데에 필요한 정보가 부족합니다.");
        }
    }

    private void updateQuestions(HttpServletRequest request) {
        try {
            String[] updatedNum = request.getParameterValues("updatedNum");
            String[] updatedCode = request.getParameterValues("updatedCode");
            String[] updatedTitle = request.getParameterValues("updatedTitle");
            String[] updatedAnswer = request.getParameterValues("updatedAnswer");
            String[] updatedType = request.getParameterValues("updatedType");
            String[] updatedOptions = null;

            for (int i = 0; i < updatedNum.length; i++) {
                if (updatedType[i].equals("객관식")) {
                    updatedType[i] = "N";
                    updatedOptions = request.getParameterValues("updatedOptions");
                } else if (updatedType[i].equals("주관식")) updatedType[i] = "T";

                QuestionDAO updatedDAO = new QuestionDAO();
                QuestionDTO updatedQue = null;

                try {
                    updatedQue = new QuestionDTO(Integer.parseInt(updatedNum[i]), updatedCode[i], updatedTitle[i], updatedAnswer[i], updatedOptions, updatedType[i]);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }

                if (updatedQue != null) {
                    updatedDAO.updateQuestion(updatedQue);
                    System.out.println("문제 수정 완료");
                }
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
            System.out.println("수정하는데에 필요한 정보가 부족합니다.");
        }
    }

    private void deleteQuestions(HttpServletRequest request) {
        try {
            String[] deletedNum = request.getParameterValues("deletedNum");
            String[] deletedCode = request.getParameterValues("deletedCode");
            String[] deletedTitle = request.getParameterValues("deletedTitle");
            String[] deletedAnswer = request.getParameterValues("deletedAnswer");
            String[] deletedType = request.getParameterValues("deletedType");
            String[] deletedOptions = null;

            for (int i = 0; i < deletedNum.length; i++) {
                if (deletedType[i].equals("객관식")) {
                    deletedType[i] = "N";
                    deletedOptions = request.getParameterValues("deletedOptions");
                } else if (deletedType[i].equals("주관식")) deletedType[i] = "T";

                QuestionDAO deletedDAO = new QuestionDAO();
                QuestionDTO deletedQue = null;

                try {
                    deletedQue = new QuestionDTO(Integer.parseInt(deletedNum[i]), deletedCode[i], deletedTitle[i], deletedAnswer[i], deletedOptions, deletedType[i]);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }

                if (deletedQue != null) {
                    deletedDAO.deleteQuestion(deletedQue);
                    System.out.println("문제 삭제 완료");
                }
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
            System.out.println("삭제하는데에 필요한 정보가 부족합니다.");
        }
    }
}