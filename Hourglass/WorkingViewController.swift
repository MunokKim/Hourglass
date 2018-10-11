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

class WorkingViewController: UIViewController {
    
    var elapsedTime: Int32?
    var workStart: NSDate?
    var estimatedWorkTime: Int32?
    var remainingTime: Int32?
    var selectedIndex: Int?
    var estimatedCompletion: NSDate?
    var firstEstimatedCompletion: NSDate?
    var resumeTimer: Timer? = Timer()
    var pauseTimer: Timer? = Timer()
    var pauseMoment: NSDate?
    var resumeMoment: NSDate?
    
    let context = AppDelegate.viewContext
    
    var fetchResult = WorkInfo()
    
    var isTimerRunning: Bool = false
    
    let playImage = UIImage(named: "play.png")
    let pauseImage = UIImage(named: "pause.png")
    
    @IBOutlet var zoomOutButton: UIButton!
    @IBOutlet var workIconImageView: UIImageView!
    @IBOutlet var workNameLabel: UILabel!
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
                button.layer.shadowColor = UIColor.lightGray.cgColor
                button.layer.shadowRadius = 2.0
                button.layer.shadowOpacity = 0.5
                button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                button.layer.masksToBounds = false
                button.layer.cornerRadius = button.layer.frame.width / 2.66
            }
        }
    }
    @IBOutlet var labels: [UILabel]! {
        didSet {
            for label in labels {
                label.layer.shadowColor = UIColor.lightGray.cgColor
                label.layer.shadowRadius = 2.0
                label.layer.shadowOpacity = 0.5
                label.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                label.layer.masksToBounds = false
            }
        }
    }
    
    @IBOutlet var cancelButtonCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var completeButtonCenterXConstraint: NSLayoutConstraint!
    
    @IBAction func zoomOutView(_ sender: Any) {
        
        resumeTimer?.invalidate()
        resumeTimer = nil
        pauseTimer?.invalidate()
        pauseTimer = nil
        
        // 임시로 그냥 창 닫기로 해놓음
        dismiss(animated: true)
    }
    
    @IBAction func resumeOrPauseTimer(_ sender: Any) {
        
        timerOperationBy(state: isTimerRunning)
        
        animateBy(state: isTimerRunning)
        
        if isTimerRunning {
            isTimerRunning = false
        } else {
            isTimerRunning = true
        }
    }
    
    @IBAction func workComplete(_ sender: Any) {
        
        saveTimeMeasurementInfo()
        
        showResultView()
    }
    
    func timerOperationBy(state: Bool) {
        
        if state {
            // 남은 시간 타이머 중단
            resumeTimer?.invalidate()
            
            pauseMoment = NSDate() // 백그라운드 기능을 위한 변수
            
            // 예상 완료 타이머 재개
            pauseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(renewalOfPause), userInfo: nil, repeats: true)
        } else {
            // 예상 완료 타이머 중단
            pauseTimer?.invalidate()
            
            resumeMoment = NSDate() // 백그라운드 기능을 위한 변수
            
            // 남은 시간 타이머 재개
            resumeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(renewalOfResume), userInfo: nil, repeats: true)
        }
    }
    
    @objc func renewalOfPause() {
        
        estimatedCompletion = estimatedCompletion!.addingTimeInterval(1)
        
        
        print("<<estimatedWorkTime>> \(estimatedWorkTime?.secondsToStopwatch) <<elapsedTime>> \(elapsedTime!) <<remainingTime>> \(remainingTime!) <<workStart>> \(workStart!) <<estimatedCompletion>> \(estimatedCompletion!)")
        
        estimatedCompletionTimeLabel.text = estimatedCompletion?.stringFromDate
        
    }
    
    @objc func renewalOfResume() {
        
        // 소요 시간 누적
        elapsedTime = (elapsedTime ?? 0) + 1
        
        // 남은 시간 계산
        remainingTime = (estimatedWorkTime)! - (elapsedTime)!
        
        print("<<estimatedWorkTime>> \(estimatedWorkTime?.secondsToStopwatch) <<elapsedTime>> \(elapsedTime!) <<remainingTime>> \(remainingTime!) <<workStart>> \(workStart!) <<estimatedCompletion>> \(estimatedCompletion!)")
        
        remainingTimeLabel.text = remainingTime?.secondsToStopwatch
        
        if (remainingTime! <= Int32(0)) {
            resumeTimer?.invalidate()
            resumeTimer = nil
            pauseTimer = nil
        }
    }
    
    func animateBy(state: Bool) {
        
        if state {
            
            stopButton.setImage(playImage, for: .normal)
            
            stopButton.isEnabled = false
            cancelButton.isEnabled = false
            completeButton.isEnabled = false
            
            cancelButton.isHidden = false
            completeButton.isHidden = false
            
            cancelButtonCenterXConstraint.constant = 105
            completeButtonCenterXConstraint.constant = 105
            
            UIView.animate(withDuration: 0.25, animations: ({
                
                self.cancelButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.completeButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
            
            UIView.animate(withDuration: 0.25, animations: ({
                
                self.cancelButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
                self.completeButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
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
        timeMeasurementInfo.goalSuccessOrFailWhether = {
            return (firstEstimatedCompletion?.timeIntervalSinceReferenceDate)! >= now.timeIntervalSinceReferenceDate
        }() // 목표 달성/실패 여부 -> 작업을 시작했을때의 최초예상완료와 현재시간을 비교한다.
        timeMeasurementInfo.successiveGoalAchievement = {
            return timeMeasurementInfo.goalSuccessOrFailWhether ? fetchResult.currentSuccessiveAchievementWhether + 1 : 0
        }() // 연속목표달성
        timeMeasurementInfo.estimatedWorkTime = fetchResult.estimatedWorkTime // 예상작업시간
        timeMeasurementInfo.elapsedTime = (elapsedTime)!
        timeMeasurementInfo.remainingTime = (remainingTime)!
        timeMeasurementInfo.work = fetchResult // 어떤 작업에 해당하는 시간측정정보인지
        
        fetchResult.currentSuccessiveAchievementWhether = {
            return timeMeasurementInfo.goalSuccessOrFailWhether ? fetchResult.currentSuccessiveAchievementWhether + 1 : 0
        }() // 현재연속달성여부
        fetchResult.successiveAchievementHighestRecord = {
            return fetchResult.currentSuccessiveAchievementWhether >= fetchResult.successiveAchievementHighestRecord ? fetchResult.currentSuccessiveAchievementWhether : fetchResult.successiveAchievementHighestRecord
        }() // 연속달성최고기록
        
        do {
            try context.save()
            
            print("Context Save Success!")
            print("timeMeasurementInfo >>>>>>>>>> \(timeMeasurementInfo)")
            print("workInfo >>>>>>>>>> \(fetchResult)")
            
        } catch let nserror as NSError {
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func showResultView() {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 네비게이션 컨트롤러 하위의 뷰에서는 large title 비활성화 하기
        //        navigationItem.largeTitleDisplayMode = .never
        
        // navigationBar 색상바꾸는 법.
        //        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        print("WorkingViewController!!!")
        //        self.view.backgroundColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        //        addGradientToView()
        
        workIconImageView.layer.cornerRadius = workIconImageView.layer.frame.width / 2.66
        workIconImageView.clipsToBounds = true
        
        stopButton.layer.borderColor = UIColor.white.cgColor
        stopButton.layer.borderWidth = 5
        
        cancelButton.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.0)
        
        completeButton.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.0)
        
        workIconImageView.layer.shadowColor = UIColor.lightGray.cgColor
        workIconImageView.layer.shadowRadius = 2.0
        workIconImageView.layer.shadowOpacity = 0.5
        workIconImageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        workIconImageView.layer.masksToBounds = false
        
        contextFetchToSelectedIndex()
        
        resumeOrPauseTimer((Any).self)
        
    }
    
    func contextFetchToSelectedIndex() {
        
        // Core Data 영구 저장소에서 WorkInfo 데이터 가져오기
        let request: NSFetchRequest<WorkInfo> = WorkInfo.fetchRequest()
        
        request.predicate = NSPredicate(format: "workID == \(selectedIndex!)")
        
        do {
            let resultArray = try context.fetch(request)
            
            fetchResult = resultArray[0]
            print(fetchResult)
            
            workStart = NSDate()
            estimatedWorkTime = fetchResult.estimatedWorkTime
            estimatedCompletion = workStart!.addingTimeInterval(TimeInterval((estimatedWorkTime)!))
            firstEstimatedCompletion = estimatedCompletion
            
            //            iconImagePath = fetchResult.iconImagePath
            workNameLabel.text = fetchResult.workName!
            workStartTimeLabel.text = workStart?.stringFromDate
            remainingTimeLabel.text = estimatedWorkTime?.secondsToStopwatch
            estimatedCompletionTimeLabel.text = estimatedCompletion?.stringFromDate
            
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension NSDate {
    
    var stringFromDate: String {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter.string(from: self as Date)
    }
    
    var dateToInt32: Int32 {
        return Int32(self.timeIntervalSince1970)
    }
}
