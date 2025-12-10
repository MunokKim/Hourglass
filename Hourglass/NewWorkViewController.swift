//
//  NewWorkViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import CoreData
import NightNight
import SwiftIcons

class NewWorkViewController: UITableViewController, UITextFieldDelegate {
    
    var iconNumber: Int32?
    
    let context = AppDelegate.viewContext
    
    var isCellHeightExpanded: Bool = true {
        didSet{
            //(own internal logic removed)
            
            // 셀 높이를 확인하고 애니메이션을 적용한다.
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
//    // 빈곳을 터치하면 키보드나 데이트피커 등을 숨긴다
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        self.tableView.endEditing(true)
//    }
    
    @IBAction func saveWorkInfo(_ sender: Any) {
        
        persistentObjectStoreSave()
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func persistentObjectStoreSave() {
        
        // Core Data 영구 저장소에 WorkInfo 데이터 추가하기
        
        let workInfo = WorkInfo(context: context)
        
        workInfo.workName = workNameTextField?.text
        workInfo.iconNumber = iconNumber != nil ? iconNumber! : 1081
        workInfo.estimatedWorkTime = Int32((estimatedWorkTimePicker.selectedHours! * 3600) + (estimatedWorkTimePicker.selectedMinutes! * 60))
        workInfo.createdDate = NSDate().addingTimeInterval(60*60*9)
        
        if UserDefaults.standard.object(forKey: "AutoIncrementID") == nil {
            UserDefaults.standard.set(1, forKey: "AutoIncrementID")
            workInfo.workID = Int16(UserDefaults.standard.integer(forKey: "AutoIncrementID"))
        } else {
            let autoIncrementID = UserDefaults.standard.integer(forKey: "AutoIncrementID") + 1
            UserDefaults.standard.set(autoIncrementID, forKey: "AutoIncrementID")
            workInfo.workID = Int16(autoIncrementID)
        }
        
        do {
            try context.save()
            
            print("Context Save Success!")
            
        } catch let nserror as NSError {
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    @IBAction func cancelAndClose(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var workNameTextField: UITextField!
    @IBOutlet var workIconImageView: UIImageView!
    @IBOutlet var estimatedWorkTimePicker: WorkTimePicker!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var IconCell: UITableViewCell!
    @IBOutlet var iconCellLabel: UILabel!
    @IBOutlet var showEstimatedWorkTimeCell: UITableViewCell!
    @IBOutlet var pickerCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        workNameTextField.delegate = self
        
        addButton.isEnabled = false
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backViewColor.rawValue, night: AppsConstants.night.backViewColor.rawValue)
        navigationController?.navigationBar.mixedBarStyle = MixedBarStyle(normal: .default, night: .black)
        if NightNight.theme == .night {
            navigationController?.navigationBar.barStyle = .black
        } else if NightNight.theme == .normal {
            navigationController?.navigationBar.barStyle = .default
        }
        
        tableView.mixedSeparatorColor = MixedColor(normal: AppsConstants.normal.separatorColor.rawValue, night: AppsConstants.night.separatorColor.rawValue)
        iconCellLabel.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = AppsConstants.appMainColor // Sunshade
        
        workNameTextField.borderStyle = .none
        workNameTextField.backgroundColor = UIColor.clear
        workNameTextField.tintColor = AppsConstants.appMainColor
        workNameTextField.textColor = AppsConstants.appMainColor
        let attributedString = NSMutableAttributedString(string: "작업 이름 입력".localized)
        attributedString.setMixedAttributes([NNForegroundColorAttributeName: MixedColor(normal: 0xdcdcdc, night: 0x2c2c2c)], range: NSRange(location: 0, length: attributedString.length))
        workNameTextField.attributedPlaceholder = attributedString
        
        workIconImageView.setIcon(icon: .icofont(.hourGlass), textColor: MainViewController.mixedTextColor, backgroundColor: .clear, size: nil)
        
//        workIconImageView.layer.cornerRadius = workIconImageView.layer.frame.width / 2.66
//        workIconImageView.clipsToBounds = true
        
        showEstimatedWorkTimeCell.detailTextLabel?.textColor = AppsConstants.appMainColor
        
        self.hideKeyboardWhenTappedAround()
        tableView.keyboardDismissMode = .interactive
        
        let initValue = 30 // 분단위 초기값
        if let row = estimatedWorkTimePicker.rowForValue(value: initValue) {
            estimatedWorkTimePicker.selectRow(row, inComponent: 1, animated: false)
            pickerView(estimatedWorkTimePicker, didSelectRow: row, inComponent: 1)
        }
        
        // 그냥 가운데에서 시작
//        estimatedWorkTimePicker.selectRow(pickerViewMiddle, inComponent: 1, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        workNameTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressReturnInWorkName(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func editingChangedInWorkName(_ sender: Any) {
        
        saveButtonValidation()
    }
    
    func saveButtonValidation() {
        
        // 텍스트필드가 공백이거나 글자가 아닌 경우(공백, 특수문자 등) 또는 selectedMinutes를 아직 설정하지 않은 경우
        if workNameTextField.text == "" || workNameTextField.text?.rangeOfCharacter(from: CharacterSet.letters) == nil || estimatedWorkTimePicker.selectedMinutes == nil {
            
            addButton.isEnabled = false
        } else {
            
            addButton.isEnabled = true
        }
        
        // selectedHours와 selectedMinutes가 0일 경우
        if estimatedWorkTimePicker.selectedHours == 0 && estimatedWorkTimePicker.selectedMinutes == 0 {
            
            if let row = estimatedWorkTimePicker.rowForValue(value: 1) {
                
                estimatedWorkTimePicker.selectRow(row, inComponent: 1, animated: true)
                estimatedWorkTimePicker.selectedMinutes = 1
            }
        }
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
    
    // MARK: tableview
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backGroundColor.rawValue, night: AppsConstants.night.backGroundColor.rawValue)
        cell.textLabel?.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
//        cell.detailTextLabel?.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
        
        let viewForSelectedCell = UIView()
        viewForSelectedCell.mixedBackgroundColor = MixedColor(normal: 0xd4d4d4, night: 0x242424)
        cell.selectedBackgroundView = viewForSelectedCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            return 86
        } else if indexPath.row == 3 {
            if self.isCellHeightExpanded {
                // 확대
                pickerCell.contentView.isHidden = false
                
                return 217
            } else {
                // 축소
                pickerCell.contentView.isHidden = true
                
                return 0
            }
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 선택한 셀을 바로 선택해제하여 하이라이트 안보이게 하기
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row == 2 else { return }
        
        self.isCellHeightExpanded = self.isCellHeightExpanded ? false : true
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        if indexPath.row != 2 {
            let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
            selectedCell.isSelected = false
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "iconSegue" {
            
            if let vc = segue.destination as? NewIconCollectionViewController {
                
                vc.delegation = self as SendValueToViewControllerDelegate
                vc.iconNumber = iconNumber
            }
        }
     }
}

extension NewWorkViewController: SendValueToViewControllerDelegate {
    
    func sendIconNumber(value: Int32) {
        
        if let iconCase = IcofontType(rawValue: Int(value)) {
            
            self.workIconImageView.setIcon(icon: .icofont(iconCase), textColor: MainViewController.mixedTextColor, backgroundColor: .clear, size: nil)
            self.tableView.reloadData()
            self.iconNumber = value
        }
    }
    
    
    func sendValue(value: Int32) { }
}

extension NewWorkViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // "시간", "분" 레이블 삽입
        let viewWidth = self.view.bounds.width
        let insertRef = pickerView.subviews[0].subviews[0].subviews[safe: 2]!
        //        let hoursLabel: UILabel = UILabel(frame: CGRect(x: 130.5, y: 0, width: 60, height: componentHeight))
        //        let minutesLabel: UILabel = UILabel(frame: CGRect(x: 239.5, y: 0, width: 60, height: componentHeight))
        let hoursLabel: UILabel = UILabel(frame: CGRect(x: viewWidth/2 - 60, y: 0, width: 60, height: estimatedWorkTimePicker.componentHeight))
        let minutesLabel: UILabel = UILabel(frame: CGRect(x: viewWidth/2 + 50, y: 0, width: 60, height: estimatedWorkTimePicker.componentHeight))
        
        hoursLabel.textAlignment = NSTextAlignment.left
        hoursLabel.font = UIFont(name: "GodoM", size: 17)
        hoursLabel.mixedTextColor = MixedColor(normal: UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0), night: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
        insertRef.addSubview(hoursLabel)
        hoursLabel.text = "시간".localized
        
        minutesLabel.textAlignment = NSTextAlignment.left
        minutesLabel.font = UIFont(name: "GodoM", size: 17)
        minutesLabel.mixedTextColor = MixedColor(normal: UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0), night: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
        insertRef.addSubview(minutesLabel)
        minutesLabel.text = "분".localized
        
        // 피커뷰의 선택된 인덱스 상하에 있는 가로줄 색상 적용
        pickerView.subviews[1].mixedBackgroundColor = MixedColor(normal: UIColor(red:0.86, green:0.86, blue:0.88, alpha:1.00), night: UIColor(red:0.14, green:0.14, blue:0.12, alpha:1.00))
//        pickerView.subviews[safe: 2]!.mixedBackgroundColor = MixedColor(normal: UIColor(red:0.86, green:0.86, blue:0.88, alpha:1.00), night: UIColor(red:0.14, green:0.14, blue:0.12, alpha:1.00))
        
        var viewWithLabel: UIView?
        
        if viewWithLabel == nil {
            viewWithLabel = UIView(frame: CGRect(x: 0, y: 0, width: estimatedWorkTimePicker.componentWidth, height: estimatedWorkTimePicker.componentHeight))
            
            let label: UILabel = UILabel(frame: CGRect(x: 11, y: 0, width: 30, height: estimatedWorkTimePicker.componentHeight))
            label.font = UIFont(name: "GodoM", size: 17)
            label.mixedTextColor = MixedColor(normal: UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0), night: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
            label.textAlignment = NSTextAlignment.right
            viewWithLabel?.addSubview(label)
        }
        
        if let label: UILabel = viewWithLabel?.subviews[0] as? UILabel {
            
            label.text = String(estimatedWorkTimePicker.valueForRow(row: row))
        }
        
        return viewWithLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return estimatedWorkTimePicker.componentHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return 106
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        estimatedWorkTimePicker.selectedHours = estimatedWorkTimePicker.hoursPickerData[pickerView.selectedRow(inComponent: 0)]
        estimatedWorkTimePicker.selectedMinutes = estimatedWorkTimePicker.minutesPickerData[pickerView.selectedRow(inComponent: 1) % estimatedWorkTimePicker.minutesPickerData.count]
        
        saveButtonValidation()
        
        var estimatedWorkTimeString: String = String(estimatedWorkTimePicker.selectedHours!) + "시간".localized + " " + String(estimatedWorkTimePicker.selectedMinutes!) + "분".localized
        
        if estimatedWorkTimePicker.selectedHours == 0 {
            estimatedWorkTimeString = String(estimatedWorkTimePicker.selectedMinutes!) + "분".localized
        }
        
        showEstimatedWorkTimeCell.detailTextLabel?.text = estimatedWorkTimeString
    }
}

extension NewWorkViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case estimatedWorkTimePicker.hourComponent: return estimatedWorkTimePicker.hoursPickerData.count
        case estimatedWorkTimePicker.minuteComponent: return estimatedWorkTimePicker.largeNumber
        default: break
        }
        return 0
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
