# Hourglass (모래시계) 앱 프로젝트  

## 서비스 소개  

### 기획 의도  

* Hourglass - Time Management Exercises (모래시계 - 시간 관리 연습)  
    * 이름후보 2  
        * Time Coach (타임코치)  
    * 기획 의도  
        * …  
        * ‘당신도 시간관리의 전문가가 될 수 있습니다’  
        * 학생, 수험생들이 시간관리 연습을 통해 공부를 더욱 효과적으로 할 수 있습니다.  
        * 항상 시간이 부족한 직장인들이 시간관리 연습을 하면 여가시간을 효율적으로 사용할 수 있고 자기계발을 할 수 있는 시간도 활용할 수 있습니다.  
        * 이외에도 시간 개념이 부족한 많은 사람들에게 시간 관리 연습은 꼭 필요합니다.  
    * 동기  
        링크: [shoveller.tistory.com/48][1]  

        * …  
            * 어떤 자기계발서에서 '시간추정'이라고 해서 시간관리를 하는 노하우를 알려주는데 매일 따라하다 보면 시간관리를 잘 할 수 있게 된다고 했다.  
            * 한두번 따라해보니까 확실히 내가 시간을 많이 낭비하고 있고 어떠한 일을 할때 예상보다 더 많은 시간이 걸린다는 걸 알게 됐다.  
            * 효과가 괜찮은거 같아서 매일매일 반복하려고 했다.   
            * 그런데 일일이 손으로 노트에 적기는 너무 귀찮고 편하게 시간을 측정하려고 엑셀에 간이 프로그램으로 만들었다.  
            * 엑셀로 만들었어도 여전히 쉽사리 손이 안가게 되고 결국 ‘시간추정’을 습관화하는데 실패했다.  
        * 그래서 아주 간단하게 아이폰의 위젯이나 애플 워치에서 시간추정을 할 수 있는 앱을 만들어야겠다고 생각했다.  
        * 일단 내가 쓰기 위해서 만들고 싶은게 첫번째고  
        * 또 시중에 겹치는 앱이 한개도 없다.  
        * 당연히 시장성은 없겠지만  
        * 일단 앱이 확실히 기능적으로 효과가 있다 (내 경험상이지만)  
        * 또 초보개발자인 내가 개발하기에 어렵지 않을 것으로 보인다.  

### 팀 소개  

* <u>100% 1인 기획 및 개발</u>  

### 서비스 개요  

* 화면 구성  
    * **Main**ViewController  
        * **NewWork**ViewController  
        * **Working**ViewController  
        * **WorkInfo**ViewController  
            * **RecordTable**ViewController  
        * **Setting**ViewController  
            * **Backup**ViewController  
                * **PreviousBackup**ViewController  
* 프로토타입  
    * 카카오 <u>**‘Oven’**</u>으로 만든 프로토타입 보기!  
        * https://ovenapp.io/view/IpJjo9GtPCarDCQzpSbaNVEVJfr62aK2/dMIOH  
            링크: [ovenapp.io/view/IpJjo9GtPCarDCQzpSbaNVEVJfr62aK2/dMIOH][2]  

* 사용 색상  
    * Sunshade  
        * UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)  
        * F99E48  
    * Mine Shaft  
        * UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)  
        * 333333  

### 요구사항 정의  

* 시간추정  
    * 상단 버튼  
        * 좌상단 ‘+’ 버튼  
            * 새로운 작업을 추가할 수 있다  
        * 우상단 ‘편집’ 버튼  
            * 목록의 작업을 삭제/정렬 할 수 있다.  
        * 우상단 ‘더 보기’ 버튼  
    * 원하는 작업을 빠르게 찾아서 한 번의 터치로 작업을 바로 시작할 수 있어야한다.  
    * 서치바  
        * 작업의 제목을 검색하여 해당하는 작업만 목록에 보이게 한다.  
    * 작업목록의 화면 구성을 직관성있고 심플하게 해야 한다.  
    * 테이블 뷰  
        * 저장된 작업을 모두 불러와 보여준다  
        * 셀 표시내용  
            * 작업 아이콘  
            * 작업 이름  
            * 완료 예상 시간  
            * 최근 진행한 시간  
            * 현재 진행중인 작업이 있을 경우  
                * 해당하는 셀에 ‘작업중’ 및 남은시간 표시  
    * 조작  
        * 셀의 전체면적  
        * ‘정보’ 버튼  
* 새로운 작업  
    * 사용자가 작업을 추가할 때 최소한의 조작만 할 수 있도록 입력 절차를 간소화해야 한다.  
    * 작업 이름  
    * 작업 아이콘  
        우선 순위: 5  

    * 예상 작업 시간  
        진행률: 0%  

        * 이 앱의 핵심개념으로 사용자가 작업 추가를 할 때, 시, 분 단위의 타임피커를 통해 직접 입력한다.  
            진행률: 0%  

        * <u>**”사용자가 작업에 소요될 시간을 직접 예상하여 시간추정 능력을 기를 수 있다.”**</u>  
        * 기본값  
            * 30분  
    * ‘추가’ 버튼  
        * 작업에 대한 정보가 DB에 저장된다.  
        * 시간추정 목록으로 이동한다.  
        * 지금 추가한 작업이 기존의 작업들과 함께 표시된다.  
* 작업 진행중  
    * ‘최소화’ 버튼  
        * 화면을 최소화시켜 시간추정 뷰로 돌아간다  
        * 시간추정 뷰의 해당 셀에 진행중임을 시각적으로 표시한다.  
        * 시간추정 뷰의 해당 셀을 누르면 다시 최대화된다.  
    * 남은 시간  
        * 완료 예상 시점까지의 남은시간이 표시된다.  
            진행률: 0%  

    * 시중에 나와있는 여러 작업/공부 타이머처럼 타이머 진행 시 시간 숫자 표시화면과 조작 버튼은 크고 심플하며 직관적이어야 한다.  
    * '취소' 버튼  
        * 한 번 더 확인창을 거친다.  
    * '중단' 버튼  
        * ‘중단’ 버튼을 누르면  
            * 남은 시간이 멈추고 완료 예상이 늘어나기 시작한다.  
            * '재개' 버튼으로 바뀜  
            * ‘취소’, ‘완료’ 버튼이 좌우에 나타난다.  
        * ‘재개’ 버튼을 누르면  
            * 다시 남은 시간이 줄어들기 시작하고 완료 예상은 멈춘다.  
            * ‘중단’ 버튼으로 바뀜  
            * 좌우에 있던 ‘취소’, ‘완료’ 버튼이 사라진다.  
    * '완료' 버튼  
        * 작업이 종료되어 작업 진행 정보가 DB에 저장되고 결과화면을 보여준다.  
        * 작업 시작 후 최대 2분 동안은 ‘완료’버튼을 누를 수 없다.  
            * 예상 작업 시간이 20분 이하인 경우  
                * 예상 작업 시간 / 10 동안 누를 수 없음.  
    * 작업 시작  
    * 완료 예상  
        * 현재 작업 회차의 시작 시간 + 예상 작업 시간  
* 작업 완료  
    * 현재 연속 달성 여부  
        * 작업명 아래에 'n회 연속...' 표시  
            * n = '현재 연속 달성'  
            * 별표 그림 보이기  
                * '현재 연속 달성' == '연속 달성 최고기록'  
    * 사용자로 하여금 작업 목표의 달성과 실패 그리고 연속 달성에 충분한 동기를 부여할 수 있어야 한다.  
    * 목표 달성/실패 여부  
        * 작업명 아래에 '...목표달성(실패)' 표시  
    * 소요 시간  
    * 화면 구성을 게임의 보상확인 화면처럼 성취감이 느껴지도록 만든다.  
    * 작업 시작  
    * 완료 예상  
    * 처음 순간 화면 전체에 번쩍하는 플래시 효과가 발생  
    * 실제 완료  
    * 남은 시간  
    * '공유' 버튼  
    * '닫기' 버튼  
        * 앱 평가  
            * 사용자가 최초 작업완료 이후 2~3번째 작업을 완료했을때 이 버튼을 누르면 실행  
            * “앱이 마음에 드신다면 앱스토어에 평가를 남겨주세요. 새로운 기능을 추가하고 신속하게 앱을 개선하는 데 큰 도움이 됩니다.”  
                진행률: 0%  

* 작업정보  
    * 작업 이름  
        * 수정 가능  
    * 작업 아이콘  
        * 수정 가능  
    * 해당 작업의 지금까지에 대한 모든 건을 종합하여 관련 시간수치 정보를 볼 수 있다.  
    * 예상 작업 시간  
        * 수정 가능  
    * 현재 연속 달성  
    * 사용자가 수고를 들이지 않고 해당 작업 반복 숙달의 결과를 확인할 수 있다.  
    * 연속 달성 최고기록  
    * 총 작업  
    * 사용자가 작업을 더욱 개선 발전해 나갈 수 있는 동기부여를 준다.  
    * 목표 달성  
    * 목표 실패  
    * 성공률  
        * (목표 달성 / 총 작업) * 100  
    * 평균 소요 시간  
    * 평균 남은 시간  
    * ‘작업 기록 보기' 버튼  
* 작업기록  
    * 작업기록이 월별로 나누어 보여진다.  
    * 우상단 ‘필터’ 버튼  
        * 전체보기  
            * ‘더보기’ 뷰에서 이동해 온 경우 기본값이 된다.  
        * 작업1  
            * 작업1에 대한 건별 정보만 보여준다.  
                * 작업1의 ‘작업정보’ 뷰에서 이동해 온 경우 기본값이 된다.  
        * 작업2  
            * 작업2에 대한 건별 정보만 보여준다.  
                * 작업2의 ‘작업정보’ 뷰에서 이동해 온 경우 기본값이 된다.  
        * ...  
    * 과거에 했던 작업의 각 건마다 시간수치 정보를 보고 확인할 수 있다.  
    * 사용자가 작업 진행 시 부족했던 점을 개선해 나갈 수 있게 한다.  
    * 테이블 뷰  
        * 셀 표시내용  
            * 소요시간  
            * 진행 일시(시작시간)  
            * 달성 혹은 실패 여부  
        * 조작  
            * 셀의 전체면적  
                * 상세보기 열기 / 닫기  
                    * 연속 목표 달성  
                    * 예상 작업 시간  
                    * 실제 완료  
                    * 남은 시간  
* 설정  
    * 백업  
        * iCloud에 업로드  
        * 이전 백업 >  
    * 알림  
    * 소리  
        * 작업을 완료하면 재생됩니다.  
    * 프리미엄 업그레이드  
        * 무료 버전은 작업을 3개까지만 등록할 수 있어요. 프리미엄으로 업그레이드하고 무제한으로 작업을 등록하세요.  
    * 도움말  
    * 피드백  
        * <del>사용 중 문제가 발생하거나 건의 사항이 있으면 망설이지 말고 연락하세요.   
            본 앱을 더욱 개선하기 위해 항상 최선을 다하겠습니다.</del>  
            진행률: 0%  

    * 앱스토어에 리뷰 남기기  
        * 앱이 마음에 드신다면 앱스토어에 평가를 남겨주세요. 새로운 기능을 추가하고 신속하게 앱을 개선하는 데 큰 도움이 됩니다.  
            진행률: 0%  

    * 번역 돕기  
    * 다른 앱  
* 백업  
* 기타 기능  
    * Siri야  
        * “Hourglass에서 ‘개와 산책하기’을(를) 시작”  
            진행률: 0%  

        * “Hourglass에서 ‘개와 산책하기’을(를) 완료”  
            진행률: 0%  

    * 튜토리얼  
        * 처음 진입하면  
        * 새로운 작업  
            * 완료 예상 시간이란?  
                * 작업에 소요될 시간을 직접 예상하여 시간추정 능력을 기를 수 있습니다.  
        * 작업 진행중  
            * 중단 버튼  
                * 남은 시간이 정지하고 그만큼 완료 예상 시간은 뒤로 미뤄집니다.  
            * 완료 버튼  
                * 작업을 완료했을 때 누르세요!  
                    본인이 세운 목표 시간보다 더 빠르게 완료하려고 노력해보세요!  

        * 참고  
            * Minamo 라이브러리  
                링크: [github.com/yukiasai/Minamo][3]  

    * 위젯  
        * 위젯의 아이콘을 터치하면 해당 작업이 바로 시작된다.  
            * …  
            * …  
            * …  
    * 노티피케이션  
        * “지금 하고있는 작업을 더 빨리 끝내고 싶은가요? 시간추정 연습을 하고 작업속도를 더 높이세요!”  
            진행률: 0%  

        * “예상한 시간이 지났습니다. ‘개와 산책하기’를 완료할까요?”  
            진행률: 0%  

            * 예상 경과 시간의 두배 경과 하면 알림  

## 프로젝트 개요  

### 개발환경  

* 운영체제  
    * macOS  
        * High Sierra 10.13.6  
* 소스코드 작성 도구  
    * Xcode  
        * 9.4.1  
* 웹 서버  
    * X  
* 데이터베이스  
    * Core Data  
* 형상관리 도구  
    * Github  
* Language  
    * Swift 4  
* Framework  
    * UIKit  
    * Core Data  
    * CloudKit  
    * StoreKit  
    * SiriKit  
* Library  
    * iconPicker  

### 작업일정  

* 주 3~4일 씩 작업하여 약 3개월 소요  
    * …  

### 데이터베이스 구성  

* …  
    * WorkInfo  
        - 작업 정보  

        * <u>workID</u>  
            - <u>작업 고유 번호</u>  


            * Int16  
        * workName  
            - 작업 이름  


            * String  
        * iconImagePath  
            - 작업 아이콘 경로  


            * String  
        * estimatedWorkTime  
            - 예상 작업 시간  


            * Int32  
        * currentSuccessiveAchievementWhether  
            - 현재 연속 달성 여부  

            * 작업의 각 회차가 완료될 때  
                * goalSuccessOrFailWhether의 값이  
                    * TRUE  
                        * ++1  
                    * FALSE  
                        * 0  
            * Int16  
        * successiveAchievementHighestRecord  
            - 연속 달성 최고기록  

            * 작업의 각 회차가 완료될 때  
                * currentSuccessiveAchievementWhether **<u>>=</u>** successiveAchievementHighestRecord  
                    * TRUE  
                        * successiveAchievementHighestRecord **<u>=</u>** currentSuccessiveAchievementWhether  
            * Int16  
        * totalWork  
            - 총 작업  

            * 해당 작업과 workID가 같은 회차들의 갯수  
            * Int32  
        * goalSuccess  
            - 목표 달성  

            * 해당 작업과 workID가 같으면서 goalSuccessOrFailWhether가 TRUE인 회차들의 갯수  
            * Int32  
        * goalFail  
            - 목표 실패  

            * 해당 작업과 workID가 같으면서 goalSuccessOrFailWhether가 FALSE인 회차들의 갯수  
            * Int32  
        * successRate  
            - 성공률  

            * goalSuccess **<u>/</u>** totalWork  
            * Float  
        * averageElapsedTime  
            - 평균 소요시간  

            * 해당 작업과 workID가 같은 회차들의 elapsedTime을 평균낸다.  
            * Float  
        * averageRemainingTime  
            - 평균 남은시간  

            * 해당 작업과 workID가 같은 회차들의 remainingTime을 평균낸다.  
            * Float  
        * eachTurnsOfWork  
            - ‘To one’ Relationship  


            * NSSet  
    * TimeMeasurementInfo  
        - 시간 측정 정보  

        * <u>eachTurnOfWorkID</u>  
            - <u>작업의 각 회차에 대한 고유 번호</u>  


            * Int32  
        * workID  

            - 작업 고유 번호  

        * elapsedTime  
            - 소요 시간  


            * Int32  
        * workStart  
            - 작업 시작  


            * Date  
        * goalSuccessOrFailWhether  
            - 목표 달성/실패 여부  


            * Boolean  
        * successiveGoalAchievement  
            - 연속목표달성  

            * goalSuccessOrFailWhether의 값이  
                * TRUE  
                    * successiveGoalAchievement **<u>=</u>** currentSuccessiveAchievementWhether **<u>+ 1</u>**  
                * FALSE  
                    * 0  
            * Int16  
        * estimatedWorkTime  
            - 예상 작업 시간  
              진행률: 0%  


            * Int32  
        * actualCompletion  
            - 실제 완료  


            * Date  
        * remainingTime  
            - 남은 시간  


            * Int32  
        * work  
            - ‘To many’ Relationship  


            * NSManagedObject  

## 기술상세  

### Core Data  

* 새로운 작업  
    우선 순위: 1  

    * …  
* 영구 객체 저장소 데이터 가져오기  
    * 작업 목록 가져오기  
        우선 순위: 1  

        * …  
    * 작업정보 목록 가져오기  
        우선 순위: 3  

    * 작업기록 목록 가져오기  
        우선 순위: 3  

* 작업의 진행  
    우선 순위: 2  

    * …  

### 시간추정 타이머 핵심기능  

우선 순위: 2  

### ‘작업 진행중’ 뷰 최소화, 최대화 애니메이션 적용  

우선 순위: 3  

* iOS Swift Tutorial: Create a Circular Transition Animation (Custom UIViewController Transitions)  
    링크: [youtube.com/watch][4]  

* Segue 관련 라이브러리  
    * QZCircleSegue  
        링크: [github.com/alextarrago/QZCircleSegue][5]  

    * BubbleTransition  
        링크: [github.com/andreamazz/BubbleTransition][6]  

### 노티  

우선 순위: 3  

### 위젯  

우선 순위: 3  

### iconPicker 라이브러리 적용  

링크: [github.com/ranesr/SwiftIcons][7]  
우선 순위: 4  

### StoreKit  

우선 순위: 5  

* StoreKit을 통한 인앱결제  
* StoreKit을 통한 앱스토어 리뷰  

### CloudKit  

우선 순위: 5  

* CloudKit 데이터 저장소  
    - 설정의 'iCloud 백업’ 기능  

* <del>iCloud 키-값 데이터 동기화</del>  
    - <del>애플워치와 아이폰 간의 Handoff</del>  

### SiriKit  

우선 순위: 5  

### <del>애플워치 앱</del> (추후 개발 예정)  


[1]: http://shoveller.tistory.com/48
[2]: https://ovenapp.io/view/IpJjo9GtPCarDCQzpSbaNVEVJfr62aK2/dMIOH
[3]: https://github.com/yukiasai/Minamo
[4]: https://www.youtube.com/watch?v=B9sH_VxPPo4
[5]: https://github.com/alextarrago/QZCircleSegue
[6]: https://github.com/andreamazz/BubbleTransition
[7]: https://github.com/ranesr/SwiftIcons