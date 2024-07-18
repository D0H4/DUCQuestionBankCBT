package org.example.bankexam;

public class QuestionDTO {
    private int queNum;
    private String queCode;
    private String queTitle;
    private String queAnswer;
    private String[] queOptions;
    private String queType;

    public QuestionDTO(int queNum, String queCode, String queTitle, String queAnswer, String[] queOptions, String queType) {
        this.queNum = queNum;
        this.queCode = queCode;
        this.queTitle = queTitle;
        this.queAnswer = queAnswer;
        this.queOptions = queOptions;
        this.queType = queType;
    }

    public int getQueNum() {
        return queNum;
    }

    public void setQueNum(int queNum) {
        this.queNum = queNum;
    }

    public String getQueCode() {
        return queCode;
    }

    public void setQueCode(String queCode) {
        this.queCode = queCode;
    }

    public String getQueTitle() {
        return queTitle;
    }

    public void setQueTitle(String queTitle) {
        this.queTitle = queTitle;
    }

    public String getQueAnswer() {
        return queAnswer;
    }

    public void setQueAnswer(String queAnswer) {
        this.queAnswer = queAnswer;
    }

    public String[] getQueOptions() {
        return queOptions;
    }

    public void setQueOptions(String[] queOptions) {
        this.queOptions = queOptions;
    }

    public String getQueType() {
        return queType;
    }

    public void setQueType(String queType) {
        this.queType = queType;
    }
}