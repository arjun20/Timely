//
//  AirtableService.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import Foundation

class AirtableService {
    private let baseURL = "https://api.airtable.com/v0"
    private let baseID = "YOUR_BASE_ID" // Replace with your Airtable base ID
    private let apiKey = "YOUR_API_KEY" // Replace with your Airtable API key
    private let tableName = "EventCards"
    
    func fetchEventCards() async throws -> [EventCard] {
        // For now, return mock data. Replace with actual Airtable API call
        // Uncomment the line below when ready to use real Airtable API
        // return try await makeAPICall()
        return mockEventCards()
    }
    
    private func mockEventCards() -> [EventCard] {
        return [
            EventCard(
                id: "1",
                title: "Coffee Chat",
                description: "Casual catch-up over coffee",
                category: .social,
                estimatedDuration: 60,
                suggestedTimes: ["morning", "afternoon"],
                location: "Local Coffee Shop",
                emoji: "☕️"
            ),
            EventCard(
                id: "2",
                title: "Workout Session",
                description: "Group fitness or gym session",
                category: .fitness,
                estimatedDuration: 90,
                suggestedTimes: ["morning", "evening"],
                location: "Gym or Park",
                emoji: "💪"
            ),
            EventCard(
                id: "3",
                title: "Study Group",
                description: "Collaborative learning session",
                category: .education,
                estimatedDuration: 120,
                suggestedTimes: ["afternoon", "evening"],
                location: "Library or Home",
                emoji: "📚"
            ),
            EventCard(
                id: "4",
                title: "Game Night",
                description: "Board games and fun activities",
                category: .entertainment,
                estimatedDuration: 180,
                suggestedTimes: ["evening"],
                location: "Home",
                emoji: "🎲"
            ),
            EventCard(
                id: "5",
                title: "Dinner Out",
                description: "Restaurant meal with friends",
                category: .food,
                estimatedDuration: 120,
                suggestedTimes: ["evening"],
                location: "Restaurant",
                emoji: "🍽️"
            ),
            EventCard(
                id: "6",
                title: "Team Meeting",
                description: "Work collaboration and planning",
                category: .work,
                estimatedDuration: 60,
                suggestedTimes: ["morning", "afternoon"],
                location: "Office or Virtual",
                emoji: "💼"
            ),
            EventCard(
                id: "7",
                title: "Doctor Visit",
                description: "Health checkup or consultation",
                category: .health,
                estimatedDuration: 45,
                suggestedTimes: ["morning", "afternoon"],
                location: "Medical Center",
                emoji: "🏥"
            ),
            EventCard(
                id: "8",
                title: "Weekend Trip",
                description: "Short getaway or travel adventure",
                category: .travel,
                estimatedDuration: 480, // 8 hours
                suggestedTimes: ["morning"],
                location: "Various",
                emoji: "✈️"
            )
        ]
    }
    
    // TODO: Implement actual Airtable API integration
    private func makeAPICall() async throws -> [EventCard] {
        guard let url = URL(string: "\(baseURL)/\(baseID)/\(tableName)") else {
            throw AirtableError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AirtableResponse.self, from: data)
        
        return response.records.compactMap { record in
            convertToEventCard(from: record)
        }
    }
    
    // MARK: - Helper Functions
    private func convertToEventCard(from record: AirtableRecord) -> EventCard? {
        // Convert string category to EventCategory enum
        let category = parseCategory(from: record.fields.category)
        
        return EventCard(
            id: record.id,
            title: record.fields.title,
            description: record.fields.description,
            category: category,
            estimatedDuration: record.fields.estimatedDuration,
            suggestedTimes: record.fields.suggestedTimes,
            location: record.fields.location,
            emoji: record.fields.emoji
        )
    }
    
    private func parseCategory(from categoryString: String) -> EventCategory {
        let normalizedCategory = categoryString.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle common variations and aliases
        switch normalizedCategory {
        case "social", "socializing", "hangout":
            return .social
        case "work", "business", "meeting", "professional":
            return .work
        case "fitness", "exercise", "workout", "gym", "sports":
            return .fitness
        case "entertainment", "fun", "games", "gaming":
            return .entertainment
        case "education", "learning", "study", "academic":
            return .education
        case "health", "medical", "wellness", "doctor":
            return .health
        case "food", "dining", "restaurant", "meal", "eating":
            return .food
        case "travel", "trip", "vacation", "adventure":
            return .travel
        default:
            // Try to match with exact enum case
            if let category = EventCategory(rawValue: normalizedCategory) {
                return category
            }
            
            print("Warning: Unknown category '\(categoryString)', using 'other'")
            return .other
        }
    }
}

// MARK: - Airtable API Models
struct AirtableResponse: Codable {
    let records: [AirtableRecord]
}

struct AirtableRecord: Codable {
    let id: String
    let fields: AirtableFields
}

struct AirtableFields: Codable {
    let title: String
    let description: String
    let category: String
    let estimatedDuration: Int
    let suggestedTimes: [String]
    let location: String?
    let emoji: String
}

enum AirtableError: Error {
    case invalidURL
    case noData
    case decodingError
}
