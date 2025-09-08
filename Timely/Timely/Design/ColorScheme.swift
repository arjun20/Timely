//
//  ColorScheme.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

extension Color {
    // MARK: - Primary Colors
    static let timelyBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let timelyPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let timelyGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let timelyOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let timelyPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    
    // MARK: - Background Colors
    static let timelyBackground = Color(red: 0.98, green: 0.98, blue: 1.0)
    static let timelyCardBackground = Color(.systemBackground)
    static let timelySecondaryBackground = Color(.secondarySystemBackground)
    
    // MARK: - Text Colors
    static let timelyPrimaryText = Color.primary
    static let timelySecondaryText = Color.secondary
    static let timelyTertiaryText = Color(.tertiaryLabel)
    
    // MARK: - Accent Colors for Categories
    static let socialColor = Color(red: 0.9, green: 0.4, blue: 0.4)
    static let fitnessColor = Color(red: 0.2, green: 0.7, blue: 0.4)
    static let educationColor = Color(red: 0.4, green: 0.4, blue: 0.9)
    static let entertainmentColor = Color(red: 0.8, green: 0.4, blue: 0.8)
    static let diningColor = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    // MARK: - Status Colors
    static let successColor = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningColor = Color(red: 1.0, green: 0.7, blue: 0.2)
    static let errorColor = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let infoColor = Color(red: 0.2, green: 0.6, blue: 1.0)
}

// MARK: - Category Color Mapping
extension Color {
    static func colorForCategory(_ category: EventCategory) -> Color {
        switch category {
        case .social:
            return .socialColor
        case .fitness:
            return .fitnessColor
        case .education:
            return .educationColor
        case .entertainment:
            return .entertainmentColor
        case .food:
            return .diningColor
        case .work:
            return .timelyBlue
        case .health:
            return .timelyGreen
        case .travel:
            return .timelyOrange
        case .other:
            return .timelyPurple
        }
    }
    
    // Legacy support for String-based categories
    static func colorForCategory(_ category: String) -> Color {
        switch category.lowercased() {
        case "social":
            return .socialColor
        case "fitness":
            return .fitnessColor
        case "education":
            return .educationColor
        case "entertainment":
            return .entertainmentColor
        case "dining", "food":
            return .diningColor
        case "work":
            return .timelyBlue
        case "health":
            return .timelyGreen
        case "travel":
            return .timelyOrange
        default:
            return .timelyPurple
        }
    }
}

// MARK: - Gradient Definitions
extension LinearGradient {
    static let timelyPrimary = LinearGradient(
        gradient: Gradient(colors: [.timelyBlue, .timelyPurple]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let timelySecondary = LinearGradient(
        gradient: Gradient(colors: [.timelyGreen, .timelyBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let timelyBackground = LinearGradient(
        gradient: Gradient(colors: [
            Color.timelyBackground,
            Color.timelyBackground.opacity(0.8)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}
