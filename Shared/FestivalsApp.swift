//
//  FestivalsApp.swift
//  Shared
//
//  Created by Tariq Almazyad on 1/13/21.
//

import SwiftUI

@main
struct FestivalsApp: App {
    var body: some Scene {
        WindowGroup {
            RootView{
                MainTabView()
                    .statusBarStyle(.lightContent)
            }
        }
    }
}
