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
import SwiftIcons

class WorkInfoTableViewController: UITableViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var selectedIndex: Int?
    let context = AppDelegate.viewContext
    let workingVC = WorkingViewController()
    var workInfoFetch: WorkInfo?
    var estimatedWorkTimeForPopover: Int32?
    var iconNumber: Int32?
    
    @objc func individualUpdateWorkInfo() {
        
        if let workinfo = workInfoFetch {
            
            workinfo.setValue(workNameTextField.text, forKey: "workName")
            if let value = iconNumber {
                workinfo.setValue(value, forKey: "iconNumber")
            }
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
            workNameLabel.textColor = AppsConstants.appMainColor // Sunshade
            
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
    @IBOutlet var workIconButton: UIButton! {
        didSet {
            workIconButton.layer.cornerRadius = workIconButton.layer.frame.width / 2.66
            workIconButton.clipsToBounds = true
            workIconButton.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.iconBackgroundColor.rawValue, night: AppsConstants.night.iconBackgroundColor.rawValue)
            workIconButton.layer.mixedShadowColor = MixedColor(normal: UIColor.lightGray, night: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
            workIconButton.layer.shadowRadius = 2.0
            workIconButton.layer.shadowOpacity = 0.5
            workIconButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            workIconButton.layer.masksToBounds = false
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
            estimatedWorkTimePickerButton.setTitleColor(AppsConstants.appMainColor, for: .normal)
        }
    }
    
    @IBOutlet var deleteButton: UIBarButtonItem! {
        didSet {
            // Icon with custom cgRect
            deleteButton.setIcon(icon: .icofont(.uiDelete), iconSize: 25, color: AppsConstants.appMainColor, cgRect: CGRect(x: 0, y: 0, width: 50, height: 25), target: self, action: #selector(deleteButtonTapped(_:)))
        }
    }
    
    @IBOutlet var startButton: UIBarButtonItem! {
        didSet {
            // Icon with custom cgRect
            startButton.setIcon(icon: .icofont(.playAlt2), iconSize: 25, color: AppsConstants.appMainColor, cgRect: CGRect(x: 0, y: 0, width: 25, height: 25), target: self, action: #selector(startButtonTapped(_:)))
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: (workInfoFetch?.workName ?? "") + "삭제".localized, message: "이 동작은 되돌릴 수 없습니다.".localized, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제".localized, style: .destructive) { _ in
            guard let work = self.workInfoFetch else { return }
            let isDelete = MainViewController().deleteWorkInfo(work: work)
            if isDelete {
                // mainVC로 빠져나감
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "취소".localized, style: .default, handler: nil)
        cancelAction.setValue(AppsConstants.appMainColor, forKey: "titleTextColor")
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        //디바이스 타입이 iPad일때 alert가 popover되는 위치를 지정해 주어야 한다.
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
    
    @IBAction func startButtonTapped(_ sender: Any) {
        // WorkingVC로 이동
        let storyboardName = "Working"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let newVC = storyboard.instantiateViewController(withIdentifier: "WorkingViewController") as? WorkingViewController {
            newVC.modalPresentationStyle = .fullScreen
            newVC.modalTransitionStyle = .crossDissolve
            newVC.selectedIndex = self.selectedIndex
            self.present(newVC, animated: true)
        } else {
            print("Unable to instantiate VC from \(storyboardName) storyboard")
        }
    }
    
    @IBOutlet var workRecordButton: UIButton! {
        didSet {
            // 모서리 둥글게
            workRecordButton.layer.cornerRadius = 15
            workRecordButton.layer.masksToBounds = true
            
            // 그림자 효과
            workRecordButton.layer.mixedShadowColor = MixedColor(normal: UIColor.lightGray, night: UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0))
            workRecordButton.layer.shadowRadius = 2.5
            workRecordButton.layer.shadowOpacity = 1.0
            workRecordButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            workRecordButton.layer.masksToBounds = false
            
            
            // Icon with color & colored text around it
            workRecordButton.setIcon(prefixText: "", prefixTextColor: .clear, icon: .icofont(.clipBoard), iconColor: UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.00), postfixText: " 기록 보기".localized, postfixTextColor: UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.00), forState: .normal, textSize: 18, iconSize: nil)
            // Icon with color & colored text around it
            workRecordButton.setIcon(prefixText: "", prefixTextColor: .clear, icon: .icofont(.clipBoard), iconColor: UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.00), postfixText: " 기록 보기".localized, postfixTextColor: UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.00), forState: .highlighted, textSize: 18, iconSize: nil)
            
            workRecordButton.backgroundColor = AppsConstants.appMainColor // Sunshade
        }
    }
    
    @IBAction func workRecordButton(_ sender: Any) {
        
        // RecordVC로 이동
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let newVC = storyboard.instantiateViewController(withIdentifier: "RecordTableViewController") as? RecordTableViewController {
            newVC.selectedIndex = self.selectedIndex
            self.navigationController?.pushViewController(newVC, animated: true)
        } else {
            print("Unable to instantiate VC from \(storyboardName) storyboard")
        }
        
    }
    
//    override func viewWillLayoutSubviews() {
//        fetchAndRenewal()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 네비게이션 컨트롤러 하위의 뷰에서는 large title
        navigationItem.largeTitleDisplayMode = .automatic
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backViewColor.rawValue, night: AppsConstants.night.backViewColor.rawValue)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        if NightNight.theme == .night {
            navigationController?.navigationBar.barStyle = .black
        } else if NightNight.theme == .normal {
            navigationController?.navigationBar.barStyle = .default
        }
        tableView.mixedSeparatorColor = MixedColor(normal: AppsConstants.normal.separatorColor.rawValue, night: AppsConstants.night.separatorColor.rawValue)
        justLabel.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
        workNameTextField.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
        
        // 테마에 따른 pencil 이미지 색상 전환
//        for visibleCell in self.tableView.visibleCells {
//            let imageViews = visibleCell.contentView.subviews.compactMap { $0 as? UIImageView }
//            for imageView in imageViews {
//                imageView.mixedImage = MixedImage(normal: UIImage(named: "pencil_normal.png")!, night: UIImage(named: "pencil.png")!)
//
//            }
//        }
        
        self.hideKeyboardWhenTappedAround()
        tableView.keyboardDismissMode = .interactive
        
        // 네비게이션 컨트롤러 하위의 뷰에서는 large title
        navigationItem.largeTitleDisplayMode = .automatic
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = AppsConstants.appMainColor // Sunshade
        
        fetchAndRenewal()
        
        // UIButton의 setBackgroundImage를 이용한 메서드를 익스텐션으로 만들어서 사용
//        workRecordButton.setBackgroundColor(color: UIColor(red:0.99, green:0.81, blue:0.64, alpha:1.00), forState: UIControl.State.highlighted)
//        deleteButton.setBackgroundColor(color: UIColor(red:0.99, green:0.81, blue:0.64, alpha:1.00), forState: UIControl.State.highlighted)
        
        workNameTextField.text = workNameLabel.text
        
        // Add Observer
        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(WorkInfoTableViewController.fetchAndRenewal), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.fetchAndRenewal), name: NSNotification.Name(rawValue: "FetchAndRenewalNoti"), object: nil)
//        notificationCenter.addObserver(self, selector: #selector(WorkInfoTableViewController.individualUpdateWorkInfo), name: NSNotification.Name(rawValue: "UpdateWorkInfoNoti"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 테마에 따른 pencil 이미지 색상 전환
        for visibleCell in self.tableView.visibleCells {
            let imageViews = visibleCell.contentView.subviews.compactMap { $0 as? UIImageView }
            for imageView in imageViews {
                imageView.mixedImage = MixedImage(normal: UIImage(named: "pencil_normal.png")!, night: UIImage(named: "pencil.png")!)
            }
        }
    }
    
    @objc func fetchAndRenewal() {
        
        // 메인에서 터치해서 선택된 인덱스로 불러온 WorkInfo객체
        workInfoFetch = workingVC.fetchToSelectedIndex(selectedIndex)
        
        guard let workInfoFetch = workInfoFetch else { return }
        
        workNameLabel.text = workInfoFetch.workName
        
        let mixedBackgroundColor = NightNight.theme == .night ? UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.00) : UIColor(red: 238/255, green: 238/255, blue: 243/255, alpha: 1.00)
        
        if let iconCase = IcofontType(rawValue: Int(workInfoFetch.iconNumber)) {
            workIconButton.setIcon(icon: .icofont(iconCase), iconSize: 100, color: MainViewController.mixedTextColor, backgroundColor: mixedBackgroundColor, forState: .normal)
        }
        
        estimatedWorkTimePickerButton.setTitle(workInfoFetch.estimatedWorkTime.secondsToString, for: .normal)
        currentSuccessiveAchievementWhetherLabel.text = String(workInfoFetch.currentSuccessiveAchievementWhether) + " " + "회".localized // 현재 연속 달성 여부
        successiveAchievementHighestRecordLabel.text = String(workInfoFetch.successiveAchievementHighestRecord) + " " + "회".localized // 연속 달성 최고기록
        
        totalWorkLabel.text = String(workInfoFetch.totalWork) + " " + "회".localized // 총 작업
        goalSuccessLabel.text = String(workInfoFetch.goalSuccess) + " " + "회".localized // 목표 달성
        goalFailLabel.text = String(workInfoFetch.goalFail) + " " + "회".localized // 목표 실패
        successRateLabel.text = String(format: "%.0f", workInfoFetch.successRate * 100) + " %" // 성공률
        averageElapsedTimeLabel.text = Int32(workInfoFetch.averageElapsedTime).secondsToString // 평균 소요시간
        averageRemainingTimeLabel.text = Int32(workInfoFetch.averageRemainingTime).secondsToString // 평균 남은 시간
        
        // 진행한 작업이 없었는데 지금 진행하고 다시 돌아왔을 경우
        self.tableView.viewWithTag(99)?.removeFromSuperview()
        
        if workInfoFetch.totalWork == 0 {
            // 진행한 작업이 없을 때
            
            let noticeView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 45))
            noticeView.mixedBackgroundColor = MixedColor(normal: UIColor.black, night: UIColor.white)
            noticeView.alpha = 0.5
            noticeView.tag = 99
            
            let noticeLabel = UILabel()
            noticeLabel.center = CGPoint(x: noticeView.frame.size.width / 2, y: noticeView.frame.size.height / 2)
            noticeLabel.text = "진행한 작업이 없습니다. 작업을 시작해보세요.".localized
            noticeLabel.mixedTextColor = MixedColor(normal: AppsConstants.normal.backGroundColor.rawValue, night: AppsConstants.night.backGroundColor.rawValue)
            noticeLabel.font = UIFont(name: "GodoM", size: 15)
            noticeLabel.textAlignment = .center
            noticeLabel.frame = noticeView.frame
            
            noticeView.addSubview(noticeLabel)
            self.tableView.addSubview(noticeView)
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
        
        // 텍스트필드가 공백이거나 글자가 아닌 경우(공백, 특수문자 등)
        if workNameTextField.text == "" || workNameTextField.text?.rangeOfCharacter(from: CharacterSet.letters) == nil {
            
            // 부르르 떠는 애니메이션
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.workNameLabel.center.x - 10, y: self.workNameLabel.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.workNameLabel.center.x + 10, y: self.workNameLabel.center.y))
            
            self.workNameLabel.layer.add(animation, forKey: "position")
            
        } else {
            workNameLabel.text = textField.text
            
            // WorkInfo 업데이트
            individualUpdateWorkInfo()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 30
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
    
    @IBAction func editingChangedInWorkName(_ sender: Any) {
        

    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return MixedStatusBarStyle(normal: .default, night: .lightContent).unfold()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backGroundColor.rawValue, night: AppsConstants.night.backGroundColor.rawValue)
        cell.textLabel?.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
        cell.detailTextLabel?.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
        
        let viewForSelectedCell = UIView()
        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: 0xd4d4d4, night: 0x242424)
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
        
        switch segue.identifier {
            
        case "RecordSegue":
            
            if let vc = segue.destination as? RecordTableViewController {
                
                print("selectedIndex is : \(String(describing: self.selectedIndex))")
                vc.selectedIndex = self.selectedIndex
            }
            
        case "popoverIconSegue":
            
            if let vc = segue.destination as? PopoverCollectionViewController {
                
                vc.modalPresentationStyle = .popover
                
                if let popoverVC = vc.popoverPresentationController {
                    popoverVC.permittedArrowDirections = .any
                    popoverVC.sourceView = self.workIconButton
                    popoverVC.sourceRect = CGRect(x: self.workIconButton.bounds.minX, y: self.workIconButton.bounds.minY, width: self.workIconButton.bounds.width, height: self.workIconButton.bounds.height)
                    popoverVC.presentedView?.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backGroundColor.rawValue, night: AppsConstants.night.backGroundColor.rawValue)
                    popoverVC.delegate = self
                }
                
                vc.delegation = self as SendValueToViewControllerDelegate
                
                // 아이콘번호 팝오버에 넘겨주기
                vc.iconNumber = workInfoFetch!.iconNumber
            }
            
        case "popoverPickerSegue":
            
            if let vc = segue.destination as? PopoverPickerViewController {
                
                vc.modalPresentationStyle = .popover
                
                if let popoverVC = vc.popoverPresentationController {
                    popoverVC.permittedArrowDirections = .any
                    popoverVC.sourceView = self.estimatedWorkTimePickerButton
                    popoverVC.sourceRect = CGRect(x: self.estimatedWorkTimePickerButton.bounds.minX, y: self.estimatedWorkTimePickerButton.bounds.minY, width: self.estimatedWorkTimePickerButton.bounds.width, height: self.estimatedWorkTimePickerButton.bounds.height)
                    popoverVC.presentedView?.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backGroundColor.rawValue, night: AppsConstants.night.backGroundColor.rawValue)
                    popoverVC.delegate = self
                }
                
                vc.delegation = self as SendValueToViewControllerDelegate
                
                // 예상작업시간 팝오버에 넘겨주기
                vc.estimatedWorkTimeForPopover = workInfoFetch!.estimatedWorkTime
            }
            
        default : break
        }
    }
}

extension WorkInfoTableViewController: SendValueToViewControllerDelegate {
    
    func sendValue(value: Int32) {
        
        estimatedWorkTimePickerButton.setTitle(value.secondsToString, for: .normal)
        estimatedWorkTimeForPopover = value
        
        individualUpdateWorkInfo()
    }
    
    func sendIconNumber(value: Int32) {
        
        let mixedBackgroundColor = NightNight.theme == .night ? UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.00) : UIColor(red: 238/255, green: 238/255, blue: 243/255, alpha: 1.00)
        
        if let iconCase = IcofontType(rawValue: Int(value)) {
            workIconButton.setIcon(icon: .icofont(iconCase), iconSize: nil, color: MainViewController.mixedTextColor, backgroundColor: mixedBackgroundColor, forState: .normal)
        }
        iconNumber = value
        
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

extension UIView
{
    func searchVisualEffectsSubview() -> UIVisualEffectView?
    {
        if let visualEffectView = self as? UIVisualEffectView
        {
            return visualEffectView
        }
        else
        {
            for subview in subviews
            {
                if let found = subview.searchVisualEffectsSubview()
                {
                    return found
                }
            }
        }
        
        return nil
    }
}
