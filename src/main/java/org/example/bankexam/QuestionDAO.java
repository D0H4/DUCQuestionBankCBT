package org.example.bankexam;

import java.sql.*;
import java.util.ArrayList;

public class QuestionDAO {
    public QuestionDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ArrayList<QuestionDTO> questionSelect() {
        ArrayList<QuestionDTO> dtos = new ArrayList<QuestionDTO>();

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnector.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT " +
                    "    sub.queSeq AS queNum, " +
                    "    sub.queCode AS queCode, " +
                    "    sub.queTitle AS queTitle, " +
                    "    sub.options AS options, " +
                    "    sub.answer AS answer, " +
                    "    sub.queType AS queType " +
                    "FROM" +
                    "    (" +
                    "        SELECT " +
                    "            q.queSeq AS queSeq, " +
                    "            q.queCode AS queCode, " +
                    "            q.queTitle AS queTitle, " +
                    "            GROUP_CONCAT(o.optTxt ORDER BY optTxt ASC SEPARATOR ' ') AS options, " +
                    "            q.queAnswer AS answer, " +
                    "            q.queType AS queType" +
                    "        FROM questionTbl q " +
                    "        JOIN optionTbl o ON q.queCode = o.queCode " +
                    "        WHERE q.queType = 'N' " +
                    "        GROUP BY q.queSeq, q.queTitle, q.queAnswer, q.queCode" +
                    "        UNION" +
                    "        SELECT " +
                    "            q.queSeq AS queSeq, " +
                    "            q.queCode AS queCode, " +
                    "            q.queTitle AS queTitle, " +
                    "            '' AS options, " +
                    "            q.queAnswer AS answer," +
                    "            q.queType AS queType " +
                    "        FROM questionTbl q " +
                    "        WHERE q.queType = 'T' " +
                    "    ) AS sub " +
                    "ORDER BY queNum ASC";
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                int queNum = Integer.parseInt(rs.getString("queNum"));
                String queCode = rs.getString("queCode");
                String queTitle = rs.getString("queTitle");
                String queAnswer = rs.getString("answer");
                String queOptions = rs.getString("options");
                String queType = rs.getString("queType");

                String[] queOptionsArr = queOptions.split(" ");

                QuestionDTO dto = new QuestionDTO(queNum, queCode, queTitle, queAnswer, queOptionsArr, queType);
                dtos.add(dto);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return dtos;
    }

    public void insertQuestion(QuestionDTO dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DbConnector.getConnection();
            String sql = "INSERT INTO questionTbl (queSeq, queCode, queTitle, queAnswer, queType) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getQueNum());
            pstmt.setString(2, dto.getQueCode());
            pstmt.setString(3, dto.getQueTitle());
            pstmt.setString(4, dto.getQueAnswer());
            pstmt.setString(5, dto.getQueType());
            pstmt.executeUpdate();
            if (dto.getQueType().equals("N")) {
                String[] queOptions = dto.getQueOptions();
                for (int i = 0; i < queOptions.length; i++) {
                    sql = "INSERT INTO optionTbl (queCode, optTxt) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, dto.getQueCode());
                    pstmt.setString(2, queOptions[i]);
                    pstmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    public void updateQuestion(QuestionDTO dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DbConnector.getConnection();
            String sql = "UPDATE questionTbl SET queCode = ?, queTitle = ?, queAnswer = ?, queType = ? WHERE queSeq = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getQueCode());
            pstmt.setString(2, dto.getQueTitle());
            pstmt.setString(3, dto.getQueAnswer());
            pstmt.setString(4, dto.getQueType());
            pstmt.setInt(5, dto.getQueNum());
            pstmt.executeUpdate();
            if (dto.getQueType().equals("N")) {
                String[] queOptions = dto.getQueOptions();
                for (int i = 0; i < queOptions.length; i++) {
                    sql = "INSERT INTO optionTbl (queCode, optTxt) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, dto.getQueCode());
                    pstmt.setString(2, queOptions[i]);
                    pstmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void deleteQuestion(QuestionDTO dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DbConnector.getConnection();
            String sql = "DELETE FROM optionTbl WHERE queCode = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getQueCode());
            pstmt.executeUpdate();
            sql = "DELETE FROM questionTbl WHERE queSeq = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getQueNum());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}