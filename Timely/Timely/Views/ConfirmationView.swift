//
//  ConfirmationView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var viewModel: EventViewModel
    @State private var attendees: [String] = []
    @State private var newAttendee = ""
    @State private var isCreatingEvent = false
    @State private var eventCreated = false
    
    private var selectedEventCard: EventCard? {
        viewModel.selectedEventCard
    }
    
    private var selectedTimeSlot: TimeSlot? {
        viewModel.selectedTimeSlot
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if eventCreated {
                        // Success State
                        VStack(spacing: 24) {
                            EmptyStateView(
                                icon: "🎉",
                                title: "Event Created!",
                                message: "Your event has been added to everyone's calendar. Check your calendar app to see the details."
                            )
                            
                            // Action Buttons
                            VStack(spacing: 16) {
                                Button(action: goHome) {
                                    HStack {
                                        Image(systemName: "house.fill")
                                        Text("Go Home")
                                    }
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.timelyBlue)
                                    )
                                    .timelyButtonShadow()
                                }
                                
                                Button(action: createAnotherEvent) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Create Another Event")
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.timelyBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.timelyBlue, lineWidth: 2)
                                    )
                                }
                            }
                            .padding(.horizontal, 32)
                        }
                    } else {
                        // Event Summary
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Confirm Your Event")
                                .timelyStyle(.largeTitle)
                            
                            if let eventCard = selectedEventCard,
                               let timeSlot = selectedTimeSlot {
                                
                                EventSummaryCard(
                                    eventCard: eventCard,
                                    timeSlot: timeSlot
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Attendees Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Who's joining?")
                                .timelyStyle(.headline)
                                .padding(.horizontal)
                            
                            // Add Attendee
                            HStack {
                                TextField("Enter email address", text: $newAttendee)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                
                                Button(action: addAttendee) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                .disabled(newAttendee.isEmpty)
                            }
                            .padding(.horizontal)
                            
                            // Attendees List
                            if !attendees.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(attendees, id: \.self) { attendee in
                                        HStack {
                                            Image(systemName: "person.circle.fill")
                                                .foregroundColor(.blue)
                                            
                                            Text(attendee)
                                                .font(.subheadline)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                removeAttendee(attendee)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        
                        // Create Event Button
                        Button(action: createEvent) {
                            HStack {
                                if isCreatingEvent {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.headline)
                                }
                                
                                Text(isCreatingEvent ? "Creating Event..." : "Create Event")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isCreatingEvent ? Color.gray : Color.timelyBlue)
                                )
                                .timelyButtonShadow()
                        }
                        .disabled(isCreatingEvent || attendees.isEmpty)
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationTitle("Confirm")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addAttendee() {
        guard !newAttendee.isEmpty else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            attendees.append(newAttendee)
            newAttendee = ""
        }
    }
    
    private func removeAttendee(_ attendee: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            attendees.removeAll { $0 == attendee }
        }
    }
    
    private func createEvent() {
        guard let eventCard = selectedEventCard,
              let timeSlot = selectedTimeSlot else { return }
        
        isCreatingEvent = true
        
        Task {
            let attendeeObjects = attendees.map { email in
                Attendee(name: email, email: email)
            }
            
            await viewModel.createEvent(
                title: eventCard.title,
                startDate: timeSlot.startTime,
                endDate: timeSlot.endTime,
                attendees: attendeeObjects
            )
            
            await MainActor.run {
                isCreatingEvent = false
                eventCreated = true
                HapticFeedback.shared.success()
            }
        }
    }
    
    private func goHome() {
        HapticFeedback.shared.selection()
        // Reset the view model state to go back to the beginning
        viewModel.resetToHome()
        eventCreated = false
        attendees = []
        newAttendee = ""
    }
    
    private func createAnotherEvent() {
        HapticFeedback.shared.selection()
        // Reset to create another event
        viewModel.resetToHome()
        eventCreated = false
        attendees = []
        newAttendee = ""
    }
}

struct EventSummaryCard: View {
    let eventCard: EventCard
    let timeSlot: TimeSlot
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(eventCard.emoji)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(eventCard.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
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
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Text(dateFormatter.string(from: timeSlot.startTime))
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text("\(timeFormatter.string(from: timeSlot.startTime)) - \(timeFormatter.string(from: timeSlot.endTime))")
                        .font(.subheadline)
                }
                
                if let location = eventCard.location {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.blue)
                        Text(location)
                            .font(.subheadline)
                    }
                }
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
    }
}

#Preview {
    ConfirmationView()
        .environmentObject(EventViewModel())
}
