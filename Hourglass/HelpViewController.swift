//
//  HelpViewController.swift
//  Hourglass
//
//  Created by 김문옥 on 15/12/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import NightNight

class HelpViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 테마 적용
        view.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backViewColor.rawValue, night: AppsConstants.night.backViewColor.rawValue)
        textView.mixedBackgroundColor = MixedColor(normal: AppsConstants.normal.backGroundColor.rawValue, night: AppsConstants.night.backGroundColor.rawValue)
        textView.mixedTextColor = MixedColor(normal: AppsConstants.normal.textColor.rawValue, night: AppsConstants.night.textColor.rawValue)
        
        textView.font = UIFont(name: "GodoM", size: 14)
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        
        if textView.tag == 1 { // Help
//            textView.text = """
//            ❓예상 작업 시간이 무엇인가요
//
//            운동이나 산책, 설거지, 빨래, 청소 등등 모든 종류의 작업을 진행하는데 필요할 것으로 예상되는 기간을 말합니다.
//
//            이 앱을 사용하여 작업에 소요될 시간을 직접 예상하여 시간추정 능력을 기를 수 있습니다.
//
//            1분단위로 선택이 가능하며 최대 9시간 59분까지 기간을 정할 수 있습니다.
//
//
//
//            ❓시간추정이 무엇인가요
//
//            작업에 소요될 시간을 직접 예상해보고 실제 경과한 시간과 비교하는 시간 관리 방법입니다.
//
//
//
//            ❓새로운 작업을 만드는 방법은 무엇인가요
//
//            메인화면의 오른쪽 상단의 ‘+’ 버튼을 누릅니다.
//
//            작업의 제목을 입력합니다.
//
//            모래시계 모양의 아이콘을 눌러서 다른 수많은 아이콘 중에 원하는 하나를 선택합니다.
//
//            시간과 분에 해당하는 선택기를 원하는대로 맞추어서 예상 작업 시간을 설정합니다.
//
//            ‘완료’ 버튼을 누릅니다.
//
//
//
//            ❓작업을 시작하면 어떻게 작업이 진행되나요
//
//            작업을 시작하면 미리 설정해놓은 예상 작업 시간 만큼의 스톱워치가 시작됩니다.
//
//            예상한 시간보다 더 빠르게 작업을 완수할 수 있도록 노력하세요!
//
//            작업을 진행하다가 잠시 중단해야 할 경우, ‘중단’ 버튼을 누르면
//
//            * 남은 시간이 멈추고 완료 예상이 늘어나기 시작합니다.
//            * ‘중단’ 버튼은 ’재개' 버튼으로 바뀝니다.
//            * ‘취소’, ‘완료’ 버튼이 좌우에 나타나게 되어 원하는대로 선택할 수 있습니다.
//
//            작업을 다시 진행할 준비가 되었을 때 ‘재개’ 버튼을 누르면
//
//            * 다시 남은 시간이 줄어들기 시작하고 완료 예상은 멈춥니다.
//            * ‘재개’ 버튼은 ‘중단’ 버튼으로 바뀝니다.
//
//            작업을 다 마치고 난 후에 ‘완료’ 버튼을 누르면
//
//            * 작업을 진행한 기록이 저장되고 작업을 종료하게 되며 진행한 작업의 결과를 화면을 통해 확인할 수 있습니다.
//            """.localized
            textView.text = "helpText".localized
            
        } else if textView.tag == 2 { // License and...
            textView.text = """
            MarqueeLabel The MIT License (MIT) Copyright (c) 2011-2017 Charles Powell
            (https://github.com/cbpowell/MarqueeLabel)
            
            Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
            documentation files (the "Software"), to deal in the Software without restriction, including without limitation
            the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
            to permit persons to whom the Software is furnished to do so, subject to the following conditions:
            
            The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
            
            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
            TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
            THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
            CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
            IN THE SOFTWARE.   ====================  SwiftIcons The MIT License (MIT)
            Copyright © 2017 Saurabh Rane
            (https://github.com/ranesr/SwiftIcons)
            
            Permission is hereby granted, free of charge, to any person obtaining a copy
            of this software and associated documentation files (the "Software"), to deal
            in the Software without restriction, including without limitation the rights
            to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
            copies of the Software, and to permit persons to whom the Software is
            furnished to do so, subject to the following conditions:
            
            The above copyright notice and this permission notice shall be included in all
            copies or substantial portions of the Software.
            
            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
            IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
            FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
            AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
            LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
            OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
            SOFTWARE.
            
             
            ====================
             
            NightNight
            The MIT License (MIT) 
            Copyright (c) 2016 Draveness <stark.draven@gmail.com>
            (https://github.com/Draveness/NightNight)
            
            Permission is hereby granted, free of charge, to any person obtaining a copy
            of this software and associated documentation files (the "Software"), to deal
            in the Software without restriction, including without limitation the rights
            to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
            copies of the Software, and to permit persons to whom the Software is
            furnished to do so, subject to the following conditions:
            
            The above copyright notice and this permission notice shall be included in
            all copies or substantial portions of the Software.
            
            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
            IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
            FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
            AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
            LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
            OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
            THE SOFTWARE.
            
            
            ====================
            
            Godo Font 
            Copyright © 2012 GodoSoft & YoonDesign Inc. All rights reserved. 
            (https://www.godo.co.kr/)
            
            
            ====================
            
            Sound Files
            Freesound (https://freesound.org/) 
            CC BY 3.0 (https://creativecommons.org/licenses/by/3.0/) 
            CC BY-ND 3.0 (https://creativecommons.org/licenses/by-nd/3.0/) 
            
             
            ==================== 
            Icon Files 
            Icofont (https://icofont.com/license) 
            CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/)
            """
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
