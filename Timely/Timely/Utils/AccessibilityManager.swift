//
//  AccessibilityManager.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct AccessibilityManager {
    static func addAccessibilityLabels() {
        // This will be used to add accessibility labels to views
    }
}

extension View {
    // MARK: - Accessibility Helpers
    
    func accessibleButton(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
    }
    
    func accessibleCard(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
    }
    
    func accessibleTimeSlot(startTime: Date, endTime: Date, isAvailable: Bool) -> some View {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        let startTimeString = formatter.string(from: startTime)
        let endTimeString = formatter.string(from: endTime)
        let availability = isAvailable ? "Available" : "Not available"
        
        return self
            .accessibilityLabel("Time slot from \(startTimeString) to \(endTimeString), \(availability)")
            .accessibilityAddTraits(isAvailable ? .isButton : [])
    }
    
    func accessibleEventCard(title: String, category: String, duration: Int, location: String?) -> some View {
        let locationText = location != nil ? " at \(location!)" : ""
        let label = "\(title), \(category) activity, \(duration) minutes\(locationText)"
        
        return self
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isButton)
    }
    
    func accessibleProgressIndicator(currentStep: Int, totalSteps: Int) -> some View {
        self
            .accessibilityLabel("Progress indicator")
            .accessibilityValue("Step \(currentStep) of \(totalSteps)")
    }
    
    func accessibleLoadingState(message: String) -> some View {
        self
            .accessibilityLabel("Loading")
            .accessibilityValue(message)
    }
    
    func accessibleEmptyState(title: String, message: String) -> some View {
        self
            .accessibilityLabel(title)
            .accessibilityValue(message)
    }
    
    // MARK: - VoiceOver Support
    func voiceOverFriendly() -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityAction(named: "Activate") {
                // Handle activation
            }
    }
}

// MARK: - Accessibility Constants
struct AccessibilityConstants {
    static let minimumTouchTarget: CGFloat = 44
    static let minimumContrastRatio: CGFloat = 4.5
    static let minimumFontSize: CGFloat = 16
}

// MARK: - Accessibility Testing
struct AccessibilityTestView: View {
    var body: some View {
        VStack {
            Text("Accessibility Test")
                .font(.title)
                .accessibilityAddTraits(.isHeader)
            
            Button("Test Button") {
                // Test action
            }
            .accessibleButton(label: "Test Button", hint: "Tap to test button functionality")
            
            Text("This is a test message")
                .accessibilityLabel("Test message")
        }
    }
}
