//
//  File.swift
//  Hourglass
//
//  Created by 김문옥 on 04/11/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit
import AudioToolbox

class SoundEffect {
    
    let timeOverSoundFilename: Array = ["end_sound_1", "end_sound_2", "end_sound_3", "end_sound_4", "end_sound_5"]
    let successSoundFilename: Array = ["success_sound_1", "success_sound_2", "success_sound_3", "success_sound_4", "success_sound_5"]
    let failSoundFilename: Array = ["fail_sound_1", "fail_sound_2", "fail_sound_3", "fail_sound_4"]
    
    // 설정에 표시 될 사운드의 이름
    let alertTimeExplanation: Array = ["예상작업시간 경과 5분 전".localized, "예상작업시간 경과 1분 전".localized, "예상작업시간이 경과할 때".localized]
    let timeOverSoundExplanation: Array = ["없음".localized, "실로폰".localized, "빈 병 소리".localized, "종 소리".localized, "북 소리".localized, "비트음".localized]
    let successSoundExplanation: Array = ["없음".localized, "드럼 소리".localized, "피아노 소리 1".localized, "피아노 소리 2".localized, "신나는 멜로디".localized, "긴 종 소리".localized]
    let failSoundExplanation: Array = ["없음".localized, "낮아지는 음".localized, "비프음".localized, "반복되는 멜로디".localized, "웅장한 음악".localized]
    let ext: String = "wav"
    
    enum Situation: Int {
        
        case timeOver = 0
        case success = 1
        case fail = 2
    }
    
//    enum Vibration {
//
//        case error
//        case success
//        case warning
//        case light
//        case medium
//        case heavy
//        case selection
//        case oldSchool
//
//        func vibrate() {
//
//            switch self {
//            case .error:
//                let generator = UINotificationFeedbackGenerator()
//                generator.notificationOccurred(.error)
//            case .success:
//                let generator = UINotificationFeedbackGenerator()
//                generator.notificationOccurred(.success)
//            case .warning:
//                let generator = UINotificationFeedbackGenerator()
//                generator.notificationOccurred(.warning)
//            case .light:
//                let generator = UIImpactFeedbackGenerator(style: .light)
//                generator.impactOccurred()
//            case .medium:
//                let generator = UIImpactFeedbackGenerator(style: .medium)
//                generator.impactOccurred()
//            case .heavy:
//                let generator = UIImpactFeedbackGenerator(style: .heavy)
//                generator.impactOccurred()
//            case .selection:
//                let generator = UISelectionFeedbackGenerator()
//                generator.selectionChanged()
//            case .oldSchool:
//                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            }
//        }
//    }
    
    func playSound(situation: Situation) {
        
        guard UserDefaults.standard.bool(forKey: "soundSwitchState") else { return }
        
        var filename = ""
        
        // userDefault에 Int로 저장한 설정값을 대입한다.
        switch situation {
        case .timeOver:
            let index = UserDefaults.standard.integer(forKey: "timeOverSoundState")
            guard index >= 0 else { return } // 사용자가 효과음 '없음' 설정했을 경우
            filename = timeOverSoundFilename[index]
        case .success:
            let index = UserDefaults.standard.integer(forKey: "successSoundState")
            guard index >= 0 else { return } // 사용자가 효과음 '없음' 설정했을 경우
            filename = successSoundFilename[index]
        case .fail:
            let index = UserDefaults.standard.integer(forKey: "failSoundState")
            guard index >= 0 else { return } // 사용자가 효과음 '없음' 설정했을 경우
            filename = failSoundFilename[index]
        }
        
        // 경로를 문자열로 설정
        if let soundUrl = Bundle.main.url(forResource: filename, withExtension: ext) {
            
            var soundId: SystemSoundID = 0
            
            // 시스템 사운드 객체를 만듭니다.
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
            
            // 지정된 시스템 사운드 재생이 완료 될 때 호출되는 콜백 함수를 등록합니다.
            AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, clientData) -> Void in
                // 시스템 사운드 객체 ​​및 관련 자원을 삭제합니다.
                AudioServicesDisposeSystemSoundID(soundId)
            }, nil)
            
            // 재생
            AudioServicesPlaySystemSound(soundId)
        }
    }
    
    func vibrate() {
        
        guard UserDefaults.standard.bool(forKey: "vibrationSwitchState") else { return }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
