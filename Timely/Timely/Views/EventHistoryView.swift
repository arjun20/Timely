//
//  EventHistoryView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct EventHistoryView: View {
    @EnvironmentObject var viewModel: EventViewModel
    @State private var events: [Event] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            ZStack {
                AppWideBackgroundView(showFloatingParticles: true, particleCount: 8)
                
                if isLoading {
                    VStack {
                        AnimatedLoadingView(message: "Loading your events...")
                    }
                } else if events.isEmpty {
                    EmptyStateView(
                        icon: "📅",
                        title: "No Events Yet",
                        message: "You haven't created any events yet. Start by selecting an event card to find available times!"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(events.sorted(by: { $0.startDate > $1.startDate }), id: \.id) { event in
                                EventHistoryCard(event: event)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("My Events")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadEventHistory()
        }
    }
    
    private func loadEventHistory() {
        Task {
            let history = await UserDefaultsManager.shared.getEventHistory()
            await MainActor.run {
                self.events = history
                self.isLoading = false
            }
        }
    }
}

struct EventHistoryCard: View {
    let event: Event
    @State private var isExpanded = false
    
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
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(dateFormatter.string(from: event.startDate))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Status indicator
                HStack(spacing: 4) {
                    Circle()
                        .fill(event.isConfirmed ? Color.timelyGreen : Color.timelyOrange)
                        .frame(width: 8, height: 8)
                    
                    Text(event.isConfirmed ? "Confirmed" : "Pending")
                        .font(.caption)
                        .foregroundColor(event.isConfirmed ? .timelyGreen : .timelyOrange)
                }
            }
            
            // Time and location
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.timelyBlue)
                        .frame(width: 16)
                    
                    Text("\(timeFormatter.string(from: event.startDate)) - \(timeFormatter.string(from: event.endDate))")
                        .font(.subheadline)
                }
                
                if let location = event.location, !location.isEmpty {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.timelyBlue)
                            .frame(width: 16)
                        
                        Text(location)
                            .font(.subheadline)
                    }
                }
            }
            
            // Attendees (expandable)
            if !event.attendees.isEmpty {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "person.2")
                            .foregroundColor(.timelyBlue)
                            .frame(width: 16)
                        
                        Text("\(event.attendees.count) attendee\(event.attendees.count == 1 ? "" : "s")")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(event.attendees, id: \.email) { attendee in
                            HStack {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.secondary)
                                    .frame(width: 16)
                                
                                Text(attendee.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                if let email = attendee.email {
                                    Text("(\(email))")
                                        .font(.caption)
                                        .foregroundColor(.secondary.opacity(0.7))
                                }
                            }
                        }
                    }
                    .padding(.leading, 20)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            
            // Description
            if let description = event.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.timelyCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
        )
        .timelyCardShadow()
        .scaleEffect(isExpanded ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
    }
}

#Preview {
    EventHistoryView()
        .environmentObject(EventViewModel())
}
