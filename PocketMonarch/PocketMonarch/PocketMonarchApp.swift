//
//  PocketMonarchApp.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/18/25.
//

import SwiftUI

@main
struct PocketMonarchApp: App {
    init() {
        NotificationManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
