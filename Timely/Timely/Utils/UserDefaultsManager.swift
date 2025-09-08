//
//  UserDefaultsManager.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import Foundation
import SwiftUI

class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let preferredWorkingHours = "preferredWorkingHours"
        static let defaultEventDuration = "defaultEventDuration"
        static let lastSelectedEventCard = "lastSelectedEventCard"
        static let eventHistory = "eventHistory"
        static let userPreferences = "userPreferences"
    }
    
    // MARK: - Onboarding
    var hasCompletedOnboarding: Bool {
        get { userDefaults.bool(forKey: Keys.hasCompletedOnboarding) }
        set { userDefaults.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
    
    // MARK: - User Preferences
    var preferredWorkingHours: WorkingHours {
        get {
            let start = userDefaults.object(forKey: "\(Keys.preferredWorkingHours)_start") as? Int ?? 9
            let end = userDefaults.object(forKey: "\(Keys.preferredWorkingHours)_end") as? Int ?? 18
            return WorkingHours(start: start, end: end)
        }
        set {
            userDefaults.set(newValue.start, forKey: "\(Keys.preferredWorkingHours)_start")
            userDefaults.set(newValue.end, forKey: "\(Keys.preferredWorkingHours)_end")
        }
    }
    
    var defaultEventDuration: Int {
        get { userDefaults.object(forKey: Keys.defaultEventDuration) as? Int ?? 60 }
        set { userDefaults.set(newValue, forKey: Keys.defaultEventDuration) }
    }
    
    var lastSelectedEventCard: String? {
        get { userDefaults.string(forKey: Keys.lastSelectedEventCard) }
        set { userDefaults.set(newValue, forKey: Keys.lastSelectedEventCard) }
    }
    
    // MARK: - Event History
    func saveEventToHistory(_ event: Event) {
        var history = getEventHistory()
        history.append(event)
        
        // Keep only last 50 events
        if history.count > 50 {
            history = Array(history.suffix(50))
        }
        
        if let data = try? JSONEncoder().encode(history) {
            userDefaults.set(data, forKey: Keys.eventHistory)
        }
    }
    
    func getEventHistory() -> [Event] {
        guard let data = userDefaults.data(forKey: Keys.eventHistory),
              let history = try? JSONDecoder().decode([Event].self, from: data) else {
            return []
        }
        return history
    }
    
    // MARK: - User Preferences
    func saveUserPreferences(_ preferences: UserPreferences) {
        if let data = try? JSONEncoder().encode(preferences) {
            userDefaults.set(data, forKey: Keys.userPreferences)
        }
    }
    
    func getUserPreferences() -> UserPreferences {
        guard let data = userDefaults.data(forKey: Keys.userPreferences),
              let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) else {
            return UserPreferences()
        }
        return preferences
    }
    
    // MARK: - Reset
    func resetAllData() {
        let keys = [
            Keys.hasCompletedOnboarding,
            Keys.preferredWorkingHours,
            Keys.defaultEventDuration,
            Keys.lastSelectedEventCard,
            Keys.eventHistory,
            Keys.userPreferences
        ]
        
        for key in keys {
            userDefaults.removeObject(forKey: key)
        }
    }
}

struct WorkingHours: Codable {
    var start: Int
    var end: Int
    
    init(start: Int = 9, end: Int = 18) {
        self.start = start
        self.end = end
    }
}

struct UserPreferences: Codable {
    var enableHapticFeedback: Bool = true
    var enableAnimations: Bool = true
    var preferredTheme: AppTheme = .system
    var workingHours: WorkingHours = WorkingHours()
    var defaultEventDuration: Int = 60
    var showEventHistory: Bool = true
    
    enum AppTheme: String, CaseIterable, Codable {
        case light = "light"
        case dark = "dark"
        case system = "system"
    }
}
