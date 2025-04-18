//
//  OSLog+Logs.swift
//  Iron
//
//  Created by Karim Abou Zeid on 05.03.20.
//  Copyright © 2020 Karim Abou Zeid Software. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.shalomfriss.Iron.nobundle"
    
    static let migration = OSLog(subsystem: subsystem, category: "Migration")
    static let backup = OSLog(subsystem: subsystem, category: "Backup")
    static let ubiquityContainer = OSLog(subsystem: subsystem, category: "Ubiquity Container")
    static let health = OSLog(subsystem: subsystem, category: "Health")
    static let watch = OSLog(subsystem: subsystem, category: "Watch")
    static let intents = OSLog(subsystem: subsystem, category: "Intents")
    static let siri = OSLog(subsystem: subsystem, category: "Siri")
    static let widgets = OSLog(subsystem: subsystem, category: "Widgets")
    static let workoutData = OSLog(subsystem: subsystem, category: "Workout Data")
}
