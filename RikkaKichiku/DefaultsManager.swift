//
//  DefaultsManager.swift
//  RikkaKichiku
//
//  Created by edisonlee55 on 2019/9/22.
//  Copyright © 2018年 Moeoverflow. All rights reserved.
//

import ScreenSaver

class DefaultsManager {
    var defaults: UserDefaults

    init() {
        let identifier = Bundle(for: DefaultsManager.self).bundleIdentifier
        defaults = ScreenSaverDefaults.init(forModuleWithName: identifier!)!
    }

    var videoUrl: String {
        set(newUrl) {
            setAttribute(newUrl, key: "videoUrl")
        }
        get {
            return getVideoUrl() ?? "https://animeloop.org/files/mp4_1080p/598f4b40ed178675bf1ee936.mp4"
        }
    }
    
    func setAttribute(_ attribute: Any, key: String) {
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: attribute), forKey: key)
        defaults.synchronize()
    }

    func getVideoUrl() -> String? {
        if let info = defaults.object(forKey: "videoUrl") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: info) as? String
        }
        return nil
    }
}
