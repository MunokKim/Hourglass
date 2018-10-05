//
//  RepeatingTimer.swift
//  Hourglass
//
//  Created by 김문옥 on 05/10/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import Foundation

class RepeatingTimer {
    
    let timeInterval: TimeInterval
    let estimatedWorkTime: TimeInterval
    
    init(timeInterval: TimeInterval, estimatedWorkTime: Int32) {
        self.timeInterval = timeInterval
        self.estimatedWorkTime = TimeInterval(estimatedWorkTime)
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let queue = DispatchQueue(label: "com.domain.app.timer", qos: .userInteractive)
        let t = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        t.schedule(deadline: .now() + estimatedWorkTime, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    var eventHandler: (() -> Void)?
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here
         https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}

