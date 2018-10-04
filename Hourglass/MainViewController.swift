//
//  MainViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 네비게이션 컨트롤러에서 large title 켜기
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
//        // 셀간 구분선 없애기
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
        // 셀 구분선 왼쪽 띄움
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0);
        
        // userDefaults 가 설정된 적이 한번도 없으면 기본값(전부 켜짐) 설정하기
        if UserDefaults.standard.object(forKey: "alertSwitchState") == nil {
            UserDefaults.standard.set(true, forKey: "alertSwitchState")
            UserDefaults.standard.set(true, forKey: "soundSwitchState")
        }
        
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
        
        let sortDescriptor = NSSortDescriptor(key: "workID", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            resultsArray = try context.fetch(request)
            
            for work in resultsArray {
                print("WORK's Name : \(work.workName)")
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

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

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
        
        cell.iconImageView.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.00)
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.layer.frame.width / 2.66
        cell.iconImageView.clipsToBounds = true
        
        cell.iconImageView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.iconImageView.layer.shadowRadius = 2.0
        cell.iconImageView.layer.shadowOpacity = 0.5
        cell.iconImageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cell.iconImageView.layer.masksToBounds = false
        
        cell.estimatedWorkTimeLabel.textColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
        cell.workNameLabel.text = resultsArray[indexPath.row].workName!
        cell.estimatedWorkTimeLabel.text = resultsArray[indexPath.row].estimatedWorkTime.secondsToString

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
        selectedIndex = indexPath.row
        return indexPath
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
                vc.selectedIndex = self.selectedIndex
            }
        }
        
        if segue.identifier == "WorkInfoSegue" {
            
            if let vc = segue.destination as? WorkInfoViewController {
                
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
    @IBOutlet var workInfoBtn: UIButton!

}

extension Int32 {
    
    var secondsToString: String {
        
        let hours: Int = Int(self/3600)
        let minutes: Int = Int(self%3600/60)
        
        if hours != 0 {
            return "\(String(hours))시간 \(String(minutes))분"
        } else {
            return "\(String(minutes))분"
        }
    }
}











