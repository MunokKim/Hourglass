//
//  NewWorkViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 8. 31..
//  Copyright © 2018년 김문옥. All rights reserved.
//

import UIKit

class NewWorkViewController: UIViewController {
    
    @IBOutlet var closeButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // navigationBar 색상바꾸는 법.
        // self.toolbarItems?..tintColor = UIColor(red:0.87, green:0.42, blue:0.19, alpha:1.00) // Sorbus
        closeButton.tintColor = UIColor(red:0.87, green:0.42, blue:0.19, alpha:1.00) // Sorbus
        addButton.tintColor = UIColor(red:0.87, green:0.42, blue:0.19, alpha:1.00) // Sorbus
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
