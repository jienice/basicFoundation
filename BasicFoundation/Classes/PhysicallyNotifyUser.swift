//
//  PhysicallyNotifyUser.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import DeviceKit
import AudioToolbox

public protocol PhysicallyNotifyUser {

    func physicallyNotifyUserReceiveNewMessage()
}

public extension PhysicallyNotifyUser {

    func physicallyNotifyUserReceiveNewMessage() {
        guard !Device.current.isSimulator else { return }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        // https://github.com/klaas/SwiftySystemSounds
        var soundID: SystemSoundID = 0
        let path = "file:///System/Library/Audio/UISounds/nano/Stockholm_Haptic.caf"
        let url = URL(string: path)!
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
}
