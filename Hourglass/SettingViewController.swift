//
//  SettingViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 9. 12..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import NightNight
import UserNotifications

class SettingViewController: UITableViewController {
    
    let menuList = ["알림", "알림 시간", "소리", "예상시간 경과 알림음", "달성 효과음", "실패 효과음", "진동", "다크 모드", "화면 켜짐 유지", "더 보기"]

    @IBAction func closeSetting(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var alertSwitch: UISwitch!
    @IBOutlet var soundSwitch: UISwitch!
    @IBOutlet var themeSwitch: UISwitch!
    @IBOutlet var vibrationSwitch: UISwitch!
    @IBOutlet var alwaysOnDisplaySwitch: UISwitch!
    @IBOutlet var alertTimeCell: UITableViewCell!
    @IBOutlet var subCells: [UITableViewCell]!
    
    @IBAction func alertSwitchChanged(_ sender: Any) {
        
        if alertSwitch.isOn {
            //유저에게 알림 허락(권한) 받기
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, Error in
                print(didAllow)
                if didAllow {
                    UserDefaults.standard.set(true, forKey: "alertSwitchState")
                    
                    DispatchQueue.main.async {
                        self.changeSelection()
                    }
                } else {
                    UserDefaults.standard.set(false, forKey: "alertSwitchState")
                    
                    DispatchQueue.main.async {
                        self.alertSwitch.isOn = false
                        self.changeSelection()
                    }
                    
                    let alertController = UIAlertController (title: nil, message: "디바이스의 '설정'에서 '모래시계' > '알림' > '알림 허용'을 켜주세요.", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "확인", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        }
                    }
                    settingsAction.setValue(UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00), forKey: "titleTextColor")
                    alertController.addAction(settingsAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        } else {
            UserDefaults.standard.set(alertSwitch.isOn, forKey: "alertSwitchState")
            changeSelection()
        }
        
        
    }
    
    @IBAction func soundSwitchChanged(_ sender: Any) {
        
        UserDefaults.standard.set(soundSwitch.isOn, forKey: "soundSwitchState")
        
        changeSelection()
    }
    
    func changeSelection() {
        
        if UserDefaults.standard.bool(forKey: "alertSwitchState") {
            alertTimeCell.selectionStyle = .default
            alertTimeCell.textLabel?.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
            alertTimeCell.detailTextLabel?.mixedTextColor = MixedColor(normal: 0x555555, night: 0xbababa)
            alertTimeCell.accessoryType = .disclosureIndicator
        } else {
            alertTimeCell.selectionStyle = .none
            alertTimeCell.textLabel?.mixedTextColor = MixedColor(normal: UIColor.lightGray, night: UIColor.darkGray)
            alertTimeCell.detailTextLabel?.mixedTextColor = MixedColor(normal: UIColor.lightGray, night: UIColor.darkGray)
            alertTimeCell.accessoryType = .none
        }
        
        for subCell in subCells {
            if UserDefaults.standard.bool(forKey: "soundSwitchState") {
                subCell.selectionStyle = .default
                subCell.textLabel?.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
                subCell.detailTextLabel?.mixedTextColor = MixedColor(normal: 0x555555, night: 0xbababa)
                subCell.accessoryType = .disclosureIndicator
            } else {
                subCell.selectionStyle = .none
                subCell.textLabel?.mixedTextColor = MixedColor(normal: UIColor.lightGray, night: UIColor.darkGray)
                subCell.detailTextLabel?.mixedTextColor = MixedColor(normal: UIColor.lightGray, night: UIColor.darkGray)
                subCell.accessoryType = .none
            }
        }
    }
    
    @IBAction func vibrationSwitchChanged(_ sender: Any) {
        
        UserDefaults.standard.set(vibrationSwitch.isOn, forKey: "vibrationSwitchState")
        
        // 진동 기능 켜기
        SoundEffect().vibrate()
    }
    
    @IBAction func themeSwitchChanged(_ sender: Any) {
        
        UserDefaults.standard.set(themeSwitch.isOn, forKey: "themeSwitchState")
        
        if UserDefaults.standard.bool(forKey: "themeSwitchState") {
            NightNight.theme = .night
            MainViewController.mixedTextColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.00)
        } else {
            NightNight.theme = .normal
            MainViewController.mixedTextColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.00)
        }
    }
    @IBAction func alwaysOnDisplaySwitchChanged(_ sender: Any) {
        
        UserDefaults.standard.set(alwaysOnDisplaySwitch.isOn, forKey: "alwaysOnDisplaySwitchState")
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
        
        alertSwitch.onTintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        soundSwitch.onTintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        themeSwitch.onTintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        vibrationSwitch.onTintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        alwaysOnDisplaySwitch.onTintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        
        alertSwitch.isOn = UserDefaults.standard.bool(forKey: "alertSwitchState")
        soundSwitch.isOn = UserDefaults.standard.bool(forKey: "soundSwitchState")
        themeSwitch.isOn = UserDefaults.standard.bool(forKey: "themeSwitchState")
        vibrationSwitch.isOn = UserDefaults.standard.bool(forKey: "vibrationSwitchState")
        alwaysOnDisplaySwitch.isOn = UserDefaults.standard.bool(forKey: "alwaysOnDisplaySwitchState")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        changeSelection()
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
        
        var arrayIndex: Int = 0
        
        switch indexPath.section {
        case 0: break
        case 1:
            arrayIndex = 2
        case 2:
            arrayIndex = 6
        case 3:
            arrayIndex = 9
        default: break
        }
        cell.textLabel?.text = menuList[indexPath.row + arrayIndex]
        
        cell.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x1b1c1e)
        cell.textLabel?.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
        cell.detailTextLabel?.mixedTextColor = MixedColor(normal: 0x7b7b7b, night: 0x7b7b7b)
        
        cell.textLabel?.font = UIFont(name: "GodoM", size: 17)
        cell.detailTextLabel?.font = UIFont(name: "GodoM", size: 14)
        
        let viewForSelectedCell = UIView()
        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: 0xd4d4d4, night: 0x242424)
        cell.selectedBackgroundView = viewForSelectedCell
        
        let list = SoundEffect()

        switch cell {
        case alertTimeCell:
            let index = UserDefaults.standard.integer(forKey: "alertTimeState")
            cell.detailTextLabel?.text = list.alertTimeExplanation[index]
        case subCells[0]:
            let index = UserDefaults.standard.integer(forKey: "timeOverSoundState")
            cell.detailTextLabel?.text = list.timeOverSoundExplanation[index + 1]
        case subCells[1]:
            let index = UserDefaults.standard.integer(forKey: "successSoundState")
            cell.detailTextLabel?.text = list.successSoundExplanation[index + 1]
        case subCells[2]:
            let index = UserDefaults.standard.integer(forKey: "failSoundState")
            cell.detailTextLabel?.text = list.failSoundExplanation[index + 1]
        default: break
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "alertSegue" {
            return UserDefaults.standard.bool(forKey: "alertSwitchState") ? true : false
        }
        if identifier == "SoundSegue" {
            return UserDefaults.standard.bool(forKey: "soundSwitchState") ? true : false
        }
        return true
    }

}
