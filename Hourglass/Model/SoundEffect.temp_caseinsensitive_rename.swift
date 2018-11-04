//
//  File.swift
//  Hourglass
//
//  Created by 김문옥 on 04/11/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundEffect {
    
    let timeOverSoundFilename: Array = ["end_sound_1", "end_sound_2", "end_sound_3", "end_sound_4", "end_sound_5"]
    let successSoundFilename: Array = ["success_sound_1", "success_sound_2", "success_sound_3", "success_sound_4"]
    let failSoundFilename: Array = ["fail_sound_1", "fail_sound_2", "fail_sound_3", "fail_sound_4"]
    let ext: String = "wav"
    
    enum Situation: Int {
        case timeOver = 0
        case success = 1
        case fail = 2
    }
    
    func playSound(situation: Situation) {
        
        var filename = ""
        
        // userDefault에 Int로 저장한 설정값을 대입한다.
        if situation == .timeOver {
            let index = UserDefaults.standard.integer(forKey: "timeOverSoundState")
            filename = timeOverSoundFilename[index]
            guard index >= 0 else { return } // 사용자가 효과음 '없음' 설정했을 경우
            
        } else if situation == .success {
            let index = UserDefaults.standard.integer(forKey: "successSoundState")
            filename = successSoundFilename[index]
            guard index >= 0 else { return } // 사용자가 효과음 '없음' 설정했을 경우
            
        }  else if situation == .fail {
            let index = UserDefaults.standard.integer(forKey: "failSoundState")
            filename = failSoundFilename[index]
            guard index >= 0 else { return } // 사용자가 효과음 '없음' 설정했을 경우
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
    
    func vibrate(situation: Situation) {
        
        
    }
}
