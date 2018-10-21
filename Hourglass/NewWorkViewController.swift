//
//  NewWorkViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import CoreData

class NewWorkViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let context = AppDelegate.viewContext
    
    let hourComponent: Int = 0
    let minuteComponent: Int = 1
    let hoursPickerData: [Int] = Array(0...9) // 타임피커의 시간제한 기본값 10시간 -1초
    let minutesPickerData: [Int] = Array(0...59)
    let componentWidth: CGFloat = 120
    let componentHeight: CGFloat = 32
    let largeNumber: Int = 400
    lazy var pickerViewMiddle: Int = ((largeNumber / minutesPickerData.count) / 2) * minutesPickerData.count
    var selectedHours: Int?
    var selectedMinutes: Int?
    
    internal var isCellHeightExpanded: Bool = false {
        didSet{
            //(own internal logic removed)
            
            // 셀 높이를 확인하고 애니메이션을 적용한다.
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func valueForRow(row: Int) -> Int {
        // the rows repeat every `pickerViewData.count` items
        return minutesPickerData[row % minutesPickerData.count]
    }
    
    func rowForValue(value: Int) -> Int? {
        if let valueIndex = minutesPickerData.firstIndex(of: value) {
            return pickerViewMiddle + value
        }
        return nil
    }
    
    @IBAction func saveWorkInfo(_ sender: Any) {
        
        persistentObjectStoreSave()
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func persistentObjectStoreSave() {
        
        // Core Data 영구 저장소에 WorkInfo 데이터 추가하기
        
        let workInfo = WorkInfo(context: context)
        
        workInfo.workName = workNameTextField?.text
        workInfo.estimatedWorkTime = Int32((selectedHours! * 3600) + (selectedMinutes! * 60))
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
    @IBOutlet var estimatedWorkTimePicker: UIPickerView!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var IconCell: UITableViewCell!
    @IBOutlet var showEstimatedWorkTimeCell: UITableViewCell!
    @IBOutlet var pickerCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        workNameTextField.delegate = self
        
        addButton.isEnabled = false
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
        workNameTextField.borderStyle = .none
        workNameTextField.backgroundColor = UIColor.clear
        workNameTextField.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        workNameTextField.textColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        
        workIconImageView.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.00)
        workIconImageView.layer.cornerRadius = workIconImageView.layer.frame.width / 2.66
        workIconImageView.clipsToBounds = true
        
        showEstimatedWorkTimeCell.detailTextLabel?.textColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00)
        
        estimatedWorkTimePicker.delegate = self
        estimatedWorkTimePicker.dataSource = self
        
        let initValue = 30 // 분단위 초기값
        if let row = rowForValue(value: initValue) {
            estimatedWorkTimePicker.selectRow(row, inComponent: 1, animated: false)
        }
        
        // 그냥 가운데에서 시작
        //        estimatedWorkTimePicker.selectRow(pickerViewMiddle, inComponent: 1, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 빈곳을 터치하면 키보드나 데이트피커 등을 숨긴다
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func pressReturnInWorkName(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func editingChangedInWorkName(_ sender: Any) {
        
        saveButtonValidation()
    }
    
    func saveButtonValidation() {
        
        // 텍스트필드가 공백이거나 글자가 아닌 경우(공백, 특수문자 등) 그리고 selectedMinutes를 아직 설정하지 않은 경우
        if workNameTextField.text == "" || workNameTextField.text?.rangeOfCharacter(from: CharacterSet.letters) == nil || selectedMinutes == nil {
            
            addButton.isEnabled = false
        } else {
            
            addButton.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 20
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
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
        
        if self.isCellHeightExpanded {
            self.isCellHeightExpanded = false
        } else {
            self.isCellHeightExpanded = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        if indexPath.row != 2 {
            let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
            selectedCell.isSelected = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case hourComponent: return hoursPickerData.count
        case minuteComponent: return largeNumber
        default: break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // "시간", "분" 레이블 삽입
        let insertRef = pickerView.subviews[0].subviews[0].subviews[2]
        let hoursLabel: UILabel = UILabel(frame: CGRect(x: 130.5, y: 0, width: 60, height: componentHeight))
        let minutesLabel: UILabel = UILabel(frame: CGRect(x: 239.5, y: 0, width: 60, height: componentHeight))
        
        if UIScreen.main.bounds.width > 320 {
            hoursLabel.textAlignment = NSTextAlignment.center
        } else {
            hoursLabel.textAlignment = NSTextAlignment.left
        }
        
        hoursLabel.font = UIFont(name: "systemFont", size: 23)
        insertRef.addSubview(hoursLabel)
        hoursLabel.text = "시간"
        
        if UIScreen.main.bounds.width > 320 {
            minutesLabel.textAlignment = NSTextAlignment.center
        } else {
            minutesLabel.textAlignment = NSTextAlignment.left
        }
        
        minutesLabel.font = UIFont(name: "systemFont", size: 23)
        insertRef.addSubview(minutesLabel)
        minutesLabel.text = "분"
        
        // 피커뷰의 선택된 인덱스 상하에 있는 가로줄 색상 적용
        pickerView.subviews[1].backgroundColor = UIColor(red:0.86, green:0.86, blue:0.88, alpha:1.00)
        pickerView.subviews[2].backgroundColor = UIColor(red:0.86, green:0.86, blue:0.88, alpha:1.00)
        
        var viewWithLabel: UIView?
        
        if viewWithLabel == nil {
            viewWithLabel = UIView(frame: CGRect(x: 0, y: 0, width: componentWidth, height: componentHeight))
            
            let label: UILabel = UILabel(frame: CGRect(x: 11, y: 0, width: 30, height: componentHeight))
            label.font = UIFont(name: "systemFont", size: 23)
            label.textAlignment = NSTextAlignment.right
            viewWithLabel?.addSubview(label)
        }
        
        if let label: UILabel = viewWithLabel?.subviews[0] as? UILabel {
            
            label.text = String(valueForRow(row: row))
        }
        
        return viewWithLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return componentHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 106
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedHours = hoursPickerData[pickerView.selectedRow(inComponent: 0)]
        selectedMinutes = minutesPickerData[pickerView.selectedRow(inComponent: 1) % minutesPickerData.count]
        
        saveButtonValidation()
        
        var estimatedWorkTimeString: String = "\(selectedHours!)시간 \(selectedMinutes!)분"
        
        if selectedHours == 0 {
            estimatedWorkTimeString = "\(selectedMinutes!)분"
        }
        
        showEstimatedWorkTimeCell.detailTextLabel?.text = estimatedWorkTimeString
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

