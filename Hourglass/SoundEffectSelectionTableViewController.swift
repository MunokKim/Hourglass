//
//  SoundEffectSelectionTableViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 03/11/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import NightNight

class SoundEffectSelectionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: 0xefeff4, night: 0x161718)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        tableView.mixedSeparatorColor = MixedColor(normal: 0xC8C8CC, night: 0x38383c)
    }

    // MARK: - Table view data source
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        cell.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x1b1c1e)
//        cell.textLabel?.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
//
//        cell.textLabel?.font = UIFont(name: "GodoM", size: 17)
//
//        let viewForSelectedCell = UIView()
//        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: 0xd4d4d4, night: 0x242424)
//        cell.selectedBackgroundView = viewForSelectedCell
//
//        let list = SoundEffect()
//
//        guard let tableFlag = tableFlag else { return }
//
//        switch tableFlag {
//        case 0: // 알림시간 선택 테이블
//            cell.textLabel?.text = list.alertTimeExplanation[indexPath.row]
//
//            if UserDefaults.standard.integer(forKey: "alertTimeState") == (indexPath.row) {
//                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 21))
//                imgView.image = UIImage(named: "Icon-eto-check.png")
//                cell.accessoryView = imgView
//            }
//        case 1: // 예상시간 경과 알림음 선택 테이블
//            cell.textLabel?.text = list.timeOverSoundExplanation[indexPath.row]
//
//            if UserDefaults.standard.integer(forKey: "timeOverSoundState") == (indexPath.row - 1) {
//                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 21))
//                imgView.image = UIImage(named: "Icon-eto-check.png")
//                cell.accessoryView = imgView
//            }
//        case 2: // 달성 효과음 선택 테이블
//            cell.textLabel?.text = list.successSoundExplanation[indexPath.row]
//
//            if UserDefaults.standard.integer(forKey: "successSoundState") == (indexPath.row - 1) {
//                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 21))
//                imgView.image = UIImage(named: "Icon-eto-check.png")
//                cell.accessoryView = imgView
//            }
//        case 3: // 실패 효과음 선택 테이블
//            cell.textLabel?.text = list.failSoundExplanation[indexPath.row]
//
//            if UserDefaults.standard.integer(forKey: "failSoundState") == (indexPath.row - 1) {
//                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 21))
//                imgView.image = UIImage(named: "Icon-eto-check.png")
//                cell.accessoryView = imgView
//            }
//        default: break
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 모든 셀의 accessoryView의 이미지 없애기
        for cell in tableView.visibleCells {
            cell.accessoryView = nil
        }
        
        // 선택한 셀의 accessoryView에 이미지 추가
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 21))
        imgView.image = UIImage(named: "Icon-eto-check.png")
        tableView.cellForRow(at: indexPath)?.accessoryView = imgView
        
        let list = SoundEffect()
        
        // '없음' 선택시 -1이 저장되어 사운드 재생할 때 사운드가 나오지 않게한다.
        
        switch tableView.tag {
        case 0:
            UserDefaults.standard.set(indexPath.row, forKey: "alertTimeState")
        case 1:
            UserDefaults.standard.set(indexPath.row - 1, forKey: "timeOverSoundState")
            list.playSound(situation: .timeOver)
            
        case 2:
            UserDefaults.standard.set(indexPath.row - 1, forKey: "successSoundState")
            list.playSound(situation: .success)
            
        case 3:
            UserDefaults.standard.set(indexPath.row - 1, forKey: "failSoundState")
            list.playSound(situation: .fail)
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let list = SoundEffect()
        
        switch tableView.tag {
        case 0:
            return list.alertTimeExplanation.count
        case 1:
            return list.timeOverSoundExplanation.count
        case 2:
            return list.successSoundExplanation.count
        case 3:
            return list.failSoundExplanation.count
        default: break
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingReuseCell", for: indexPath)

        // Configure the cell...
        cell.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x1b1c1e)
        cell.textLabel?.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
        
        cell.textLabel?.font = UIFont(name: "GodoM", size: 17)
        
        let viewForSelectedCell = UIView()
        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: 0xd4d4d4, night: 0x242424)
        cell.selectedBackgroundView = viewForSelectedCell
        
        let list = SoundEffect()
        
        switch tableView.tag {
        case 0: // 알림시간 선택 테이블
            cell.textLabel?.text = list.alertTimeExplanation[indexPath.row]

            if UserDefaults.standard.integer(forKey: "alertTimeState") == (indexPath.row) {
                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 21))
                imgView.image = UIImage(named: "Icon-eto-check.png")
                cell.accessoryView = imgView
            }
        case 1: // 예상시간 경과 알림음 선택 테이블
            cell.textLabel?.text = list.timeOverSoundExplanation[indexPath.row]

            if UserDefaults.standard.integer(forKey: "timeOverSoundState") == (indexPath.row - 1) {
                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 21))
                imgView.image = UIImage(named: "Icon-eto-check.png")
                cell.accessoryView = imgView
            }
        case 2: // 달성 효과음 선택 테이블
            cell.textLabel?.text = list.successSoundExplanation[indexPath.row]

            if UserDefaults.standard.integer(forKey: "successSoundState") == (indexPath.row - 1) {
                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 21))
                imgView.image = UIImage(named: "Icon-eto-check.png")
                cell.accessoryView = imgView
            }
        case 3: // 실패 효과음 선택 테이블
            cell.textLabel?.text = list.failSoundExplanation[indexPath.row]

            if UserDefaults.standard.integer(forKey: "failSoundState") == (indexPath.row - 1) {
                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 21))
                imgView.image = UIImage(named: "Icon-eto-check.png")
                cell.accessoryView = imgView
            }
        default: break
        }

        return cell
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
