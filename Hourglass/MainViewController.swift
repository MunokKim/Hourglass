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
import SwiftIcons

class MainViewController: UITableViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    static var mixedTextColor = NightNight.theme == .night ? UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.00) : UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.00)
    var iconNumber: Int32?
    var selectedIndex: Int?
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var footerView: UIView!
    
    let context = AppDelegate.viewContext
    
    var fetchArray = [WorkInfo]()
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        mainTableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing == true{
            editButton.title = "완료1".localized
        }else{
            editButton.title = "편집".localized
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
        view.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backViewColor.rawValue, night: AppsConstants.night.backViewColor.rawValue)
        //        tableView.mixedBackgroundColor = MixedColor(normal: 0xff0000, night: AppsConstants.normal.textColor.rawValue)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        if NightNight.theme == .night {
            navigationController?.navigationBar.barStyle = .black
        } else if NightNight.theme == .normal {
            navigationController?.navigationBar.barStyle = .default
        }
        tableView.mixedSeparatorColor = MixedColor(normal: AppsConstants.normal.separatorColor.rawValue, night: AppsConstants.night.separatorColor.rawValue)
        
        // 네비게이션 컨트롤러에서 large title 켜기
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = AppsConstants.appMainColor // Sunshade
        
        
        
        //        // 셀간 구분선 없애기
        //        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
        // 셀 구분선 왼쪽 띄움
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
        
        // 높이 자동 조절
        //        tableView.estimatedRowHeight = 75;
        //        tableView.rowHeight = UITableView.automaticDimension
        
        //        let searchController = UISearchController(searchResultsController: nil)
        //
        //        self.mainTableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
        //        self.searchDisplayController?.setActive(false, animated: true)
        
        contextFetchToResultsArray()
        
        // 목록이 비었으면 "작업 없음" 표시
        if fetchArray.count == 0 {
            let labelView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height-200))
            labelView.backgroundColor = .clear
            labelView.tag = 999
            
            let label = UILabel()
            label.center = CGPoint(x: labelView.frame.size.width / 2, y: labelView.frame.size.height / 2)
            label.text = "작업 없음".localized
            label.font = UIFont(name: "GodoM", size: 25)
            label.textAlignment = .center
            label.mixedTextColor = MixedColor(normal: AppsConstants.normal.detailTextColor.rawValue, night: AppsConstants.night.detailTextColor.rawValue)
            label.frame = labelView.frame
            labelView.addSubview(label)
            self.tableView.addSubview(label)
        }
        
        // 셀아래의 빈공간에 separator line 안보이게 하기
        tableView.tableFooterView = UIView()
        
        // Add Observer
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(contextFetchToResultsArray), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    @objc func contextFetchToResultsArray() {
        
        // Core Data 영구 저장소에서 WorkInfo 데이터 가져오기
        let request: NSFetchRequest<WorkInfo> = WorkInfo.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "workID", ascending: true)]
        
        do {
            fetchArray = try context.fetch(request)
            
            for work in fetchArray {
                print("WORK's Name : \(work.workName)") // 한번씩 사용을 해주어야 실제 값이 들어가게 된다.
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
    
    func deleteWorkInfo(work: WorkInfo) -> Bool {
        // Core Data 영구 저장소에서 WorkInfo 데이터 삭제하기
        context.delete(work)
        
        do {
            try context.save()
            
            print("Context Save(Delete) Success!")
            return true
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backGroundColor.rawValue, night: AppsConstants.night.backGroundColor.rawValue)
        
        let viewForSelectedCell = UIView()
        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: 0xd4d4d4, night: 0x242424)
        cell.selectedBackgroundView = viewForSelectedCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? WorkCell else {
            print("errer! : \(description)")
            return UITableViewCell()
        }
        
        // Configure the cell...
        
        // 테마 적용
        cell.workNameLabel.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
        cell.iconView.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.iconBackgroundColor.rawValue, night: AppsConstants.night.iconBackgroundColor.rawValue)
        cell.iconView.layer.cornerRadius = cell.iconView.layer.frame.width / 2.66
        cell.iconView.clipsToBounds = true
        
        cell.iconView.layer.mixedShadowColor = MixedColor(normal: UIColor.lightGray, night: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
        cell.iconView.layer.shadowRadius = 2.0
        cell.iconView.layer.shadowOpacity = 0.5
        cell.iconView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cell.iconView.layer.masksToBounds = false
        
        cell.estimatedWorkTimeLabel.textColor = AppsConstants.appMainColor // Sunshade
        
        if let iconCase = IcofontType(rawValue: Int(fetchArray[indexPath.row].iconNumber)) {
            cell.iconImageView.setIcon(icon: .icofont(iconCase), textColor: MainViewController.mixedTextColor, backgroundColor: .clear, size: nil)
        }
        cell.workNameLabel.text = fetchArray[indexPath.row].workName ?? nil
        cell.estimatedWorkTimeLabel.text = fetchArray[indexPath.row].estimatedWorkTime.secondsToString
        
        cell.shouldSelectRow = { (selectedCell) in
            
            if let indexPathRow = self.tableView.indexPath(for: selectedCell)?.row {
                self.selectedIndex = Int(self.fetchArray[indexPathRow].workID)
            }
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
        selectedIndex = Int(fetchArray[indexPath.row].workID)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let alert = UIAlertController(title: fetchArray[indexPath.row].workName ?? "", message: "이 동작은 되돌릴 수 없습니다.".localized, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "삭제".localized, style: .destructive) { _ in
                let isDelete = self.deleteWorkInfo(work: self.fetchArray[indexPath.row])
                if isDelete {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            let cancelAction = UIAlertAction(title: "취소".localized, style: .default, handler: nil)
            cancelAction.setValue(AppsConstants.appMainColor, forKey: "titleTextColor")
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            // 디바이스 타입이 iPad일때 alert가 popover되는 위치를 지정해 주어야 한다.
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popoverController = alert.popoverPresentationController { // ActionSheet가 표현되는 위치를 저장해줍니다.
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
            }
            
            self.present(alert, animated: true, completion: nil)
            
            // 블러 효과를 주기위해 UIView 익스텐션 함
            if let visualEffectView = alert.view.searchVisualEffectsSubview() {
                // 테마 적용
                visualEffectView.effect = NightNight.theme == .night ? UIBlurEffect(style: .dark) : UIBlurEffect(style: .regular)
            }
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let itemToMove = fetchArray[fromIndexPath.row]
        fetchArray.remove(at: fromIndexPath.row)
        fetchArray.insert(itemToMove, at: to.row)
        
        // Core Data 영구 저장소에서 WorkInfo workID 갱신하기
        var workID: Int16 = 1
        for result in fetchArray {
            result.setValue(workID, forKey: "workID")
            workID += 1
        }
        
        do {
            try context.save()
            
            print("Context Save(Replace) Success!")
            tableView.reloadData()
            
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
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
    
    @IBOutlet var iconView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var workNameLabel: UILabel!
    @IBOutlet var estimatedWorkTimeLabel: UILabel!
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
            hms = String(hours) + "시간".localized
        }
        if (hours != 0 && minutes != 0) || (hours != 0 && seconds != 0) {
            hms += " "
        }
        if minutes != 0 {
            hms += String(minutes) + "분".localized
        }
        if minutes != 0 && seconds != 0 {
            hms += " "
        }
        if seconds != 0 {
            hms += String(seconds) + "초".localized
        }
        if hours == 0 && minutes == 0 && seconds == 0 {
            hms = "0" + "초".localized
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

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}







