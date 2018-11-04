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

class WorkingViewController: UIViewController {
    
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
    var momentForEnterBackground: NSDate?
    var momentForEnterForeground: NSDate?
    
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
    @IBOutlet var workIconImageView: UIImageView! {
        didSet {
            workIconImageView.layer.cornerRadius = workIconImageView.layer.frame.width / 2.66
            workIconImageView.clipsToBounds = true
        }
    }
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
        
        let alert = UIAlertController(title: nil, message: "작업을 종료하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        let endAction = UIAlertAction(title: "종료", style: UIAlertAction.Style.destructive, handler: { _ in
            self.resumeTimer?.invalidate()
            self.resumeTimer = nil
            self.pauseTimer?.invalidate()
            self.pauseTimer = nil
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        })
        
        cancelAction.setValue(UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00), forKey: "titleTextColor")
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
        
        // 남은 시간 타이머 중단
        resumeTimer?.invalidate()
        
        // 예상 완료 타이머 재개
        pauseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(renewalForPause), userInfo: nil, repeats: true)
    }
    
    func resume() {
        
        // 예상 완료 타이머 중단
        pauseTimer?.invalidate()
        
        // 남은 시간 타이머 재개
        resumeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(renewalForResume), userInfo: nil, repeats: true)
    }
    
    @IBAction func workComplete(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "작업을 완료하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        let completionAction = UIAlertAction(title: "완료", style: UIAlertAction.Style.default, handler: { _ in
            self.resumeTimer?.invalidate()
            self.resumeTimer = nil
            self.pauseTimer?.invalidate()
            self.pauseTimer = nil
            
            self.saveTimeMeasurementInfo()
            
            self.performSegue(withIdentifier: "WorkResultSegue", sender: nil)
        })
        
        cancelAction.setValue(UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00), forKey: "titleTextColor")
        completionAction.setValue(UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(completionAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func renewalForPause() {
        
        if remainingTime! >= Int32(0) {
            estimatedCompletion = estimatedCompletion?.addingTimeInterval(1)
        }
        
        print("<<estimatedWorkTime>> \(estimatedWorkTime?.secondsToStopwatch) <<elapsedTime>> \(elapsedTime!) <<remainingTime>> \(remainingTime!) <<workStart>> \(workStart!) <<estimatedCompletion>> \(estimatedCompletion!)")
        
        estimatedCompletionTimeLabel.text = estimatedCompletion?.stringFromDate
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
                play.vibrate(situation: .timeOver)
                
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
            remainingTextLabel.text = "지난 시간"
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
            
            cancelButtonCenterXConstraint.constant = -(UIScreen.main.bounds.width / 4 + 17.5)
            completeButtonCenterXConstraint.constant = UIScreen.main.bounds.width / 4 + 17.5
            
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
    
    func saveTimeMeasurementInfo() {
        
        // Core Data 영구 저장소에 TimeMeasurementInfo 데이터 추가하기
        let timeMeasurementInfo = TimeMeasurementInfo(context: context)
        
        timeMeasurementInfo.workStart = workStart
        let now = NSDate()
        timeMeasurementInfo.actualCompletion = now
        timeMeasurementInfo.goalSuccessOrFailWhether = elapsedTime ?? 0 <= fetchResult.estimatedWorkTime // 목표 달성/실패 여부 = 소요시간 <= 작업예상시간
        timeMeasurementInfo.successiveGoalAchievement = timeMeasurementInfo.goalSuccessOrFailWhether ? fetchResult.currentSuccessiveAchievementWhether + 1 : 0 // 연속목표달성
        timeMeasurementInfo.estimatedWorkTime = fetchResult.estimatedWorkTime // 예상작업시간
        timeMeasurementInfo.elapsedTime = elapsedTime ?? 0
        timeMeasurementInfo.remainingTime = remainingTime ?? 0
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
        
        print("WorkingViewController!!!")
        
        stopButton.layer.borderWidth = 5
        cancelButton.layer.borderWidth = 5
        completeButton.layer.borderWidth = 5
        
        fetchResult = contextFetchToSelectedIndex(selectedIndex)
        
        workStart = NSDate() // 작업시작은 현재
        estimatedWorkTime = fetchResult.estimatedWorkTime
        elapsedTime = 0
        remainingTime = fetchResult.estimatedWorkTime // 남은시간의 초기값은 예상작업시간
        estimatedCompletion = workStart!.addingTimeInterval(TimeInterval((estimatedWorkTime)!)) // 예상완료는 작업시작에 예상작업시간을 더한 값
        firstEstimatedCompletion = estimatedCompletion
        
        //            iconImagePath = fetchResult.iconImagePath
        workNameLabel.text = fetchResult.workName!
        workStartTimeLabel.text = workStart?.stringFromDate
        remainingTimeLabel.text = estimatedWorkTime?.secondsToStopwatch
        estimatedCompletionTimeLabel.text = estimatedCompletion?.stringFromDate
        
        workResumeOrPause((Any).self)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name:UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willEnterForeground), name:UIApplication.willEnterForegroundNotification, object: nil)
        
        // 테마 적용 안되게 하기
        self.setNeedsStatusBarAppearanceUpdate()
        self.modalPresentationCapturesStatusBarAppearance = true // 전체 화면이 아닌 상태로 표시된 VC가 표시되는 VC에서 status bar 모양을 제어할지 여부를 지정합니다.
        
        // 스탑워치 줄간격 줄이기
//        remainingTimeLabel.setLineSpacing(lineSpacing: 111.0)
    }
    
    @objc func didEnterBackground() {
        
        resumeTimer?.invalidate()
        resumeTimer = nil
        pauseTimer?.invalidate()
        pauseTimer = nil
        
        momentForEnterBackground = NSDate()
    }
    
    @objc func willEnterForeground() {
        
        momentForEnterForeground = NSDate()
        
        let lostTime: TimeInterval = momentForEnterForeground!.timeIntervalSinceReferenceDate - momentForEnterBackground!.timeIntervalSinceReferenceDate
        
        if isStopwatchRunning {
            
            elapsedTime = elapsedTime! + Int32(lostTime)
            resume()
        } else {
            
            estimatedCompletion = estimatedCompletion?.addingTimeInterval(lostTime)
            pause()
        }
    }
    
    func contextFetchToSelectedIndex(_ index: Int?) -> WorkInfo {
        
        // Core Data 영구 저장소에서 WorkInfo 데이터 가져오기
        let request: NSFetchRequest<WorkInfo> = WorkInfo.fetchRequest()
        
        request.predicate = NSPredicate(format: "workID == \(index ?? 1)")
        
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
    
    var stringFromDate: String {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm:ss"
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
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
