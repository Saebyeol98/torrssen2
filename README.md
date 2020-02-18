# torrssen2

Torrent RSS Site를 등록/관리하고, 다운로드를 요청/관리하고, 자동 다운로드를 수행하는 Webapp (Spring Boot + Nuxt.js)

## 기능

- 복수의 RSS을 주기적으로 읽어와서 게시판 리스트 생성 (주기 설정 가능)
- 리스트의 항목의 다운로드 요청 및 진행율 표시, 취소 가능 (트랜스미션/다운로드스테이션/내장 모듈 지원)
- 제목 검색 기능
- 자동 다운로드 설정 기능 (제목, 에피소드, 시즌으로 관리하여 한번 자동 다운로드 된 내역은 다시 받지 않습니다.)
- 다운로드 경로 설정 기능 (기본, 사용자 지정, 경로에 타이틀 추가, 경로에 시즌 추가)
- 다운로드 클라이언트의 현재 다운로드 리스트 관리 기능
- 이력 관리 기능
- 텔레그렘 메시지 발송 기능
- 다크테마
- 모바일 환경 지원
- 로그인 기능

## Docker

<code>docker pull tarpha/torrssen2</code><br>
<code>docker run -d --name torrssen2 -p 8080:8080 -v {data path}:/root/data tarpha/torrssen2</code>

## 수정이력

- 0.9.41: 내장 RSS 한 곳 제거
- 0.9.40: Scheduler hang 현상 조치(시도)
- 0.9.39: 내장 RSS SSL 오류 수정
- 0.9.38: 복수 화질 자동 다운로드 기능 추가. 자동 다운로드 이력 정리 기능 추가
- 0.9.37: 마이너 오류 수정. 테마 보정
- 0.9.36: 시스템 다크모드 적용 옵션 추가
- 0.9.35: Spring boot version up (2.2.2), 리스트 내 자동다운로드 상위화질 체크 버그 수정
- 0.9.34: Proxy 서버 지원. 내장 RSS 모듈 추가.
- 0.9.33: FileStation API 변경(?)에 따른 파일명 변경 로직 수정
- 0.9.32: 자동 다운로드 시 RSS 사이트 선택 기능 추가 (선택 안할 시 전체 사이트)
- 0.9.31: 자동 다운로드 관리 개별 건에 대한 사용자 실행 기능 추가
- 0.9.30: RSS Feed desc 컬럼 길이 수정 (1024)
- 0.9.29: RSS Site 관리에서 이름 수정 시 기존 Feed를 못불러 오는 오류 수정
- 0.9.28: RSS Load 오류 수정
- 0.9.27: RSS Feed description에 http link가 있을 경우 표시
- 0.9.26: RSS List 저장 오류 수정
- 0.9.25: 다운로드 스테이션 외부 요청 건 필터링 로직 보안
- 0.9.24: 자동 다운로드 매칭 시 단건 조건 추가
- 0.9.23: DOWNLOAD_LIST URI Column 길이 2048로 변경
- 0.9.22: 자동다운로드 시 자막 다운로드 오류 수정
- 0.9.21: 자동다운로드 이력 파일명 변경 상태 추가
- 0.9.20: 트랜스미션 다운로드 시 .torrent 파일 로직 수정
- 0.9.19: 자동다운로드관리 일괄 수정 항목별로 가능하게 변경
- 0.9.18: 자동다운로드관리 일괄 수정 변경. RSS 일괄 다운로드 추가
- 0.9.17: 자동다운로드관리 검색/일괄 수정 추가
- 0.9.16: 자동다운로드 시 Quality Number Casting 오류 수정
- 0.9.15: 자동다운로드 시 시리즈 여부 추가. 각 리스트 동작 아이콘 위치 변경
- 0.9.14: 다운로드 완료 시 즉시 완료(v) 표시
- 0.9.13: 다운로드 스테이션 텔레그램 발송 오류 수정
- 0.9.11: 자동 다운로드 시 자막 다운로드 기능 추가
- 0.9.10: 트랜스미션/다운로드 스테이션 접속 테스트 후 다운로드 실패 오류 수정
- 0.9.9 : 접속 테스트 추가 (텔레그램/트랜스미션/다운로드 스테이션)
- 0.9.8 : infinite scroll, 사용자 아이디 변경 가능
- 0.9.7 : 다운로드 스테이션 폴더 내 복수 파일 이동 시 삭제 오류 수정
- 0.9.6 : 다운로드 스테이션 폴더 삭제 오류 수정 (이동 시 taskid를 발급하는데 이를 확인해서 완료를 체크하고...)
- 0.9.5 : 화면 수정 (더보기 버튼 크기, 자동다운로드/다운로드완료 여부, RSS 메뉴 스크롤 등), 마이너 버그 수정
- 0.9.4 : 트랜스 미션 사용 시 일반 파일(토렌트가 아닌) 다운로드 로직 추가. 포스터 오류 수정
- 0.9.3 : 다운로드 스테이션 파일명 변경 로직 추가
- 0.9.2 : 다운로드 스테이션 폴더 제거 로직 추가
- 0.9.1 : 내장 다운로드 모듈 비활성화(안정성 하락), 폴더 제거 로직 트랜스미션에서 가능하도록 수정
- 0.9.0 : 마이너 버그 수정. 메모리 관리 향상(openj9)
- 0.8.8 : 자막 다운로드 오류 수정
- 0.8.7 : 폴더 삭제 로직 향상
- 0.8.6 : 마이너 버그 수정. 피드에 자막 정보 추가
- 0.8.5 : 스케줄링 자동 업데이트
- 0.8.2 : 자동다운로드 경로 저장 시 한글 문제 해결. 자동다운로드 체크 시 제목 수정 가능. 합본 제목 정제 수정.
- 0.8.0 : 동시 다운로드 수 설정 (EMBEDDED만)
- 0.7.8 : 마이너 버그 수정
- 0.7.7 : 컨테이너 재시작 시 자동 업데이트
- 0.7.6 : 메뉴에 버전 정보 표시, 내장 다운로더 추가(embedded), 파일명 변경 패턴에 일자 추가.
- 0.6.9 : 트랜스미션 콜백 옵션 추가, FEED link 컬럼 길이 변경(2048), RSS 리스트 제목 파싱 옵션 추가
- 0.6.7 : 로그인 오류 수정, recovery 암호 파일 자동 생성 (/root/data/symmetricKey)
- 0.6.5 : 로그인 기능 추가
- 0.6.2 : 목록 내 경과시간 버그 수정, 트랜스미션 사용 시 별도 콜백 없이도 텔레그램 발송 기능 추가
- 0.6.0 : 마이너 버그 수정
- 0.5.9 : 포스터 매칭 타이틀 로직 수정
- 0.5.8 : 화면에서 리스트 삭제 시 목록 바로 반영. RSS 갱신 버튼 RSS 아이콘에 추가. RSS 갱신 시 리스트에 바로 반영
- 0.5.7 : 다운로드 스테이션 대상 폴더가 없을 시 생성 로직 추가. 리스트 타이틀 정제 로직 변경.
- 0.5.5 : 다운로드 스테이션 오류 몇개 수정, 리스트에 날짜 추가, 리스트 삭제 기능 추가, 리스트 건 수 관리 기능 추가, tomcat -> undertow, 로그 레벨 변경(에러만), 리스트 로드 시 시간 역순으로 저장
- 0.5.0 : Release
