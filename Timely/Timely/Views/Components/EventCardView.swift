//
//  EventCardView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct EventCardView: View {
    let eventCard: EventCard
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(eventCard.emoji)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(eventCard.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(eventCard.category.rawValue.capitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color.secondary.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.colorForCategory(eventCard.category))
                            .font(.title3)
                    }
                }
                
                Text(eventCard.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label("\(eventCard.estimatedDuration) min", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let location = eventCard.location {
                        Label(location, systemImage: "location")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.colorForCategory(eventCard.category).opacity(0.1) : Color.timelyCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.colorForCategory(eventCard.category) : Color.secondary.opacity(0.2),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .timelyCardShadow()
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibleEventCard(
            title: eventCard.title,
            category: eventCard.category.rawValue,
            duration: eventCard.estimatedDuration,
            location: eventCard.location
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        EventCardView(
            eventCard: EventCard(
                id: "1",
                title: "Coffee Chat",
                description: "Casual catch-up over coffee",
                category: .social,
                estimatedDuration: 60,
                suggestedTimes: ["morning", "afternoon"],
                location: "Local Coffee Shop",
                emoji: "☕️"
            ),
            isSelected: false,
            onTap: {}
        )
        
        EventCardView(
            eventCard: EventCard(
                id: "2",
                title: "Workout Session",
                description: "Group fitness or gym session",
                category: .fitness,
                estimatedDuration: 90,
                suggestedTimes: ["morning", "evening"],
                location: "Gym or Park",
                emoji: "💪"
            ),
            isSelected: true,
            onTap: {}
        )
    }
    .padding()
}
