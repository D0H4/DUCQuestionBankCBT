# Requirements
- Eclipse
- Tomcat 9.0 (IntelliJ IDEA Smart Tomcat 플러그인 권장)
- MySQL
- WEB-INF/lib 디렉토리에 commons-csv, mysql-connector-j

# Install Guide for Eclipse
- Github에서 pull 당겨와서 쓰지말고 프로젝트 파일 압축 해제해서 사용해주세요. lib 파일 없어서 오류 발생합니다.
1. File -> Import Projects from File System or Archive를 누릅니다.
![](README/File.png)
2. Import source에서 Directory 버튼을 선택하고 설치한 프로젝트 폴더를 선택하고 Finish를 누릅니다.<br>
![](README/ImportProjects.png)
3. 프로젝트를 우클릭하고 Build Path를 서택하고 Configure Build Path...를 누릅니다.<br>
![](README/ProjectsRightClick.png)
4. 상단 탭 Library에서 JRE System Library를 선택하고 Edit을 누릅니다.<br>
![](README/LibrarySetting.png)
5. Add를 누르고 Standard VM을 선택 후 Next -> JRE Home 옆에 있는 Directory 버튼을 누릅니다.<br>
![](README/StandardVM.png)
![](README/SettingJVM.png)
6. C:\Program Files\Java에서 원하는 JDK 버전을 선택 후 Finish를 누릅니다.
7. JDK를 선택하고 Apply and Close를 누릅니다.<br>
![](README/AlternativeJRE.png)
8. Alternative JRE를 아까 선택했던 자바 버전으로 변경 후 Finish를 누릅니다.<br>
![](README/JRESetting.png)
9. Apply and Close를 누르고 창을 빠져나옵니다.
10. Window -> Show View -> Servers를 눌러줍니다. 만약 이 버튼이 없다면 오류 수정 방법에 있는 링크를 참고해주세요.<br>
![](README/Preference.png)
11. No servers are available. Click this link to create a new server...을 눌러줍니다.<br>
![](README/Servers.png)
12. apache 폴더 그림을 누르고 Tomcat v9.0 Server를 선택하고 Next를 누릅니다.<br>
![](README/NewServer.png)
13. Browse...를 누르고 Tomcat이 설치된 디렉토리를 선택한 후 Finish를 누릅니다.<br>
![](README/TomcatDirectory.png)

# MySQL Install Guide
## 주의사항!!
- 사용자 이름은 root, 비밀번호는 1234로 통일해주세요.
- 만약 사용자 이름이나 비밀번호를 변경했다면 프로젝트를 열고 src/main/webapp/META-INF/context.xml에 있는 username과 password의 값을 해당 값으로 변경해야합니다.

## 설치 설명 링크
- [이것보다 설명 잘 할 자신이 없어서 링크로 대체합니다.](https://hongong.hanbit.co.kr/mysql-%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C-%EB%B0%8F-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0mysql-community-8-0/)

# 설치 중 오류 수정 방법
- [Window -> Show View에 Servers가 없어요](https://hgserver.tistory.com/19)
- Tomcat version 9.0 only supports... 오류가 떠요<br>
![](README/ProjectFacets.png)<br>
Dynamic Web Module 버전을 4.0으로 낮추고 Java 버전을 14로 설정해주세요.

# DB 설정
- 다음 명령어를 순서대로 복사해서 Workbench에 넣고 실행해주세요.(데이터베이스 생성 및 사용)
```sql
create database exam;
use exam;
```
- 문제 테이블
```sql
CREATE TABLE questionTbl (
    queSeq INT AUTO_INCREMENT,
    queCode VARCHAR(255) NOT NULL,
    queType CHAR(1) NOT NULL,
    queTitle VARCHAR(255) NOT NULL,
    queAnswer VARCHAR(255) NOT NULL,
    PRIMARY KEY (queSeq, queCode),  -- 주 키 변경
    INDEX idx_queCode (queCode)     -- 인덱스 추가
);
```
- 객관식 답변 보기 테이블
```sql
CREATE TABLE optionTbl (
    optSeq INT AUTO_INCREMENT PRIMARY KEY,
    queCode VARCHAR(255) NOT NULL,
    optTxt VARCHAR(255) NOT NULL,
    FOREIGN KEY (queCode) REFERENCES questionTbl(queCode)
);
```

- queCode: 과목 고유 코드입니다('여러가지 과목을 볼 경우 과목코드를 따로 구분하여 시험을 보게 합니다'라고 적어두셨는데 그런 기능 없음) 언더바(_) 기준으로 왼쪽에는 과목코드 오른쪽에는 문제 번호가 입력됩니다.
- queType: 문제 유형입니다 (N: 객관식, T: 주관식)
- queTitle: 문제 본문입니다.
- queAnswer: 정답입니다
- 주의: ‘대림대’와 ‘대 림 대’는 다른 답으로 처리를 하기 때문에 주관식 문제를 내실 때 확실하게 e.g. (띄어쓰기없이 작성, 대소문자 구분) 이런 식으로 예외를 확실하게 처리해주세요

## 엑셀로 CSV 파일 만들어 import 하기
1. 넣을 데이터의 테이블을 우클릭하고 Table Data Import Wizard 클릭<br>
![](README/importContext.png)
2. Browse... 버튼을 눌러 .csv 파일을 선택하고 Finish 버튼이 나올 때까지 OK를 눌러주면 import 됩니다.
![](README/Wizard.png)

## Todo
- [ ] 과목 별로 문제 불러오기
- [X] 어드민 페이지에서 csv 파일 업로드
- [X] 디자인 변경