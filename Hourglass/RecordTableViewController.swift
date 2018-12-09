//
//  RecordTableViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 9. 12..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import NightNight
import CoreData
import SwiftIcons

class RecordTableViewController: UITableViewController {

    var selectedIndex: Int?
    
    let context = AppDelegate.viewContext
    
    var fetchArray = [TimeMeasurementInfo]()
    
    var isCellsHeightExpanded: [Bool] = [Bool]() {
        didSet {
            // 셀 높이를 확인하고 애니메이션을 적용한다.
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    @IBOutlet var workIconItem: UIBarButtonItem! {
        didSet {
            workIconItem.isEnabled = false
        }
    }
    
    func fetchTimeMeasurementInfo() {
        
        // Core Data 영구 저장소에서 WorkInfo 데이터 가져오기
        let request: NSFetchRequest<TimeMeasurementInfo> = TimeMeasurementInfo.fetchRequest()
        
        guard let index = selectedIndex else { return  }
        request.predicate = NSPredicate(format: "workID == \(index)")
        request.sortDescriptors = [NSSortDescriptor(key: "workStart", ascending: false)]
        
        do {
            fetchArray = try context.fetch(request)
            
            for info in fetchArray {
                print("work : \(info.work)") // 한번씩 사용을 해주어야 실제 값이 들어가게 된다.
                isCellsHeightExpanded.append(false)
            }
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        print("RecordTableViewController!!!")
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backViewColor.rawValue, night: AppsConstants.night.backViewColor.rawValue)
        tableView.mixedSeparatorColor = MixedColor(normal: AppsConstants.normal.separatorColor.rawValue, night: AppsConstants.night.separatorColor.rawValue)
        
        // 네비게이션 컨트롤러 하위의 뷰에서는 large title
        navigationItem.largeTitleDisplayMode = .automatic
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = AppsConstants.appMainColor // Sunshade
        
        fetchTimeMeasurementInfo()
        
        // 목록이 비었으면 "기록 없음" 표시
        if fetchArray.count == 0 {
            let labelView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height-200))
            labelView.backgroundColor = .clear
            labelView.tag = 999
            
            let label = UILabel()
            label.center = CGPoint(x: labelView.frame.size.width / 2, y: labelView.frame.size.height / 2)
            label.text = "기록 없음"
            label.font = UIFont(name: "GodoM", size: 25)
            label.textAlignment = .center
            label.mixedTextColor = MixedColor(normal: AppsConstants.normal.detailTextColor.rawValue, night: AppsConstants.night.detailTextColor.rawValue)
            label.frame = labelView.frame
            labelView.addSubview(label)
            self.tableView.addSubview(label)
        }
        
        // 셀아래의 빈공간에 separator line 안보이게 하기
        tableView.tableFooterView = UIView()
        
        let workingVC = WorkingViewController()
        guard let index = selectedIndex else { return }
        let workInfo = workingVC.fetchToSelectedIndex(index)
        
        // 작업제목을 타이틀로
        self.navigationItem.title = workInfo.workName
        
        // rightBarButtonItem에 작업아이콘 출력
        if let iconCase = IcofontType(rawValue: Int(workInfo.iconNumber)) {
            let color = NightNight.theme == .night ? UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.00) : UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.00)
            // Icon with colors
            workIconItem.setIcon(icon: .icofont(iconCase), iconSize: 30, color: color)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return MixedStatusBarStyle(normal: .default, night: .lightContent).unfold()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row % 2 == 0 {
            return 44
        } else if indexPath.row % 2 == 1 {
            if self.isCellsHeightExpanded[indexPath.row/2] { // 확대
                return 88
            } else { // 축소
                return 0
            }
        }
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchArray.count * 2
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row % 2 == 0 {
            cell.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backGroundColor.rawValue, night: AppsConstants.night.backGroundColor.rawValue)
        } else if indexPath.row % 2 == 1 {
            cell.selectionStyle = .none
            
            cell.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backViewColor.rawValue, night: AppsConstants.night.backViewColor.rawValue)
        }
        
        let viewForSelectedCell = UIView()
        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: 0xd4d4d4, night: 0x242424)
        cell.selectedBackgroundView = viewForSelectedCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as? RecordTitleCell else {
                print("errer! : \(description)")
                return UITableViewCell()
            }
            
            let labels = cell.contentView.subviews.compactMap { $0 as? UILabel }
            for label in labels {
                //Do something with label
                label.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
            }
            
            cell.elapsedTimeLabel.textColor = AppsConstants.appMainColor
            cell.workStartLabel.mixedTextColor = MixedColor(normal: AppsConstants.normal.detailTextColor.rawValue, night: AppsConstants.night.detailTextColor.rawValue)
            
            // Core Data 값 채워넣기 (timeMeasurementInfo)
            cell.elapsedTimeLabel.text = fetchArray[indexPath.row/2].elapsedTime.secondsToString
            
            guard let workStart = fetchArray[indexPath.row/2].workStart else { return cell }
            cell.workStartLabel.text = NSDate().stringFromDate(date: workStart, formatIndex: .mdahms)
            
            // Icon with color & colored text around it
//            label.setIcon(prefixText: "Medal ", prefixTextColor: .red, icon: .ionicons(.ribbonA), iconColor: .red, postfixText: "", postfixTextColor: .red, size: nil, iconSize: 40)
            
            return cell
            
        } else if indexPath.row % 2 == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? RecordDetailCell else {
                print("errer! : \(description)")
                return UITableViewCell()
            }
            
            let labels = cell.contentView.subviews.compactMap { $0 as? UILabel }
            for label in labels {
                //Do something with label
                label.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
            }
            
            cell.successiveGoalAchievementLabel.textColor = AppsConstants.appMainColor
            cell.estimatedWorkTimeLabel.textColor = AppsConstants.appMainColor
            cell.workCompleteLabel.textColor = AppsConstants.appMainColor
            cell.remainingTimeLabel.textColor = AppsConstants.appMainColor
            
            // Core Data 값 채워넣기 (timeMeasurementInfo)
            let sga = fetchArray[indexPath.row/2].successiveGoalAchievement
            cell.successiveGoalAchievementLabel.text = "\(sga) 회"
            cell.estimatedWorkTimeLabel.text = fetchArray[indexPath.row/2].estimatedWorkTime.secondsToString
            
            guard let actualCompletion = fetchArray[indexPath.row/2].actualCompletion else { return cell }
            cell.workCompleteLabel.text = NSDate().stringFromDate(date: actualCompletion, formatIndex: .ahms)
            cell.remainingTimeLabel.text = fetchArray[indexPath.row/2].remainingTime.secondsToString

            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row % 2 == 0 {
            self.isCellsHeightExpanded[indexPath.row/2] = self.isCellsHeightExpanded[indexPath.row/2] ? false : true
        }
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
