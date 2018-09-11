//
//  MainViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    @IBAction func addWorkBtn(_ sender: Any) {
        
        if let view = self.storyboard?.instantiateViewController(withIdentifier: "NewWorkViewController") {
            self.present(view, animated: true, completion: nil)
        }
    }
    
    @IBAction func popupMenuToggle(_ sender: Any) {
        
        let alert = UIAlertController(title: "세부메뉴", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "편집", style: .default) { _ in
            
            // 편집 기능
            
        })
        
        alert.addAction(UIAlertAction(title: "작업 기록 보기", style: .default) { _ in
            
            // RecordTableViewController 로 이동
            if let view = self.storyboard?.instantiateViewController(withIdentifier: "RecordTableViewController") {
                self.navigationController?.pushViewController(view, animated: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "설정", style: .default) { _ in
            
            // SettingViewController 로 이동
            if let view = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") {
                self.navigationController?.pushViewController(view, animated: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "더 보기", style: .default) { _ in
            
            // MoreViewController 로 이동
            if let view = self.storyboard?.instantiateViewController(withIdentifier: "MoreViewController") {
                self.navigationController?.pushViewController(view, animated: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
            
        })
        
        alert.view.tintColor = UIColor(red:0.87, green:0.42, blue:0.19, alpha:1.00) // Sorbus
        
        present(alert, animated: true)

    }
    
    @IBOutlet var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 네비게이션 컨트롤러에서 large title 켜기
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.87, green:0.42, blue:0.19, alpha:1.00) // Sorbus
        
        // 셀간 구분선 없애기
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        
        // 높이 자동 조절
//        tableView.estimatedRowHeight = 175;
//        tableView.rowHeight = UITableViewAutomaticDimension
        
//        let searchController = UISearchController(searchResultsController: nil)
//
//        self.mainTableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
//        self.searchDisplayController?.setActive(false, animated: true)
        
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
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? WorkCell else {
            print("errer! : \(description)")
            return UITableViewCell()
        }

        // Configure the cell...
        
//        let goInfoBtn = UIButton();
//
//        goInfoBtn.setImage(UIImage(named: "iosInformation.png"), for: .normal)
//        goInfoBtn.frame = CGRect(x: 0, y: 0, width: 28, height: 34)
//        goInfoBtn.addTarget(self, action: #selector(goToWorkInfo), for: .touchUpInside)
//        goInfoBtn.tintColor = UIColor(red:0.87, green:0.42, blue:0.19, alpha:1.00) // Sorbus
//
//        self.view.addSubview(goInfoBtn)
        
        cell.workInfoBtn.addTarget(self, action: #selector(goToWorkInfo), for: .touchUpInside)

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // go to workingVC
        if let view = self.storyboard?.instantiateViewController(withIdentifier: "WorkingViewController") {
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    @objc func goToWorkInfo() {
        
        // go to WorkInfoVC
        if let view = self.storyboard?.instantiateViewController(withIdentifier: "WorkInfoViewController") {
            self.navigationController?.pushViewController(view, animated: true)
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class WorkCell: UITableViewCell {

    @IBOutlet var workInfoBtn: UIButton!

}
