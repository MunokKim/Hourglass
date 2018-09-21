//
//  NewWorkViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit
import CoreData

class NewWorkViewController: UIViewController {
    
    let context = AppDelegate.viewContext
    
    @IBAction func saveWorkInfo(_ sender: Any) {
        
        // Core Data 영구 저장소에 WorkInfo 데이터 추가하기
        let workInfo = WorkInfo(context: context)
        
        workInfo.workName = workNameTextField?.text
        
        if let countDownDurationToInt32 = estimatedWorkTimeDatePicker?.countDownDuration {
            workInfo.estimatedWorkTime = Int32(countDownDurationToInt32)
        }
        
        do {
            try context.save()
            
            print("Context Save Success!")
            
        } catch let nserror as NSError {
            
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAndClose(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet var workNameTextField: UITextField!
    @IBOutlet var workIconImageView: UIImageView!
    @IBOutlet var estimatedWorkTimeDatePicker: UIDatePicker!
    
    
    @IBOutlet var textTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageHeightConstrint: NSLayoutConstraint!
    @IBOutlet var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet var pickerHeightConstrint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIDevice.current.isiPadPro12 {
            // iPad Pro 12.9
            
        } else if UIDevice.current.isiPad {
            // iPad Air2, iPad Pro 9.7
            
        } else if UIDevice.current.isiPhonePlus {
            // iPhone 7+
            textTopConstraint.constant = 50
            imageTopConstraint.constant = 50
            imageHeightConstrint.constant = 150
            labelTopConstraint.constant = 80
            pickerHeightConstrint.constant = 250
            
        } else if UIDevice.current.isiPhoneX {
            // iPhone X
            textTopConstraint.constant = 60
            imageTopConstraint.constant = 60
            labelTopConstraint.constant = 140
            pickerHeightConstrint.constant = 250
            
        } else if UIDevice.current.isiPhoneSE {
            // iPhone SE
            textTopConstraint.constant = 30
            imageTopConstraint.constant = 30
            imageHeightConstrint.constant = 100
            labelTopConstraint.constant = 50
            pickerHeightConstrint.constant = 200
            
        } else {
            // iPhone 7
        }
        
        // navigationBar 색상바꾸는 법.
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        
        workNameTextField.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        workIconImageView.backgroundColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.00)
        
        estimatedWorkTimeDatePicker.tintColor = UIColor(red:0.98, green:0.62, blue:0.28, alpha:1.00) // Sunshade
        estimatedWorkTimeDatePicker.countDownDuration = 1800
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 빈곳을 터치하면 키보드나 데이트피커 등을 숨긴다
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
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
