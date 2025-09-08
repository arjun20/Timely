//
//  CreateEventCardView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct CreateEventCardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var eventTitle = ""
    @State private var eventDescription = ""
    @State private var selectedCategory: EventCategory = .social
    @State private var estimatedDuration = 60
    @State private var location = ""
    @State private var selectedEmoji = "☕️"
    
    let onEventCardCreated: (EventCard) -> Void
    
    private let emojis = ["☕️", "🏃‍♂️", "💪", "🧘‍♀️", "🎮", "🍕", "🎬", "📚", "🎨", "🎵", "🚶‍♂️", "🏊‍♀️", "⚽️", "🏀", "🎯", "🎪", "🍳", "🌮", "🍜", "🍰"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppWideBackgroundView(showFloatingParticles: true, particleCount: 6)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Create Custom Event")
                                .timelyStyle(.largeTitle)
                            
                            Text("Add your own event card to the collection")
                                .timelyStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Event Details Card
                        VStack(spacing: 20) {
                            // Event Title
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Event Title")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("*")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                }
                                
                                TextField("e.g., Coffee Chat, Morning Run", text: $eventTitle)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.body)
                                    .submitLabel(.next)
                                
                                if eventTitle.isEmpty {
                                    Text("Event title is required")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            // Event Description
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description (Optional)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("What's this event about?", text: $eventDescription, axis: .vertical)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.body)
                                    .lineLimit(3...6)
                                    .submitLabel(.done)
                            }
                            
                            // Category Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Category")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ForEach(EventCategory.allCases, id: \.self) { category in
                                        CategoryOptionView(
                                            category: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            HapticFeedback.shared.selection()
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                            
                            // Duration
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Duration")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Picker("Duration", selection: $estimatedDuration) {
                                    Text("30 min").tag(30)
                                    Text("1 hour").tag(60)
                                    Text("1.5 hours").tag(90)
                                    Text("2 hours").tag(120)
                                    Text("3 hours").tag(180)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            // Location
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Location (Optional)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("e.g., Central Park, Coffee Shop", text: $location)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.body)
                                    .submitLabel(.done)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.timelyCardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .timelyCardShadow()
                        .padding(.horizontal)
                        
                        // Emoji Selection
                        VStack(spacing: 16) {
                            Text("Choose an Emoji")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                                ForEach(emojis, id: \.self) { emoji in
                                    EmojiOptionView(
                                        emoji: emoji,
                                        isSelected: selectedEmoji == emoji
                                    ) {
                                        HapticFeedback.shared.selection()
                                        selectedEmoji = emoji
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Preview Card
                        VStack(spacing: 16) {
                            HStack {
                                Text("Preview")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text("This is how your event card will look")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            EventCardView(
                                eventCard: EventCard(
                                    id: UUID().uuidString,
                                    title: eventTitle.isEmpty ? "Your Event" : eventTitle,
                                    description: eventDescription.isEmpty ? "Event description" : eventDescription,
                                    category: selectedCategory,
                                    estimatedDuration: estimatedDuration,
                                    location: location.isEmpty ? nil : location,
                                    emoji: selectedEmoji
                                ),
                                isSelected: false
                            ) {
                                // Preview only
                            }
                            .opacity(eventTitle.isEmpty ? 0.6 : 1.0)
                        }
                        .padding(.horizontal)
                        
                        // Create Event Card Button
                        VStack(spacing: 8) {
                            Button(action: createEventCard) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Create Event Card")
                                }
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(canCreateEventCard ? Color.timelyBlue : Color.gray)
                                )
                                .timelyButtonShadow()
                            }
                            .disabled(!canCreateEventCard)
                            
                            if !canCreateEventCard {
                                Text("Please enter an event title to continue")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("New Event Card")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.timelyBlue)
                }
            }
            .onTapGesture {
                // Dismiss keyboard when tapping outside text fields
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    private var canCreateEventCard: Bool {
        !eventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func createEventCard() {
        let newEventCard = EventCard(
            id: UUID().uuidString,
            title: eventTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            description: eventDescription.isEmpty ? "" : eventDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            estimatedDuration: estimatedDuration,
            location: location.isEmpty ? nil : location.trimmingCharacters(in: .whitespacesAndNewlines),
            emoji: selectedEmoji
        )
        
        HapticFeedback.shared.success()
        onEventCardCreated(newEventCard)
        dismiss()
    }
}

struct CategoryOptionView: View {
    let category: EventCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(category.emoji)
                    .font(.title2)
                
                Text(category.rawValue.capitalized)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.timelyBlue : Color.secondary.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct EmojiOptionView: View {
    let emoji: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(emoji)
                .font(.title)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(isSelected ? Color.timelyBlue.opacity(0.2) : Color.clear)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Color.timelyBlue : Color.clear, lineWidth: 2)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    CreateEventCardView { _ in }
}
