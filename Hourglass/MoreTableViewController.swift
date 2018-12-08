//
//  MoreTableViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 03/11/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import NightNight
import MessageUI

class MoreTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var feedbackCell: UITableViewCell!
    @IBOutlet var appStoreReviewCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 네비게이션 컨트롤러 하위의 뷰에서는 large title
        navigationItem.largeTitleDisplayMode = .never
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backViewColor.rawValue, night: AppsConstants.night.backViewColor.rawValue)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        if NightNight.theme == .night {
            navigationController?.navigationBar.barStyle = .black
        } else if NightNight.theme == .normal {
            navigationController?.navigationBar.barStyle = .default
        }
        tableView.mixedSeparatorColor = MixedColor(normal: AppsConstants.normal.separatorColor.rawValue, night: AppsConstants.night.separatorColor.rawValue)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            print("취소")
        case .saved:
            print("임시저장")
        case .sent:
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 완료", message: "소중한 의견 감사드립니다. :D", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            sendMailErrorAlert.addAction(cancelAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        default:
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            sendMailErrorAlert.addAction(cancelAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backGroundColor.rawValue, night: AppsConstants.night.backGroundColor.rawValue)
        cell.textLabel?.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
        
        cell.textLabel?.font = UIFont(name: "GodoM", size: 17)
        
        let viewForSelectedCell = UIView()
        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: 0xd4d4d4, night: 0x242424)
        cell.selectedBackgroundView = viewForSelectedCell
        
//        if indexPath.section == 1 {
//            cell.textLabel?.mixedTextColor = MixedColor(normal: UIColor.lightGray, night: UIColor.darkGray)
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        switch cell {
        case feedbackCell:
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["wer0222@icloud.com"])
                mail.setSubject("모래시계에 대한 피드백")
                mail.setMessageBody("새롭게 추가 할 기능이나 개선이 필요한 사항을 알려주시면 신속하게 반영하겠습니다 :)", isHTML: false)
                present(mail, animated: true)
            } else {
                let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
                sendMailErrorAlert.addAction(cancelAction)
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            }
        case appStoreReviewCell:
            
            let myAppID = "1441559871"
            
            if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(myAppID)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) { // 유효한 URL인지 검사합니다.
                if #available(iOS 10.0, *) { //iOS 10.0부터 URL를 오픈하는 방법이 변경 되었습니다.
                    UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(reviewURL)
                }
            }
        default:
            break
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
