//
//  WorkTimePicker.swift
//  Hourglass
//
//  Created by 김문옥 on 31/10/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import NightNight

class WorkTimePicker: UIPickerView {
    
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
    
    
}

//extension WorkTimePicker: UIPickerViewDelegate {
//    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        
//        // "시간", "분" 레이블 삽입
//        let screenWidth = UIScreen.main.bounds.width
//        let insertRef = pickerView.subviews[0].subviews[0].subviews[2]
//        //        let hoursLabel: UILabel = UILabel(frame: CGRect(x: 130.5, y: 0, width: 60, height: componentHeight))
//        //        let minutesLabel: UILabel = UILabel(frame: CGRect(x: 239.5, y: 0, width: 60, height: componentHeight))
//        let hoursLabel: UILabel = UILabel(frame: CGRect(x: screenWidth/2 - 60, y: 0, width: 60, height: componentHeight))
//        let minutesLabel: UILabel = UILabel(frame: CGRect(x: screenWidth/2 + 50, y: 0, width: 60, height: componentHeight))
//        
//        hoursLabel.textAlignment = NSTextAlignment.left
//        hoursLabel.font = UIFont(name: "GodoM", size: 17)
//        hoursLabel.mixedTextColor = MixedColor(normal: UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0), night: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
//        insertRef.addSubview(hoursLabel)
//        hoursLabel.text = "시간"
//        
//        minutesLabel.textAlignment = NSTextAlignment.left
//        minutesLabel.font = UIFont(name: "GodoM", size: 17)
//        minutesLabel.mixedTextColor = MixedColor(normal: UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0), night: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
//        insertRef.addSubview(minutesLabel)
//        minutesLabel.text = "분"
//        
//        // 피커뷰의 선택된 인덱스 상하에 있는 가로줄 색상 적용
//        pickerView.subviews[1].mixedBackgroundColor = MixedColor(normal: UIColor(red:0.86, green:0.86, blue:0.88, alpha:1.00), night: UIColor(red:0.14, green:0.14, blue:0.12, alpha:1.00))
//        pickerView.subviews[2].mixedBackgroundColor = MixedColor(normal: UIColor(red:0.86, green:0.86, blue:0.88, alpha:1.00), night: UIColor(red:0.14, green:0.14, blue:0.12, alpha:1.00))
//        
//        var viewWithLabel: UIView?
//        
//        if viewWithLabel == nil {
//            viewWithLabel = UIView(frame: CGRect(x: 0, y: 0, width: componentWidth, height: componentHeight))
//            
//            let label: UILabel = UILabel(frame: CGRect(x: 11, y: 0, width: 30, height: componentHeight))
//            label.font = UIFont(name: "GodoM", size: 17)
//            label.mixedTextColor = MixedColor(normal: UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0), night: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0))
//            label.textAlignment = NSTextAlignment.right
//            viewWithLabel?.addSubview(label)
//        }
//        
//        if let label: UILabel = viewWithLabel?.subviews[0] as? UILabel {
//            
//            label.text = String(valueForRow(row: row))
//        }
//        
//        return viewWithLabel!
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        
//        return componentHeight
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        
//        return 106
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//        selectedHours = hoursPickerData[pickerView.selectedRow(inComponent: 0)]
//        selectedMinutes = minutesPickerData[pickerView.selectedRow(inComponent: 1) % minutesPickerData.count]
//    }
//}
//
//extension WorkTimePicker: UIPickerViewDataSource {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        
//        return 2
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        
//        switch component {
//        case hourComponent: return hoursPickerData.count
//        case minuteComponent: return largeNumber
//        default: break
//        }
//        return 0
//    }
//}
