# SesacIos_7

새싹 iOS7기 과정 과제 및 수업내용 파일 정리본

* 오로지 제출과제, 수업내용만 모아서 올려둘 레포지토리
* 추후 프로젝트, 팀단위 개발은 다른 레포지토리를 통해서 커밋, 관리할 예정

---

## 📅 일차별 과제 및 수업 내용

### 2025.06.27 - Sesac250627
**첫 번째 iOS 프로젝트**
- iOS 개발 기초 환경 설정
- Xcode 프로젝트 생성 및 기본 구조 이해
- 첫 번째 앱 개발 시작

### 2025.06.28 - Sesac250628
**기본 UI 컴포넌트 학습**
- UILabel, UIButton 기초 사용법
- 스토리보드 기반 UI 구성
- 아웃렛과 액션 연결 방법

### 2025.06.30 - Sesac250630THR
**넷플릭스 UI 클론 프로젝트**
- 완성도 높은 넷플릭스 스타일 UI 구현
- `@IBDesignable`, `@IBInspectable` 활용한 커스텀 컴포넌트
- 다크 테마 디자인 시스템 구축
- Fixed Frame 레이아웃과 리소스 관리

### 2025.07.01 - Sesac250701
**iOS 기초 종합 학습**
- 테이블뷰 기초 구현 (FirstTableViewController)
- 함수 매개변수와 아웃렛 컬렉션 학습
- 옵셔널 처리와 텍스트필드 이벤트
- 탭바 + 네비게이션 구조 이해

### 2025.07.01 - Sesac250701Report
**코드 베이스 UI 개발**
- 100% 코드 기반 넷플릭스 회원가입 화면
- Auto Layout 제약조건 설정
- `#Preview` 매크로 활용
- private 접근제어와 메서드 분리

### 2025.07.02 - Sesac250702ReportTHR
**복합 앱 구조 및 고급 UI**
- 넷플릭스 스타일 종합 앱 (탭바 + 네비게이션)
- 감정 선택 시스템 (9개 슬라임 캐릭터)
- `@IBOutletCollection` 배열 활용
- 랜덤 기능과 동적 UI 업데이트
- 복잡한 이미지 관리 시스템

### 2025.07.08 - 20250708SeSacReport
**테이블뷰 마스터 프로젝트**
- 다마고치 앱 (메인 화면 + 인터랙션)
- Static/Dynamic 테이블뷰 비교 학습
- 커스텀 셀 구현 및 재사용 메커니즘
- 구조체 데이터 모델링
- 외부 라이브러리 연동 (Kingfisher, FSCalendar)
- Unwind Segue를 통한 데이터 전달

---

## 🛠️ 주요 학습 내용

### UI 개발
- **스토리보드 vs 코드 베이스**: 두 방식의 장단점 비교
- **Auto Layout**: 제약조건 설정과 반응형 UI
- **커스텀 컴포넌트**: @IBDesignable, @IBInspectable 활용

### 테이블뷰
- **기본 구조**: numberOfRows, cellForRowAt, heightForRowAt
- **커스텀 셀**: awakeFromNib, prepareForReuse
- **섹션 관리**: 헤더/푸터, Static/Dynamic 차이점

### 데이터 관리
- **구조체 모델링**: Drama, 사용자 데이터 구조화
- **배열 조작**: append, reloadData 패턴
- **옵셔널 처리**: 안전한 데이터 접근

### 네비게이션
- **Segue**: Show, Unwind Segue 활용
- **데이터 전달**: 화면 간 정보 전달 패턴
- **탭바 구조**: 복합 네비게이션 설계

