# Hourglass (모래시계)

> 시간 추정 능력 향상을 위한 시간 관리 훈련 애플리케이션

[![Swift](https://img.shields.io/badge/Swift-4.0+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-12.0+-lightgrey.svg)](https://www.apple.com/ios/)
[![App Store](https://img.shields.io/badge/App%20Store-Available-blue.svg)](https://itunes.apple.com/kr/app/%EB%AA%A8%EB%9E%98%EC%8B%9C%EA%B3%84/id1441559871?mt=8)

---

## 스크린샷

<img width="270" alt="스크린샷 2021-06-26 오전 2 40 59" src="https://user-images.githubusercontent.com/15843714/123466058-d88c2b00-d629-11eb-8b40-73c7ecefd207.png"><img width="270" alt="스크린샷 2021-06-26 오전 2 28 47" src="https://user-images.githubusercontent.com/15843714/123466138-f22d7280-d629-11eb-9a95-4dfa43316572.png"><img width="270" alt="스크린샷 2021-06-26 오전 2 28 27" src="https://user-images.githubusercontent.com/15843714/123466168-fa85ad80-d629-11eb-8fbd-f5fbe8c1386e.png"><img width="270" alt="스크린샷 2021-06-26 오전 2 38 55" src="https://user-images.githubusercontent.com/15843714/123466318-2a34b580-d62a-11eb-81fe-e571f446a32e.png"><img width="270" alt="스크린샷 2021-06-26 오전 2 41 22" src="https://user-images.githubusercontent.com/15843714/123466348-33258700-d62a-11eb-85d2-2af206089b4f.png"><img width="270" alt="스크린샷 2021-06-26 오전 2 44 32" src="https://user-images.githubusercontent.com/15843714/123466401-420c3980-d62a-11eb-8148-479a6862cde8.png"><img width="270" alt="스크린샷 2021-06-26 오전 2 43 22" src="https://user-images.githubusercontent.com/15843714/123466428-49334780-d62a-11eb-923f-de658382f1bd.png"><img width="270" alt="스크린샷 2021-06-26 오전 2 48 57" src="https://user-images.githubusercontent.com/15843714/123466514-5fd99e80-d62a-11eb-8838-dcb585c5eef7.png"><img width="270" alt="스크린샷 2021-06-26 오전 2 52 42" src="https://user-images.githubusercontent.com/15843714/123466537-67994300-d62a-11eb-8ad7-9376bac6b1d9.png">

---

## 프로젝트 소개

"작업에 소요될 시간을 직접 예상해보고 실제 경과 시간과 비교하는" **시간 추정(Time Estimation)** 훈련을 통해 시간 관리 능력을 향상시킬 수 있는 iOS 애플리케이션입니다.

**제작 기간**: 2018년 10월 30일 ~ 2018년 12월 15일 (약 1개월 17일)
**개발**: 100% 1인 기획 및 개발
**App Store**: [다운로드 링크](https://itunes.apple.com/kr/app/%EB%AA%A8%EB%9E%98%EC%8B%9C%EA%B3%84/id1441559871?mt=8)

### 제작 배경

자기계발서에서 소개된 '시간 추정' 기법을 실천하면서 확실히 효과를 체감했지만, 노트에 손으로 적거나 엑셀로 관리하기에는 번거로워 습관화에 실패했습니다.

그래서 **"간편하게 시간 추정 훈련을 할 수 있는 앱"**을 직접 만들기로 결심했습니다.

**핵심 동기:**
- 내가 쓰기 위한 앱 (Personal Use)
- 시중에 동일한 컨셉의 앱이 없음
- 기능적으로 효과가 검증됨 (개인 경험)
- 초보 개발자가 만들기에 적절한 난이도

**목표 사용자:**
- 공부 시간 관리가 필요한 학생/수험생
- 여가 시간을 효율적으로 사용하고 싶은 직장인
- 시간 개념이 부족하여 시간 관리 훈련이 필요한 모든 사람

---

## 주요 기능

### 1. 작업 관리
- 작업 생성 (제목, 아이콘, 예상 소요 시간 설정)
- 작업 목록 조회 및 검색
- 작업 정보 수정 (제목, 아이콘, 예상 시간)
- 작업 삭제 및 정렬

### 2. 시간 추정 타이머
- **예상 시간 설정** - 작업에 소요될 시간을 직접 예상
- **실시간 타이머** - 남은 시간 표시 및 완료 예상 시간 계산
- **중단/재개** - 작업 중단 시 완료 예상 시간 자동 조정
- **조기 완료 방지** - 최소 작업 시간 강제 (예상 시간의 1/10)

### 3. 작업 결과 및 통계
- **목표 달성/실패 여부** - 예상 시간 내 완료 여부 표시
- **연속 달성 기록** - 현재 연속 달성 및 최고 기록 관리
- **작업 통계**
  - 총 작업 횟수
  - 목표 달성/실패 횟수
  - 성공률 계산
  - 평균 소요 시간
  - 평균 남은 시간

### 4. 작업 기록
- 월별로 구분된 작업 기록 조회
- 필터 기능 (전체 보기 / 특정 작업만 보기)
- 각 작업별 상세 정보
  - 소요 시간
  - 진행 일시
  - 달성/실패 여부
  - 연속 목표 달성
  - 예상 vs 실제 완료 시간

### 5. 설정 및 부가 기능
- **다크 모드** 지원
- **iCloud 백업** - CloudKit을 통한 데이터 백업 및 복원
- **다양한 아이콘** - 600개 이상의 아이콘 선택 가능
- **알림** - 작업 완료 시 알림
- **사운드** - 작업 완료 시 효과음 재생
- **인앱 결제** - 프리미엄 업그레이드 (무제한 작업 등록)

---

## 기술 스택

### 언어 & 프레임워크
- **Swift 4**
- **UIKit** - UI 구현
- **Core Data** - 로컬 데이터 영속성 관리
- **CloudKit** - iCloud 백업 및 복원
- **StoreKit** - 인앱 결제 및 앱스토어 리뷰 요청

### 라이브러리
- **MarqueeLabel** - 텍스트 스크롤 애니메이션
- **NightNight** - 다크 모드 구현
- **SwiftIcons** - 600개 이상의 아이콘 제공

### 아키텍처
- **MVC 패턴**
- **Core Data Entity Relationship**
  - WorkInfo (작업 정보)
  - TimeMeasurementInfo (시간 측정 정보)

---

## 프로젝트 구조

```
Hourglass/
├── ViewControllers/
│   ├── MainViewController.swift              # 작업 목록 메인 화면
│   ├── NewWorkViewController.swift            # 새 작업 생성
│   ├── NewIconCollectionViewController.swift  # 아이콘 선택
│   ├── WorkingViewController.swift            # 작업 진행 중 타이머
│   ├── WorkResultViewController.swift         # 작업 완료 결과
│   ├── WorkInfoTableViewController.swift      # 작업 상세 정보 및 통계
│   ├── RecordTableViewController.swift        # 작업 기록 목록
│   ├── SettingViewController.swift            # 설정
│   ├── BackupViewController.swift             # iCloud 백업
│   ├── MoreTableViewController.swift          # 더보기 메뉴
│   └── HelpViewController.swift               # 도움말
├── Model/
│   ├── WorkInfo+CoreDataClass.swift           # 작업 정보 Entity
│   └── TimeMeasurementInfo+CoreDataClass.swift # 시간 측정 Entity
├── Custom Views/
│   ├── GradientView.swift                     # 그라데이션 뷰
│   ├── WorkTimePicker.swift                   # 커스텀 시간 피커
│   └── IconCell.swift                         # 아이콘 셀
├── Storyboards/
│   └── Main.storyboard                        # UI 레이아웃
└── Resources/
    ├── CustomFonts/                           # 커스텀 폰트
    └── Assets.xcassets                        # 이미지 및 색상 리소스
```

---

## 핵심 구현 사항

### 1. 시간 추정 타이머

작업의 핵심 기능으로, 사용자가 설정한 예상 시간을 카운트다운하면서 실제 소요 시간을 측정합니다.

**주요 로직:**
- 예상 작업 시간 설정
- 실시간 남은 시간 표시
- 완료 예상 시간 계산 (시작 시간 + 예상 시간)
- 중단 시 완료 예상 시간 자동 연장
- 최소 작업 시간 강제 (조기 완료 방지)

### 2. Core Data 관계 설정

**WorkInfo (작업 정보)**
- workID, workName, iconNumber
- estimatedWorkTime (예상 작업 시간)
- currentSuccessiveAchievementWhether (현재 연속 달성)
- successiveAchievementHighestRecord (연속 달성 최고 기록)
- totalWork, goalSuccess, goalFail (통계)
- successRate, averageElapsedTime, averageRemainingTime
- **Relationship**: To-Many → TimeMeasurementInfo

**TimeMeasurementInfo (시간 측정 정보)**
- workStart, actualCompletion (시작/완료 시간)
- goalSuccessOrFailWhether (목표 달성 여부)
- successiveGoalAchievement (연속 목표 달성)
- elapsedTime, remainingTime (소요/남은 시간)
- **Relationship**: To-One → WorkInfo

### 3. 커스텀 UI 컴포넌트

**GradientView**
```swift
class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var toColor: UIColor {
        didSet {
            // CABasicAnimation을 통한 색상 전환 애니메이션
        }
    }
}
```

**WorkTimePicker**
- UIPickerView를 활용한 커스텀 시간 선택기
- 무한 스크롤 효과 (400개 row 반복)
- 0~59분 단위 선택

### 4. 작업 완료 플래시 효과

게임의 보상 확인 화면처럼 성취감을 느낄 수 있도록 화면 전체에 플래시 효과 구현

### 5. 테이블뷰 셀 확장/축소 애니메이션

작업 기록 화면에서 셀을 탭하면 상세 정보가 펼쳐지는 기능

```swift
var isCellsHeightExpanded: [Bool] = [] {
    didSet {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
```

---

## 개발 과정

### 프로토타입

카카오 **Oven**을 사용하여 프로토타입 제작
- [프로토타입 보기](https://ovenapp.io/view/IpJjo9GtPCarDCQzpSbaNVEVJfr62aK2/dMIOH)

### 디자인

**주요 색상:**
- Sunshade: `#F99E48` (오렌지)
- Mine Shaft: `#333333` (다크 그레이)

**폰트:**
- GodoSoft & YoonDesign Inc. (커스텀 폰트)

**아이콘:**
- SwiftIcons 라이브러리 활용
- 600개 이상의 아이콘 제공

### 개발 환경

- **macOS**: High Sierra 10.13.6
- **Xcode**: 9.4.1
- **Swift**: 4.0
- **형상 관리**: GitHub

---

## 비즈니스 모델

### 프리미엄 업그레이드 (인앱 결제)

**무료 버전:**
- 작업 3개까지만 등록 가능

**프리미엄 버전:**
- 무제한 작업 등록
- 작업마다 아이콘 설정 가능

---

## 사용 방법

### 새로운 작업 만들기

1. 메인 화면 우측 상단의 `+` 버튼 클릭
2. 작업 제목 입력
3. 아이콘 선택 (600개 이상 제공)
4. 예상 작업 시간 설정 (기본값: 30분)
5. `완료` 버튼 클릭

### 작업 시작하기

1. 메인 화면에서 작업 선택
2. 타이머 자동 시작
3. **예상한 시간보다 빠르게 완료하도록 노력!**

### 작업 중단/재개

- `중단` 버튼: 남은 시간 정지, 완료 예상 시간 연장
- `재개` 버튼: 타이머 재시작

### 작업 완료

1. `완료` 버튼 클릭
2. 결과 화면에서 목표 달성/실패 확인
3. 연속 달성 기록 확인
4. 결과 공유 (선택)

---

## 향후 개선 계획

이 프로젝트는 2018년 App Store에 출시된 후 더 이상 업데이트되지 않았습니다.
만약 다시 개발한다면 다음과 같은 개선을 하고 싶습니다:

- [ ] SwiftUI로 전면 리뉴얼
- [ ] Combine 프레임워크 적용
- [ ] Widget 지원 (홈 화면에서 바로 작업 시작)
- [ ] Apple Watch 앱
- [ ] SiriKit 통합
  - "시리야, 모래시계에서 '운동하기' 시작"
  - "시리야, 모래시계에서 '운동하기' 완료"
- [ ] 통계 차트 시각화
- [ ] 작업 카테고리 기능
- [ ] 목표 시간 자동 조정 기능 (학습 기반)

---

## 회고

### 잘한 점

- **완성도 높은 첫 개인 앱** - 기획부터 출시까지 혼자 완성
- **실용적인 앱** - 실제 사용 가능하고 효과가 있는 기능
- **App Store 출시 경험** - 심사 과정 및 운영 경험
- **체계적인 문서화** - 요구사항 정의서 및 기술 문서 작성

### 아쉬운 점

- **마케팅 부재** - 출시 후 홍보 부족
- **사용자 피드백 수집 미흡** - 실제 사용자의 의견을 듣지 못함
- **지속적인 업데이트 부족** - 출시 후 추가 기능 개발 중단

### 배운 점

- iOS 앱 전체 개발 사이클 경험
- Core Data를 활용한 복잡한 데이터 관계 설계
- CloudKit을 통한 데이터 백업 구현
- StoreKit 인앱 결제 구현
- App Store 심사 및 출시 프로세스
- 1인 개발의 어려움과 한계
- 기획의 중요성 (프로토타입, 요구사항 정의)

---

## 라이선스

### 오픈 소스 라이브러리

이 프로젝트는 다음 오픈소스 라이브러리를 사용합니다:

- **MarqueeLabel** - Copyright (c) 2011-2017 Charles Powell (MIT License)
- **NightNight** - Copyright (c) 2016 Draveness (MIT License)
- **SwiftIcons** - Copyright © 2017 Saurabh Rane (MIT License)

### 리소스

- **커스텀 폰트**: Copyright © 2012 GodoSoft & YoonDesign Inc.
- **사운드 파일**: CC BY 3.0, CC BY-ND 3.0
- **아이콘**: CC BY 4.0

---

## 작성자

**Munok Kim**
- GitHub: [@MunokKim](https://github.com/MunokKim)

---

## 관련 링크

- **App Store**: [모래시계 다운로드](https://itunes.apple.com/kr/app/%EB%AA%A8%EB%9E%98%EC%8B%9C%EA%B3%84/id1441559871?mt=8)
- **프로토타입**: [Oven 프로토타입 보기](https://ovenapp.io/view/IpJjo9GtPCarDCQzpSbaNVEVJfr62aK2/dMIOH)

---

**Made in 2018 | Published on App Store**
