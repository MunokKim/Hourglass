//
//  WorkingViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData
import MarqueeLabel
import UserNotifications
import SwiftIcons
import NightNight

class WorkingViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return .lightContent
    }
    
    var elapsedTime: Int32?
    var workStart: NSDate?
    var estimatedWorkTime: Int32?
    var remainingTime: Int32?
    var selectedIndex: Int?
    var estimatedCompletion: NSDate?
    var firstEstimatedCompletion: NSDate?
    var resumeTimer: Timer? = Timer()
    var pauseTimer: Timer? = Timer()
    var momentOfEnterBackground: NSDate?
    var momentOfEnterForeground: NSDate?
    
    let context = AppDelegate.viewContext
    
    var fetchResult = WorkInfo()
    var workResultInfo: TimeMeasurementInfo?
    
    var isStopwatchRunning: Bool = false
    
    let playImage = UIImage(named: "play.png")
    let pauseImage = UIImage(named: "pause.png")
    
    @IBOutlet var zoomOutButton: UIButton! {
        didSet {
            zoomOutButton.isHidden = true
        }
    }
    @IBOutlet var workIconImageView: UIImageView!
    @IBOutlet var workNameLabel: MarqueeLabel! {
        didSet {
            workNameLabel.layer.shadowColor = UIColor.gray.cgColor
            workNameLabel.layer.shadowRadius = 2.0
            workNameLabel.layer.shadowOpacity = 0.5
            workNameLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            workNameLabel.layer.masksToBounds = false
            
            workNameLabel.font = UIFont(name: "GodoB", size: CGFloat(32).sizeByDeviceResolution)
            
            workNameLabel.tapToScroll = true
        }
    }
    @IBOutlet var remainingTextLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var workStartTextLabel: UILabel!
    @IBOutlet var workStartTimeLabel: UILabel!
    @IBOutlet var estimatedCompletionTextLabel: UILabel!
    @IBOutlet var estimatedCompletionTimeLabel: UILabel!
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            for button in buttons {
                button.layer.cornerRadius = button.layer.frame.width / 2.66
                button.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    @IBOutlet var labels: [UILabel]! {
        didSet {
            for label in labels {
                label.font = label.font.withSize(label.font.pointSize.sizeByDeviceResolution)
            }
        }
    }
    @IBOutlet var subviews: [UIView]! {
        didSet {
            for subview in subviews {
                subview.layer.shadowColor = UIColor.gray.cgColor
                subview.layer.shadowRadius = 2.0
                subview.layer.shadowOpacity = 0.5
                subview.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                subview.layer.masksToBounds = false
            }
        }
    }
    
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var completeGradientView: GradientView! {
        didSet {
            completeGradientView.isHidden = true
        }
    }
    
    @IBOutlet var cancelButtonCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var completeButtonCenterXConstraint: NSLayoutConstraint!
    
    @IBAction func zoomOutView(_ sender: Any) {
        
        
    }
    
    @IBAction func workCancel(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "작업을 종료하시겠습니까?".localized, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소".localized, style: UIAlertAction.Style.cancel, handler: nil)
        let endAction = UIAlertAction(title: "종료".localized, style: UIAlertAction.Style.destructive, handler: { _ in
            
            self.cancelTimerAndNoti()
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        })
        
        cancelAction.setValue(AppsConstants.appMainColor, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(endAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func workResumeOrPause(_ sender: Any) {
        
        if isStopwatchRunning {

            pause()
            
            animateBy()
            
            isStopwatchRunning = false
            
        } else {
            
            resume()
            
            animateBy()
            
            isStopwatchRunning = true
        }
    }
    
    func pause() {
        
        // 화면 꺼짐 방지
        UIApplication.shared.isIdleTimerDisabled = false
        
        // 남은 시간 타이머 중단
        resumeTimer?.invalidate()
        
        // 예상 완료 타이머 재개
        pauseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(renewalForPause), userInfo: nil, repeats: true)
    }
    
    func resume() {
        
        // 화면 꺼짐 방지
        UIApplication.shared.isIdleTimerDisabled = UserDefaults.standard.bool(forKey: "alwaysOnDisplaySwitchState") ? true : false
        
        // 예상 완료 타이머 중단
        pauseTimer?.invalidate()
        
        // 남은 시간 타이머 재개
        resumeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(renewalForResume), userInfo: nil, repeats: true)
    }
    
    @IBAction func workComplete(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "작업을 완료하시겠습니까?".localized, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소".localized, style: UIAlertAction.Style.cancel, handler: nil)
        let completionAction = UIAlertAction(title: "완료2".localized, style: UIAlertAction.Style.default, handler: { _ in
            
            self.cancelTimerAndNoti()
            
            self.saveTimeMeasurementInfo()
            
            self.performSegue(withIdentifier: "WorkResultSegue", sender: nil)
        })
        
        cancelAction.setValue(AppsConstants.appMainColor, forKey: "titleTextColor")
        completionAction.setValue(AppsConstants.appMainColor, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(completionAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func renewalForPause() {
        
        if remainingTime! >= Int32(0) {
            estimatedCompletion = estimatedCompletion?.addingTimeInterval(1)
        }
        
        print("<<estimatedWorkTime>> \(estimatedWorkTime?.secondsToStopwatch) <<elapsedTime>> \(elapsedTime!) <<remainingTime>> \(remainingTime!) <<workStart>> \(workStart!) <<estimatedCompletion>> \(estimatedCompletion!)")
        
        guard let estimatedCompletion = estimatedCompletion else { return }
        estimatedCompletionTimeLabel.text = NSDate().stringFromDate(date: estimatedCompletion, formatIndex: .ahms)
        view.layoutIfNeeded()
        
        if remainingTime! >= Int32(0) {
            
            UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseIn, animations: {
                self.estimatedCompletionTextLabel.alpha = 0.0
                self.estimatedCompletionTimeLabel.alpha = 0.0
                self.view.layoutIfNeeded()
            }) { _ in
                self.estimatedCompletionTextLabel.alpha = 1.0
                self.estimatedCompletionTimeLabel.alpha = 1.0
            }
        }
    }
    
    @objc func renewalForResume() {
        
        // 소요 시간 누적
        elapsedTime = (elapsedTime ?? 0) + 1
        
        // 남은 시간 계산
        remainingTime = (estimatedWorkTime)! - (elapsedTime)!
        
        print("<<estimatedWorkTime>> \(estimatedWorkTime?.secondsToStopwatch) <<elapsedTime>> \(elapsedTime!) <<remainingTime>> \(remainingTime!) <<workStart>> \(workStart!) <<estimatedCompletion>> \(estimatedCompletion!)")
        
        if (remainingTime! >= Int32(0)) {
            remainingTimeLabel.text = remainingTime?.secondsToStopwatch
            
            if remainingTime == Int32(0) {
                
                let play = SoundEffect()
                play.playSound(situation: .timeOver)
                play.vibrate()
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: ({
                    
                    // 'silvia' 그라디언트
                    self.gradientView.toColors = [UIColor(red:101/255, green:153/255, blue:153/255, alpha:1.00),
                                                  UIColor(red:172/255, green:137/255, blue:92/255, alpha:1.00),
                                                  UIColor(red:244/255, green:121/255, blue:31/255, alpha:1.00)].map{$0.cgColor}
                    
                    self.view.layoutIfNeeded()
                }), completion: nil)
            }
        } else {
            remainingTimeLabel.text = "+\(abs(remainingTime!).secondsToStopwatch)"
            remainingTextLabel.text = "지난 시간".localized
            
            if elapsedTime! >= Int32(36000) {
                
                cancelTimerAndNoti()
                
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func animateBy() {
        
        if isStopwatchRunning {
            
            stopButton.setImage(playImage, for: .normal)
            
            stopButton.isEnabled = false
            cancelButton.isEnabled = false
            completeButton.isEnabled = false
            
            cancelButton.isHidden = false
            completeButton.isHidden = false
            
            cancelButtonCenterXConstraint.constant = -(self.view.bounds.width / 4 + 17.5)
            completeButtonCenterXConstraint.constant = self.view.bounds.width / 4 + 17.5
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: ({
                // 'Moss' 그라디언트
                self.gradientView.toColors = [UIColor(red:113/255, green:178/255, blue:128/255, alpha:1.00),
                                              UIColor(red:47/255, green:128/255, blue:111/255, alpha:1.00),
                                              UIColor(red:19/255, green:78/255, blue:94/255, alpha:1.00)].map{$0.cgColor}
                self.view.layoutIfNeeded()
            }), completion: { _ in
                self.stopButton.isEnabled = true
                self.cancelButton.isEnabled = true
                self.completeButton.isEnabled = true
            })
            
        } else {
            
            stopButton.setImage(pauseImage, for: .normal)
            
            stopButton.isEnabled = false
            cancelButton.isEnabled = false
            completeButton.isEnabled = false
            
            cancelButtonCenterXConstraint.constant = 0
            completeButtonCenterXConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: ({
                
                if self.remainingTime! >= Int32(0) {
                    // 'light orange' 그라디언트
                    self.gradientView.toColors = [UIColor(red:235/255, green:163/255, blue:74/255, alpha:1.00),
                                                  UIColor(red:236/255, green:153/255, blue:38/255, alpha:1.00),
                                                  UIColor(red:237/255, green:143/255, blue:3/255, alpha:1.00)].map{$0.cgColor}
                } else if self.remainingTime! < Int32(0) {
                    // 'silvia' 그라디언트
                    self.gradientView.toColors = [UIColor(red:101/255, green:153/255, blue:153/255, alpha:1.00),
                                                  UIColor(red:172/255, green:137/255, blue:92/255, alpha:1.00),
                                                  UIColor(red:244/255, green:121/255, blue:31/255, alpha:1.00)].map{$0.cgColor}
                }
                self.view.layoutIfNeeded()
            }), completion: { _ in
                self.cancelButton.isHidden = true
                self.completeButton.isHidden = true
                
                self.stopButton.isEnabled = true
                self.cancelButton.isEnabled = true
                self.completeButton.isEnabled = true
                
            })
        }
    }
    
    @objc func saveTimeMeasurementInfo() {
        
        // Core Data 영구 저장소에 TimeMeasurementInfo 데이터 추가하기
        let timeMeasurementInfo = TimeMeasurementInfo(context: context)
        
        timeMeasurementInfo.workStart = workStart
        let now = NSDate()
        timeMeasurementInfo.actualCompletion = now
        timeMeasurementInfo.goalSuccessOrFailWhether = elapsedTime ?? 0 <= fetchResult.estimatedWorkTime // 목표 달성/실패 여부 = 소요시간 <= 작업예상시간
        timeMeasurementInfo.successiveGoalAchievement = timeMeasurementInfo.goalSuccessOrFailWhether ? fetchResult.currentSuccessiveAchievementWhether + 1 : 0 // 연속목표달성
        
        // viewDidLoad에서 estimatedWorkTime을 참조한 뒤 계속 사용했기 때문에 값이 바뀌었다.
        // Core Data의 estimatedWorkTime를 새로 불러온다. (더 나은 방법을 찾지 못함!!!!!!)
        let newFetch = fetchToSelectedIndex(selectedIndex)
        timeMeasurementInfo.estimatedWorkTime = newFetch.estimatedWorkTime // 예상작업시간
        timeMeasurementInfo.elapsedTime = elapsedTime ?? 0
        timeMeasurementInfo.remainingTime = remainingTime ?? 0
        timeMeasurementInfo.workID = fetchResult.workID // 작업번호
        timeMeasurementInfo.work = fetchResult // 어떤 작업에 해당하는 시간측정정보인지
        
        do {
            try context.save()
            
            print("Context Save Success!")
            print("timeMeasurementInfo >>>>>>>>>> \(timeMeasurementInfo)")
            print("workInfo >>>>>>>>>> \(fetchResult)")
            
            workResultInfo = timeMeasurementInfo
            
        } catch let nserror as NSError {
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        UIApplication.shared.statusBarStyle = .lightContent
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        stopButton.layer.borderWidth = 3.5
        cancelButton.layer.borderWidth = 3.5
        completeButton.layer.borderWidth = 3.5
        
        fetchResult = fetchToSelectedIndex(selectedIndex)
        
        workStart = NSDate() // 작업시작은 현재
        estimatedWorkTime = fetchResult.estimatedWorkTime
        elapsedTime = 0
        remainingTime = fetchResult.estimatedWorkTime // 남은시간의 초기값은 예상작업시간
        estimatedCompletion = workStart!.addingTimeInterval(TimeInterval((estimatedWorkTime)!)) // 예상완료는 작업시작에 예상작업시간을 더한 값
        firstEstimatedCompletion = estimatedCompletion
        
        if let iconCase = IcofontType(rawValue: Int(fetchResult.iconNumber)) {
            workIconImageView.setIcon(icon: .icofont(iconCase), textColor: .white, backgroundColor: .clear
                , size: nil)
        }
        workNameLabel.text = fetchResult.workName!
        
        guard let workStart = workStart else { return }
        workStartTimeLabel.text = NSDate().stringFromDate(date: workStart, formatIndex: .ahms)
        remainingTimeLabel.text = estimatedWorkTime?.secondsToStopwatch
        
        guard let estimatedCompletion = estimatedCompletion else { return }
        estimatedCompletionTimeLabel.text = NSDate().stringFromDate(date: estimatedCompletion, formatIndex: .ahms)
        
        workResumeOrPause((Any).self)
        
        // Add Observer
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name:UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willEnterForeground), name:UIApplication.willEnterForegroundNotification, object: nil)
        
        // 테마 적용 안되게 하기
        self.setNeedsStatusBarAppearanceUpdate()
        self.modalPresentationCapturesStatusBarAppearance = true // 전체 화면이 아닌 상태로 표시된 VC가 표시되는 VC에서 status bar 모양을 제어할지 여부를 지정합니다.
        
        // 스탑워치 줄간격 줄이기
//        remainingTimeLabel.setLineSpacing(lineSpacing: 111.0)
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    @objc func didEnterBackground() {
        // 모든 타이머 중단
        resumeTimer?.invalidate()
        resumeTimer = nil
        pauseTimer?.invalidate()
        pauseTimer = nil
        
        // 백그라운드 진입 시점 저장
        momentOfEnterBackground = NSDate()
        
        let didAllow = UserDefaults.standard.bool(forKey: "alertSwitchState")
        
        // 알림설정 켜짐 & 스탑워치 진행중 & 남은시간 남아있음
        if didAllow && isStopwatchRunning && (remainingTime! >= Int32(0)) {
            
            // push 알림 메시지 설정
            let content = UNMutableNotificationContent()
            content.title = fetchResult.workName ?? "시간추정작업".localized
            content.subtitle = fetchResult.estimatedWorkTime.secondsToString
            content.userInfo = ["workID":fetchResult.workID, "workStart":workStart, "momentForEnterBackground":momentOfEnterBackground, "elapsedTime":elapsedTime, "remainingTime":remainingTime, "NotificationID":"workDoneNoti"]
            
            let list = SoundEffect()
            let index = UserDefaults.standard.integer(forKey: "timeOverSoundState")
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(list.timeOverSoundFilename[index]).wav"))
            
            // 노티피케이션 디자인 커스터마이징
            let snoozeAction = UNNotificationAction(identifier: "snooze", title:  "스누즈".localized, options: [.authenticationRequired])
            let completeAction = UNNotificationAction(identifier: "complete", title:  "완료2".localized, options: [.authenticationRequired])
            let newCategory = UNNotificationCategory(identifier: "newCategory", actions: [snoozeAction, completeAction], intentIdentifiers: [], options: [])
            
            UNUserNotificationCenter.current().setNotificationCategories([newCategory])
            
            content.categoryIdentifier = "newCategory"
            
            // 잠금화면에 표시될 알림에 이미지 표시
//            let fileURL: URL =
//            let attachement = try? UNNotificationAttachment(identifier: "attachment", url: fileURL, options: nil)
//            content.attachments = [attachement!]
            
            guard var triggerTime = remainingTime else { return }
            
            switch UserDefaults.standard.integer(forKey: "alertTimeState") {
            case 0: // 5분전
                content.body = (fetchResult.workName ?? "시간추정작업".localized) + "의 예상 작업 시간이 5분 남았습니다.".localized
                if (triggerTime-(60*5)) < 0 {
                    fallthrough
                } else {
                    triggerTime -= 60*5
                }
            case 1: // 1분전
                content.body = (fetchResult.workName ?? "시간추정작업".localized) + "의 예상 작업 시간이 1분 남았습니다.".localized
                if (triggerTime-60) < 0 {
                    fallthrough
                } else {
                    triggerTime -= 60
                }
            case 2: // 경과할 때
                content.body = (fetchResult.workName ?? "시간추정작업".localized) + "의 예상 작업 시간이 경과하였습니다.".localized
            default: break
            }
            
            // 알림 트리거 지정
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(triggerTime), repeats: false)
            
            // 알림 요청
            let request = UNNotificationRequest(identifier: "stopwatchDone", content: content, trigger: trigger)
            
            // 위임 세팅
            UNUserNotificationCenter.current().delegate = self
            
            // 알림 요청을 알림센터에 추가
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    @objc func willEnterForeground() {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        // 백그라운드 복귀 시점 저장
        momentOfEnterForeground = NSDate()
        
        // 백그라운드 진입 시점과 복귀 시점간의 차이
        var lostTime: TimeInterval = momentOfEnterForeground!.timeIntervalSinceReferenceDate - momentOfEnterBackground!.timeIntervalSinceReferenceDate
        
        if isStopwatchRunning {
            
            elapsedTime = elapsedTime! + Int32(lostTime)
            resume()
        } else {
            
            estimatedCompletion = estimatedCompletion?.addingTimeInterval(lostTime)
            pause()
        }
    }
    
    func cancelTimerAndNoti() {
        
        resumeTimer?.invalidate()
        resumeTimer = nil
        pauseTimer?.invalidate()
        pauseTimer = nil
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func fetchToSelectedIndex(_ index: Int?) -> WorkInfo {
        
        // Core Data 영구 저장소에서 WorkInfo 데이터 가져오기
        let request: NSFetchRequest<WorkInfo> = WorkInfo.fetchRequest()
        
        guard let index = index else {
            print("SelectedIndex is Nil")
            return WorkInfo()
        }
        request.predicate = NSPredicate(format: "workID == \(index)")
        
        do {
            let resultArray = try context.fetch(request)
            
            print(resultArray[0])
            
            return resultArray[0]
            
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "WorkResultSegue" {
            
            if let vc = segue.destination as? WorkResultViewController {
                
                print("workResult is : \(self.workResultInfo)")
                vc.currentWork = self.fetchResult
                vc.workResultInfo = self.workResultInfo
            }
        }
     }
    
}

extension NSDate {
    
    enum formatIndex: String {
        case ahms = "a h:mm:ss"
        case mdahms = "M / d a h:mm:ss"
    }
    
    func stringFromDate(date: NSDate, formatIndex index: formatIndex) -> String {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR".localized)
        formatter.dateFormat = index.rawValue
        formatter.amSymbol = "오전".localized
        formatter.pmSymbol = "오후".localized
        
        return formatter.string(from: self as Date)
    }
    
    var dateToInt32: Int32 {
        return Int32(self.timeIntervalSince1970)
    }
}

extension CGFloat {
    
    var sizeByDeviceResolution: CGFloat {
        
        if UIScreen.main.bounds.width > 414 {
            return (self / 375) * (414)
        } else {
            return (self / 375) * (UIScreen.main.bounds.width)
        }
    }
}

//extension UILabel {
//
//    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
//
//        guard let labelText = self.text else { return }
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = lineSpacing
//        paragraphStyle.lineHeightMultiple = lineHeightMultiple
//
//        let attributedString:NSMutableAttributedString
//        if let labelattributedText = self.attributedText {
//            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
//        } else {
//            attributedString = NSMutableAttributedString(string: labelText)
//        }
//
//        // (Swift 4.2 and above) Line spacing attribute
//        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//
//        self.attributedText = attributedString
//    }
//}

extension WorkingViewController: UNUserNotificationCenterDelegate {

    // 앱이 켜져 있는 상태(foreground)에서 푸시를 받았을 때 호출
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
    }

    // 앱이 켜져 있지는 않지만 백그라운드로 돌고 있는 상태에서 푸시를 클릭하고 들어왔을 때 혹은 알림이 dismiss 될 때 호출
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if response.notification.request.content.categoryIdentifier == "newCategory" {
            // Handle the actions for the expired timer.
            if response.actionIdentifier == "snooze" {
                // Invalidate the old timer and create a new one. . .

                let newContent = response.notification.request.content.mutableCopy() as! UNMutableNotificationContent
                let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                // 알림 요청
                let newRequest = UNNotificationRequest(identifier: response.notification.request.identifier, content: newContent, trigger: newTrigger)
                // 알림 요청을 알림센터에 추가
                UNUserNotificationCenter.current().add(newRequest) { error in
                    if let error = error {
                        print(error)
                    }
                }
            }
            else if response.actionIdentifier == "complete" {
                
                var lostTime: TimeInterval = 0
                
                if UIApplication.shared.applicationState == .background {
                    // 백그라운드 진입 시점과 "완료" 알림버튼 누른 시점 간의 차이
                    lostTime = NSDate().timeIntervalSinceReferenceDate - momentOfEnterBackground!.timeIntervalSinceReferenceDate
                }
                
                if isStopwatchRunning {
                    
                    elapsedTime = elapsedTime! + Int32(lostTime)
                    // 남은 시간 계산
                    remainingTime = (estimatedWorkTime)! - (elapsedTime)!
                } else {
                    // 남은시간 보다 중지된 갭이 더 크다면 갭을 남은시간까지만 적용한다.
                    if remainingTime! < Int32(lostTime) && remainingTime! > 0 {
                        lostTime = TimeInterval(remainingTime!)
                    }
                    estimatedCompletion = estimatedCompletion?.addingTimeInterval(lostTime)
                }

                cancelTimerAndNoti()
                
                self.saveTimeMeasurementInfo()

                self.performSegue(withIdentifier: "WorkResultSegue", sender: nil)
            }
        }
        completionHandler()
    }

}


