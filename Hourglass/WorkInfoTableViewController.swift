//
//  WorkInfoTableViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 23/10/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import CoreData

class WorkInfoTableViewController: UITableViewController {

    var selectedIndex: Int?
    let context = AppDelegate.viewContext
    
    @IBOutlet var workNameLabel: UILabel! {
        didSet {
            workNameLabel.textColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        }
    }
    @IBOutlet var workIconImageView: UIImageView! {
        didSet {
            workIconImageView.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.00)
            workIconImageView.layer.cornerRadius = workIconImageView.layer.frame.width / 2.66
            workIconImageView.clipsToBounds = true
        }
    }
    @IBOutlet var estimatedWorkTimeLabel: UILabel! {
        didSet {
            estimatedWorkTimeLabel.textColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        }
    }
    @IBOutlet var currentSuccessiveAchievementWhetherLabel: UILabel!
    @IBOutlet var successiveAchievementHighestRecordLabel: UILabel!
    @IBOutlet var totalWorkLabel: UILabel!
    @IBOutlet var goalSuccessLabel: UILabel!
    @IBOutlet var goalFailLabel: UILabel!
    @IBOutlet var successRateLabel: UILabel!
    @IBOutlet var averageElapsedTimeLabel: UILabel!
    @IBOutlet var averageRemainingTimeLabel: UILabel!
    
    @IBOutlet var workRecordButton: UIButton! {
        didSet {
            workRecordButton.backgroundColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
            workRecordButton.layer.cornerRadius = 10
            workRecordButton.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 네비게이션 컨트롤러 하위의 뷰에서는 large title 비활성화 하기
        navigationItem.largeTitleDisplayMode = .never
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
        let workingVC = WorkingViewController()
        var fetchResult = workingVC.contextFetchToSelectedIndex(index: selectedIndex) // 메인에서 터치해서 선택된 인덱스로 불러온 WorkInfo객체
        
        let fetchArray = contextFetchFor(ThisWork: fetchResult) // 선택된 WorkInfo객체로 불러온 TimeMeasurementInfo객체
        
        fetchResult = updateWorkInfo(workInfo: fetchResult, timeMeasurementInfo: fetchArray) // 합계, 평균 등을 구한 뒤 WorkInfo 엔티티의 필드 업데이트
        
        workNameLabel.text = fetchResult.workName
        // icon
        estimatedWorkTimeLabel.text = fetchResult.estimatedWorkTime.secondsToString
        currentSuccessiveAchievementWhetherLabel.text = "\(fetchResult.currentSuccessiveAchievementWhether)회" // 현재 연속 달성 여부
        successiveAchievementHighestRecordLabel.text = "\(fetchResult.successiveAchievementHighestRecord)회" // 연속 달성 최고기록
        
        totalWorkLabel.text = "\(fetchArray.count)회" // 총 작업
        goalSuccessLabel.text = "\(fetchResult.goalSuccess)회" // 목표 달성
        goalFailLabel.text = "\(fetchResult.goalFail)회" // 목표 실패
        successRateLabel.text = String(format: "%.2f", fetchResult.successRate * 100) + "%" // 성공률
        averageElapsedTimeLabel.text = Int32(fetchResult.averageElapsedTime).secondsToString // 평균 소요시간
        averageRemainingTimeLabel.text = Int32(fetchResult.averageRemainingTime).secondsToString // 평균 남은 시간
        
        // UIButton의 setBackgroundImage를 이용한 메서드를 익스텐션으로 만들어서 사용
        workRecordButton.setBackgroundColor(color: UIColor(red:0.49, green:0.31, blue:0.14, alpha:1.00), forState: UIControl.State.highlighted)
        
    }
    
    func updateWorkInfo(workInfo: WorkInfo, timeMeasurementInfo: [TimeMeasurementInfo]) -> WorkInfo {
        
        guard timeMeasurementInfo.count != 0 else { return workInfo }
        
        var goalSuccess = 0
        var averageElapsed = 0
        var averageRemaining = 0
        
        for timeMeasurementInfo in timeMeasurementInfo {
            if timeMeasurementInfo.goalSuccessOrFailWhether {
                goalSuccess += 1
            }
            averageElapsed += Int(timeMeasurementInfo.elapsedTime)
            averageRemaining += Int(timeMeasurementInfo.remainingTime)
        }
        averageElapsed /= timeMeasurementInfo.count
        averageRemaining /= timeMeasurementInfo.count
        
        workInfo.setValue(timeMeasurementInfo.count, forKey: "totalWork")
        workInfo.setValue(goalSuccess, forKey: "goalSuccess")
        workInfo.setValue(timeMeasurementInfo.count - goalSuccess, forKey: "goalFail")
        workInfo.setValue(Float(goalSuccess) / Float(timeMeasurementInfo.count), forKey: "successRate")
        workInfo.setValue(averageElapsed, forKey: "averageElapsedTime")
        workInfo.setValue(averageRemaining, forKey: "averageRemainingTime")
        
        do {
            try context.save()
            
            return workInfo
            
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func contextFetchFor(ThisWork: WorkInfo) -> [TimeMeasurementInfo] {
        
        // Core Data 영구 저장소에서 TimeMeasurementInfo 데이터 가져오기
        let request: NSFetchRequest<TimeMeasurementInfo> = TimeMeasurementInfo.fetchRequest()
        
        request.predicate = NSPredicate(format: "work == \(selectedIndex ?? 1)")
        
        do {
            let fetchArray = try context.fetch(request)
            
            print(fetchArray)
            
            return fetchArray
            
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
     */
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIButton {

    func setBackgroundColor(color: UIColor, forState: UIControl.State) {

        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(colorImage, for: forState)
    }
}
