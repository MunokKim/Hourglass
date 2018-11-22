//
//  MainViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import CoreData
import MarqueeLabel
import NightNight

class MainViewController: UITableViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var selectedIndex: Int?
    
    @IBOutlet var mainTableView: UITableView!
    
    let context = AppDelegate.viewContext
    
    var resultsArray = [WorkInfo]()
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        mainTableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing == true{
            editButton.title = "완료"
        }else{
            editButton.title = "편집"
        }
    }
    
    // 하위 뷰컨트롤러 어디에서든 최상위 MainVC으로 돌아올수 있는 unwind segue
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: 0xefeff4, night: 0x161718)
//        tableView.mixedBackgroundColor = MixedColor(normal: 0xff0000, night: 0x222222)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        
        if NightNight.theme == .night {
            navigationController?.navigationBar.barStyle = .black
        } else if NightNight.theme == .normal {
            navigationController?.navigationBar.barStyle = .default
        }
        tableView.mixedSeparatorColor = MixedColor(normal: 0xC8C8CC, night: 0x38383c)
        
        // 네비게이션 컨트롤러에서 large title 켜기
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
        // userDefaults 가 설정된 적이 한번도 없으면 기본값 설정하기
        if UserDefaults.standard.object(forKey: "alertSwitchState") == nil {
            
            UserDefaults.standard.set(false, forKey: "alertSwitchState")
            UserDefaults.standard.set(1, forKey: "alertTimeState")
            UserDefaults.standard.set(true, forKey: "soundSwitchState")
            UserDefaults.standard.set(false, forKey: "themeSwitchState")
            UserDefaults.standard.set(true, forKey: "vibrationSwitchState")
            UserDefaults.standard.set(0, forKey: "timeOverSoundState")
            UserDefaults.standard.set(0, forKey: "successSoundState")
            UserDefaults.standard.set(0, forKey: "failSoundState")
            UserDefaults.standard.set(true, forKey: "alwaysOnDisplaySwitchState")
        }
        
        //        // 셀간 구분선 없애기
        //        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
        // 셀 구분선 왼쪽 띄움
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0);
        
        // 높이 자동 조절
        //        tableView.estimatedRowHeight = 75;
        //        tableView.rowHeight = UITableView.automaticDimension
        
        //        let searchController = UISearchController(searchResultsController: nil)
        //
        //        self.mainTableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
        //        self.searchDisplayController?.setActive(false, animated: true)
        
        contextFetchToResultsArray()
        
        // Add Observer
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(contextFetchToResultsArray), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        
        
    }
    
    @objc func contextFetchToResultsArray() {
        
        // Core Data 영구 저장소에서 WorkInfo 데이터 가져오기
        let request: NSFetchRequest<WorkInfo> = WorkInfo.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "workID", ascending: true)]
        
        do {
            resultsArray = try context.fetch(request)
            
            for work in resultsArray {
                print("WORK's Name : \(work.workName)") // 한번씩 사용을 해주어야 실제 값이 들어있게 된다.
            }
            
            DispatchQueue.main.async {
                
                self.mainTableView.reloadData()
            }
            
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x1b1c1e)
        
        let viewForSelectedCell = UIView()
        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: 0xd4d4d4, night: 0x242424)
        cell.selectedBackgroundView = viewForSelectedCell

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? WorkCell else {
            print("errer! : \(description)")
            return UITableViewCell()
        }
        
        // Configure the cell...
        
        // 테마 적용
        cell.workNameLabel.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
        cell.latestTimeLabel.mixedTextColor = MixedColor(normal: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0
        ), night: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0))
        
        cell.iconImageView.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.00)
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.layer.frame.width / 2.66
        cell.iconImageView.clipsToBounds = true
        
        cell.iconImageView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.iconImageView.layer.shadowRadius = 2.0
        cell.iconImageView.layer.shadowOpacity = 0.5
        cell.iconImageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cell.iconImageView.layer.masksToBounds = false
        
        cell.estimatedWorkTimeLabel.textColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
        cell.workNameLabel.text = resultsArray[indexPath.row].workName ?? nil
        cell.estimatedWorkTimeLabel.text = resultsArray[indexPath.row].estimatedWorkTime.secondsToString
        
        cell.shouldSelectRow = { (selectedCell) in
            
            let indexPathRow = self.tableView.indexPath(for: selectedCell)?.row
            self.selectedIndex = Int(self.resultsArray[indexPathRow!].workID)
        }
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        // go to workingVC
    //        if let view = self.storyboard?.instantiateViewController(withIdentifier: "WorkingViewController") {
    //            self.navigationController?.pushViewController(view, animated: true)
    //        }
    //    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndex = Int(resultsArray[indexPath.row].workID)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "WorkingSegue" {
            
            if let vc = segue.destination as? WorkingViewController {
                
                print("selectedIndex is : \(self.selectedIndex)")
                vc.modalTransitionStyle = .crossDissolve
                vc.selectedIndex = self.selectedIndex
            }
        }
        
        if segue.identifier == "WorkInfoSegue" {
            
            if let vc = segue.destination as? WorkInfoTableViewController {
                
                print("selectedIndex is : \(String(describing: self.selectedIndex))")
                vc.selectedIndex = self.selectedIndex
            }
        }
    }
    
    
}

class WorkCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var workNameLabel: UILabel!
    @IBOutlet var estimatedWorkTimeLabel: UILabel!
    @IBOutlet var latestTimeLabel: UILabel!
    @IBOutlet var workInfoBtn: UIButton! {
        didSet {
            // 버튼 이미지 주위의 사각형에 대한 여백
            workInfoBtn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 15)
        }
    }
    
    var shouldSelectRow: ((WorkCell) -> Void)?
    
    @IBAction func didTapWorkInfoButton(_ sender: Any) {
        // 사용자가 버튼을 탭할 때마다 클로저 호출
        shouldSelectRow?(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = iconImageView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            iconImageView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = iconImageView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            iconImageView.backgroundColor = color
        }
    }
}

extension Int32 {
    
    var secondsToString: String {
        
        let hours: Int = Int(self/3600)
        let minutes: Int = Int(self%3600/60)
        let seconds: Int = Int(self%3600%60)
        var hms: String = ""
        
        if hours != 0 {
            hms = "\(String(hours))시간"
        }
        if (hours != 0 && minutes != 0) || (hours != 0 && seconds != 0) {
            hms += " "
        }
        if minutes != 0 {
            hms += "\(String(minutes))분"
        }
        if minutes != 0 && seconds != 0 {
            hms += " "
        }
        if seconds != 0 {
            hms += "\(String(seconds))초"
        }
        if hours == 0 && minutes == 0 && seconds == 0 {
            hms = "0초"
        }
        
        return hms
    }
    
    var secondsToStopwatch: String {
        
        let hours: Int = Int(self/3600)
        let minutes: Int = Int(self%3600/60)
        let seconds: Int = Int(self%3600%60)
        
        var stringFragment: String = ""
        
        if (hours != 0) {
            stringFragment += "\(hours):"
            switch (minutes) {
            case 0:
                stringFragment += "00:"
                break
            case 1...9:
                stringFragment += "0\(minutes):"
                break
            case 10...59:
                stringFragment += "\(minutes):"
                break
            default: break
            }
        } else {
            switch (minutes) {
            case 0:
                stringFragment += "0:"
                break
            case 1...9: fallthrough
            case 10...59:
                stringFragment += "\(minutes):"
                break
            default: break
            }
        }
        
        switch (seconds) {
        case 0:
            stringFragment += "00"
        case 1...9:
            stringFragment += "0\(seconds)"
        case 10...59:
            stringFragment += "\(seconds)"
        default: break
        }
        
        return stringFragment
    }
    
    var int32ToDate: NSDate {
        return NSDate(timeIntervalSince1970: Double(self))
    }
}











