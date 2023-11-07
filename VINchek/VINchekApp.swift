//
//  VINchekApp.swift
//  VINchek
//
//  Created by Aliaksei Schyslionak on 2023. 05. 31..
//

import SwiftUI

@main
struct VINchekApp: App {
    
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
        #if DEBUG
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        #endif
                }

        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}

