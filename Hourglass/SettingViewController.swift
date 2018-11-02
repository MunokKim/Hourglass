//
//  SettingViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 9. 12..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import NightNight

class SettingViewController: UITableViewController {

    @IBAction func closeSetting(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var alertSwitch: UISwitch!
    @IBOutlet var soundSwitch: UISwitch!
    @IBOutlet var themeSwitch: UISwitch!
    
    @IBAction func alertSwitchChanged(_ sender: Any) {
        
        UserDefaults.standard.set(alertSwitch.isOn, forKey: "alertSwitchState")
    }
    
    @IBAction func soundSwitchChanged(_ sender: Any) {
        
        UserDefaults.standard.set(soundSwitch.isOn, forKey: "soundSwitchState")
    }
    
    @IBAction func themeSwitchChanged(_ sender: Any) {
        
        UserDefaults.standard.set(themeSwitch.isOn, forKey: "themeSwitchState")
        
        if UserDefaults.standard.bool(forKey: "themeSwitchState") {
            NightNight.theme = .night
        } else {
            NightNight.theme = .normal
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: 0xefeff4, night: 0x161718)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        
        if NightNight.theme == .night {
            navigationController?.navigationBar.barStyle = .black
        } else if NightNight.theme == .normal {
            navigationController?.navigationBar.barStyle = .default
        }
        
        tableView.mixedSeparatorColor = MixedColor(normal: 0xC8C8CC, night: 0x38383c)
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
        alertSwitch.isOn = UserDefaults.standard.bool(forKey: "alertSwitchState")
        soundSwitch.isOn = UserDefaults.standard.bool(forKey: "soundSwitchState")
        themeSwitch.isOn = UserDefaults.standard.bool(forKey: "themeSwitchState")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return MixedStatusBarStyle(normal: .default, night: .lightContent).unfold()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x1b1c1e)
        cell.textLabel?.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
        cell.detailTextLabel?.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
        
        let viewForSelectedCell = UIView()
        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: UIColor.lightGray, night: UIColor.darkGray)
        cell.selectedBackgroundView = viewForSelectedCell
        
        if indexPath.section == 1 {
            cell.textLabel?.mixedTextColor = MixedColor(normal: UIColor.lightGray, night: UIColor.darkGray)
        }
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath)
//
//        // Configure the cell...
//
//        let switchView = UISwitch(frame: .zero)
//        switchView.setOn(true, animated: true)
//        switchView.tag = indexPath.row // for detect which row switch Changed
//        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
//        cell.accessoryView = switchView
//
//        return cell
//    }

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
