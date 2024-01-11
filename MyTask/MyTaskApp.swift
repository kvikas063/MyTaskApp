//
//  MyTaskApp.swift
//  MyTask
//
//  Created by Vikas Kumar on 16/07/23.
//

import SwiftUI

@main
struct MyTaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
           HomeView()
        }
    }
}
