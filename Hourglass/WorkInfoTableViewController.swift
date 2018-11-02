//
//  WorkInfoTableViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 23/10/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import CoreData
import MarqueeLabel
import NightNight

class WorkInfoTableViewController: UITableViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    var selectedIndex: Int?
    let context = AppDelegate.viewContext
    let workingVC = WorkingViewController()
    var workInfoFetch: WorkInfo?
    var estimatedWorkTimeForPopover: Int32?
    
    @objc func individualUpdateWorkInfo() {
        
        if let workinfo = workInfoFetch {
            
            workinfo.setValue(workNameTextField.text, forKey: "workName")
            // icon
            if let value = estimatedWorkTimeForPopover {
                workinfo.setValue(value, forKey: "estimatedWorkTime")
            }
            
            do {
                try context.save()
                
            } catch let nserror as NSError {
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @IBOutlet var workNameLabel: MarqueeLabel! {
        didSet {
            workNameLabel.textColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
            
            // 레이블을 터치하면 텍스트필드로 바꾸고 입력받기
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.workNameLabelTapped))
            tapGesture.numberOfTapsRequired = 1
            workNameLabel.addGestureRecognizer(tapGesture)
            workNameLabel.isUserInteractionEnabled = true
        }
    }
    @IBOutlet var workNameTextField: UITextField! {
        didSet {
            workNameTextField.borderStyle = .none
            workNameTextField.backgroundColor = UIColor.clear
            
            workNameTextField.delegate = self
            workNameTextField.isHidden = true
        }
    }
    @IBOutlet var workIconImageView: UIImageView! {
        didSet {
            workIconImageView.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.00)
            workIconImageView.layer.cornerRadius = workIconImageView.layer.frame.width / 2.66
            workIconImageView.clipsToBounds = true
        }
    }
    @IBOutlet var justLabel: UILabel!
    @IBOutlet var currentSuccessiveAchievementWhetherLabel: UILabel!
    @IBOutlet var successiveAchievementHighestRecordLabel: UILabel!
    @IBOutlet var totalWorkLabel: UILabel!
    @IBOutlet var goalSuccessLabel: UILabel!
    @IBOutlet var goalFailLabel: UILabel!
    @IBOutlet var successRateLabel: UILabel!
    @IBOutlet var averageElapsedTimeLabel: UILabel!
    @IBOutlet var averageRemainingTimeLabel: UILabel!
    
    @IBOutlet var estimatedWorkTimePickerButton: UIButton! {
        didSet {
            estimatedWorkTimePickerButton.setTitleColor(UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00), for: .normal)
        }
    }
    
    @IBOutlet var workRecordButton: UIButton! {
        didSet {
            workRecordButton.backgroundColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
            workRecordButton.layer.cornerRadius = 10
            workRecordButton.layer.masksToBounds = true
        }
    }
    
    @IBAction func popoverWorkTimePicker(_ sender: UIButton) {
        
        
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
        tableView.mixedSeparatorColor = MixedColor(normal: 0xC8C8CC, night: 0x38383c)
        justLabel.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
        workNameTextField.mixedTextColor = MixedColor(normal: 0x222222, night: 0xeaeaea)
        
        self.hideKeyboardWhenTappedAround()
        tableView.keyboardDismissMode = .interactive
        
        // 네비게이션 컨트롤러 하위의 뷰에서는 large title 비활성화 하기
        navigationItem.largeTitleDisplayMode = .never
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
        fetchAndRenewal()
        
        // UIButton의 setBackgroundImage를 이용한 메서드를 익스텐션으로 만들어서 사용
        workRecordButton.setBackgroundColor(color: UIColor(red:0.99, green:0.81, blue:0.64, alpha:1.00), forState: UIControl.State.highlighted)
        
        // Add Observer
        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(WorkInfoTableViewController.fetchAndRenewal), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        notificationCenter.addObserver(self, selector: #selector(WorkInfoTableViewController.fetchAndRenewal), name: NSNotification.Name(rawValue: "FetchAndRenewalNoti"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(WorkInfoTableViewController.individualUpdateWorkInfo), name: NSNotification.Name(rawValue: "UpdateWorkInfoNoti"), object: nil)
    }
    
    @objc func fetchAndRenewal() {
        
        // 메인에서 터치해서 선택된 인덱스로 불러온 WorkInfo객체
        workInfoFetch = workingVC.contextFetchToSelectedIndex(selectedIndex)
        
        guard workInfoFetch != nil else { return }
        
        workNameLabel.text = workInfoFetch!.workName
        // icon
        estimatedWorkTimePickerButton.setTitle(workInfoFetch!.estimatedWorkTime.secondsToString, for: .normal)
        currentSuccessiveAchievementWhetherLabel.text = "\(workInfoFetch!.currentSuccessiveAchievementWhether) 회" // 현재 연속 달성 여부
        successiveAchievementHighestRecordLabel.text = "\(workInfoFetch!.successiveAchievementHighestRecord) 회" // 연속 달성 최고기록
        
        totalWorkLabel.text = "\(workInfoFetch!.totalWork) 회" // 총 작업
        goalSuccessLabel.text = "\(workInfoFetch!.goalSuccess) 회" // 목표 달성
        goalFailLabel.text = "\(workInfoFetch!.goalFail) 회" // 목표 실패
        successRateLabel.text = String(format: "%.0f", workInfoFetch!.successRate * 100) + " %" // 성공률
        averageElapsedTimeLabel.text = Int32(workInfoFetch!.averageElapsedTime).secondsToString // 평균 소요시간
        averageRemainingTimeLabel.text = Int32(workInfoFetch!.averageRemainingTime).secondsToString // 평균 남은 시간
        
        if workInfoFetch!.totalWork == 0 {
            // 진행한 작업이 없을 때
            let noticeView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 45))
            noticeView.mixedBackgroundColor = MixedColor(normal: UIColor.black, night: UIColor.white)
            noticeView.alpha = 0.5
            
            let noticeLabel = UILabel()
            noticeLabel.center = CGPoint(x: noticeView.frame.size.width / 2, y: noticeView.frame.size.height / 2)
            noticeLabel.text = "진행한 작업이 없습니다. 작업을 시작해보세요."
            noticeLabel.mixedTextColor = MixedColor(normal: 0xfafafa, night: 0x1b1c1e)
            noticeLabel.font = UIFont(name: "GodoM", size: 15)
            noticeLabel.textAlignment = .center
            noticeLabel.frame = noticeView.frame
            
            noticeView.addSubview(noticeLabel)
            self.tableView.addSubview(noticeView)
            
            workRecordButton.isEnabled = false
            workRecordButton.backgroundColor = UIColor(red:0.99, green:0.81, blue:0.64, alpha:1.00)
        }
    }
    
//        // 빈곳을 터치하면 키보드나 데이트피커 등을 숨긴다
//        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            super.touchesBegan(touches, with: event)
//
//            self.tableView.endEditing(true)
//        }
    
    @objc func workNameLabelTapped(gesture: UITapGestureRecognizer) {
        
        gesture.view?.isHidden = true
        workNameTextField.isHidden = false
        workNameTextField.text = workNameLabel.text
        workNameTextField.becomeFirstResponder()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return .none
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        textField.isHidden = true
        workNameLabel.isHidden = false
        workNameLabel.text = textField.text
        
        // WorkInfo 업데이트
        individualUpdateWorkInfo()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 30
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
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
    }
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
     */
    
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "WorkingSegue" {
            
            if let vc = segue.destination as? WorkingViewController {
                
                print("selectedIndex is : \(self.selectedIndex)")
                vc.selectedIndex = self.selectedIndex
            }
        }
        
        if segue.identifier == "popoverSegue" {
            
            if let vc = segue.destination as? PopoverPickerViewController {
                
                vc.modalPresentationStyle = .popover
                
                if let popoverVC = vc.popoverPresentationController {
                    popoverVC.permittedArrowDirections = .any
                    popoverVC.sourceView = self.estimatedWorkTimePickerButton
                    popoverVC.sourceRect = CGRect(x: self.estimatedWorkTimePickerButton.bounds.minX, y: self.estimatedWorkTimePickerButton.bounds.minY, width: self.estimatedWorkTimePickerButton.bounds.width, height: self.estimatedWorkTimePickerButton.bounds.height)
                    popoverVC.presentedView?.mixedBackgroundColor = MixedColor(normal: 0xfafafa, night: 0x1b1c1e)
                    popoverVC.delegate = self
                }
                
                vc.delegation = self as? PopoverPickerViewControllerDelegate
                
                vc.estimatedWorkTimeForPopover = workInfoFetch!.estimatedWorkTime
            }
            
            // 예상작업시간 팝오버에 넘겨주기
            
        }
    }

}

extension WorkInfoTableViewController: PopoverPickerViewControllerDelegate {
    
    func sendValue(value: Int32) {
        
        estimatedWorkTimePickerButton.setTitle(value.secondsToString, for: .normal)
        estimatedWorkTimeForPopover = value
        
        individualUpdateWorkInfo()
    }
}

extension UIButton {

    func setBackgroundColor(color: UIColor, forState: UIControl.State) {

        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(colorImage, for: forState)
    }
}
