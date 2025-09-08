//
//  TimelyApp.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

@main
struct TimelyApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showSplashScreen = true

    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashScreenView {
                    print("Splash screen completed")
                    showSplashScreen = false
                }
            } else if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView()
                    .onAppear {
                        print("Onboarding view appeared")
                        // Mark onboarding as completed after a brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            hasCompletedOnboarding = true
                        }
                    }
            }
        }
    }
}
