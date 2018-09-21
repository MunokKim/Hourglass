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

//    @IBAction func goToNewWork(_ sender: Any) {
//
//        if let view = self.storyboard?.instantiateViewController(withIdentifier: "NewWorkViewController") {
//            self.present(view, animated: true, completion: nil)
//        }
//    }
    
//    @IBAction func goToSetting(_ sender: Any) {
//
//        if let view = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") {
//            self.present(view, animated: true, completion: nil)
//        }
//    }
    
    @IBOutlet var mainTableView: UITableView!
    
    let context = AppDelegate.viewContext
    
    var resultsArray = [WorkInfo]()
    
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
        
        // 셀간 구분선 없애기
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        
        // 높이 자동 조절
//        tableView.estimatedRowHeight = 175;
//        tableView.rowHeight = UITableViewAutomaticDimension
        
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
        
        cell.estimatedWorkTimeLabel.textColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
        cell.workNameLabel.text = resultsArray[indexPath.row].workName!
        cell.estimatedWorkTimeLabel.text = resultsArray[indexPath.row].estimatedWorkTime.secondsToString
        
        // 셀 하단에 라인 추가하기

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
                
                print("selectedIndex is : \(String(describing: self.selectedIndex))")
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

extension Int32{
    
    var secondsToString: String {
        
        var hours: Int = Int(self/3600)
        let minutes: Int = Int(self%3600/60)
        
        if hours != 0 {
            return "\(String(hours))시간 \(String(minutes))분"
        } else {
            
            return "\(String(minutes))분"
        }
    }
}











