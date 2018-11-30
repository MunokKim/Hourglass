//
//  PopoverPickerViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 31/10/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import NightNight

protocol SendValueToViewControllerDelegate {
    
    func sendValue(value: Int32)
}

class PopoverPickerViewController: UIViewController {
    
    var delegation: SendValueToViewControllerDelegate?
    var estimatedWorkTimeForPopover: Int32?
    
    @IBOutlet var popoverPicker: WorkTimePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: 0xefeff4, night: 0x121315)
        self.popoverPresentationController?.mixedBackgroundColor = MixedColor(normal: 0xefeff4, night: 0x121315)
        
        if let initValue = estimatedWorkTimeForPopover, let row = popoverPicker.rowForValue(value: Int(initValue%3600/60)) {
            
            popoverPicker.selectRow(Int(initValue/3600), inComponent: 0, animated: false) // 시단위 초기값
            popoverPicker.selectRow(row, inComponent: 1, animated: false) // 분단위 초기값
        }
        
        // 그냥 가운데에서 시작
        //        popoverPicker.selectRow(pickerViewMiddle, inComponent: 1, animated: false)
        
        /*
         // MARK: - Navigation
         
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let value = estimatedWorkTimeForPopover {
        
            delegation?.sendValue(value: value)
        }
        
//        if let presenter = presentingViewController as? WorkInfoTableViewController {
//
//            presenter.estimatedWorkTimeForPopover = estimatedWorkTimeForPopover
//        }
//
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateWorkInfoNoti"), object: nil)
    }
    
    func changeButtonValidation() {
        
        // selectedHours와 selectedMinutes가 0일 경우
        if popoverPicker.selectedHours == 0 && popoverPicker.selectedMinutes == 0 {
            
            if let row = popoverPicker.rowForValue(value: 1) {
                
                popoverPicker.selectRow(row, inComponent: 1, animated: true)
                popoverPicker.selectedMinutes = 1
            }
        }
    }
}

extension PopoverPickerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // "시간", "분" 레이블 삽입
        let popoverWidth = self.popoverPicker.bounds.width
        let insertRef = pickerView.subviews[0].subviews[0].subviews[2]
        //        let hoursLabel: UILabel = UILabel(frame: CGRect(x: 130.5, y: 0, width: 60, height: componentHeight))
        //        let minutesLabel: UILabel = UILabel(frame: CGRect(x: 239.5, y: 0, width: 60, height: componentHeight))
        let hoursLabel: UILabel = UILabel(frame: CGRect(x: popoverWidth/2 - 60, y: 0, width: 60, height: popoverPicker.componentHeight))
        let minutesLabel: UILabel = UILabel(frame: CGRect(x: popoverWidth/2 + 50, y: 0, width: 60, height: popoverPicker.componentHeight))
        
        hoursLabel.textAlignment = NSTextAlignment.left
        hoursLabel.font = UIFont(name: "GodoM", size: 17)
        hoursLabel.mixedTextColor = MixedColor(normal: UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0), night: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
        insertRef.addSubview(hoursLabel)
        hoursLabel.text = "시간"
        
        minutesLabel.textAlignment = NSTextAlignment.left
        minutesLabel.font = UIFont(name: "GodoM", size: 17)
        minutesLabel.mixedTextColor = MixedColor(normal: UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0), night: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
        insertRef.addSubview(minutesLabel)
        minutesLabel.text = "분"
        
        // 피커뷰의 선택된 인덱스 상하에 있는 가로줄 색상 적용
        pickerView.subviews[1].mixedBackgroundColor = MixedColor(normal: UIColor(red:0.86, green:0.86, blue:0.88, alpha:1.00), night: UIColor(red:0.14, green:0.14, blue:0.12, alpha:1.00))
        pickerView.subviews[2].mixedBackgroundColor = MixedColor(normal: UIColor(red:0.86, green:0.86, blue:0.88, alpha:1.00), night: UIColor(red:0.14, green:0.14, blue:0.12, alpha:1.00))
        
        var viewWithLabel: UIView?
        
        if viewWithLabel == nil {
            viewWithLabel = UIView(frame: CGRect(x: 0, y: 0, width: popoverPicker.componentWidth, height: popoverPicker.componentHeight))
            
            let label: UILabel = UILabel(frame: CGRect(x: 11, y: 0, width: 30, height: popoverPicker.componentHeight))
            label.font = UIFont(name: "GodoM", size: 17)
            label.mixedTextColor = MixedColor(normal: UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0), night: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
            label.textAlignment = NSTextAlignment.right
            viewWithLabel?.addSubview(label)
        }
        
        if let label: UILabel = viewWithLabel?.subviews[0] as? UILabel {
            
            label.text = String(popoverPicker.valueForRow(row: row))
        }
        
        return viewWithLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return popoverPicker.componentHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return 106
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        popoverPicker.selectedHours = popoverPicker.hoursPickerData[pickerView.selectedRow(inComponent: 0)]
        popoverPicker.selectedMinutes = popoverPicker.minutesPickerData[pickerView.selectedRow(inComponent: 1) % popoverPicker.minutesPickerData.count]
        
        changeButtonValidation()
        
        var estimatedWorkTimeString: String = "\(popoverPicker.selectedHours!)시간 \(popoverPicker.selectedMinutes!)분"
        
        if popoverPicker.selectedHours == 0 {
            estimatedWorkTimeString = "\(popoverPicker.selectedMinutes!)분"
        }
        
        // popover를 닫으면 부모VC로 전달하기 위해 담아둔다.
        estimatedWorkTimeForPopover = Int32((popoverPicker.selectedHours! * 3600) + (popoverPicker.selectedMinutes! * 60))
        
        print(estimatedWorkTimeString)
//        showEstimatedWorkTimeCell.detailTextLabel?.text = estimatedWorkTimeString
    }
}

extension PopoverPickerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case popoverPicker.hourComponent: return popoverPicker.hoursPickerData.count
        case popoverPicker.minuteComponent: return popoverPicker.largeNumber
        default: break
        }
        return 0
    }
}
