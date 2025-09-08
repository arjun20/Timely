//
//  Event.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import Foundation
import EventKit

// MARK: - Event Models
struct Event: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String?
    let startDate: Date
    let endDate: Date
    let location: String?
    let attendees: [Attendee]
    let isConfirmed: Bool
    let createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        startDate: Date,
        endDate: Date,
        location: String? = nil,
        attendees: [Attendee] = [],
        isConfirmed: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.attendees = attendees
        self.isConfirmed = isConfirmed
        self.createdAt = createdAt
    }
}

struct Attendee: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String?
    let availability: [TimeSlot]
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String? = nil,
        availability: [TimeSlot] = []
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.availability = availability
    }
}

struct TimeSlot: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    let endTime: Date
    let isAvailable: Bool
    
    init(
        id: UUID = UUID(),
        startTime: Date,
        endTime: Date,
        isAvailable: Bool = true
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.isAvailable = isAvailable
    }
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
}

// MARK: - Event Category
enum EventCategory: String, CaseIterable, Codable {
    case social = "social"
    case work = "work"
    case fitness = "fitness"
    case entertainment = "entertainment"
    case education = "education"
    case health = "health"
    case food = "food"
    case travel = "travel"
    case other = "other"
    
    var emoji: String {
        switch self {
        case .social:
            return "👥"
        case .work:
            return "💼"
        case .fitness:
            return "💪"
        case .entertainment:
            return "🎬"
        case .education:
            return "📚"
        case .health:
            return "🏥"
        case .food:
            return "🍕"
        case .travel:
            return "✈️"
        case .other:
            return "📅"
        }
    }
}

// MARK: - Airtable Event Card
struct EventCard: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let category: EventCategory
    let estimatedDuration: Int // in minutes
    let suggestedTimes: [String] // e.g., ["morning", "afternoon", "evening"]
    let location: String?
    let emoji: String
    
    init(
        id: String,
        title: String,
        description: String,
        category: EventCategory,
        estimatedDuration: Int,
        suggestedTimes: [String] = [],
        location: String? = nil,
        emoji: String = "📅"
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.estimatedDuration = estimatedDuration
        self.suggestedTimes = suggestedTimes
        self.location = location
        self.emoji = emoji
    }
}
