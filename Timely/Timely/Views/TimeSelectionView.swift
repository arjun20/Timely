//
//  TimeSelectionView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct TimeSelectionView: View {
    @EnvironmentObject var viewModel: EventViewModel
    @State private var selectedDate = Date()
    @State private var dateRange = DateInterval(
        start: Date(),
        duration: 7 * 24 * 60 * 60 // 7 days
    )
    @State private var showingCustomTimePicker = false
    let onContinue: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        if let eventCard = viewModel.selectedEventCard {
                            HStack {
                                Text(eventCard.emoji)
                                    .font(.title)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(eventCard.title)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    
                                    Text("\(eventCard.estimatedDuration) minutes")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        Text("When works best for everyone?")
                            .timelyStyle(.headline)
                    }
                    .padding(.horizontal)
                    
                    // Date Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Date")
                            .timelyStyle(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(getAvailableDates(), id: \.self) { date in
                                    DateButton(
                                        date: date,
                                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                        onTap: {
                                            HapticFeedback.shared.selection()
                                            selectedDate = date
                                            updateDateRange()
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Time Slots
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Available Times")
                                .timelyStyle(.headline)
                            
                            Spacer()
                            
                            if viewModel.isLoading {
                                DotsLoadingView()
                            }
                        }
                        .padding(.horizontal)
                        
                        if viewModel.availableTimeSlots.isEmpty && !viewModel.isLoading {
                            VStack(spacing: 20) {
                                EmptyStateView(
                                    icon: "⏰",
                                    title: "No Available Times",
                                    message: "We couldn't find any free time slots for the selected date. Try a different day or expand your search range."
                                )
                                
                                // Action buttons for no available times
                                VStack(spacing: 12) {
                                    Button(action: {
                                        selectedDate = calendar.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
                                        updateDateRange()
                                    }) {
                                        HStack {
                                            Image(systemName: "calendar.badge.plus")
                                            Text("Try Tomorrow")
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.timelyBlue)
                                        )
                                        .timelyButtonShadow()
                                    }
                                    
                                    Button(action: {
                                        selectedDate = calendar.date(byAdding: .day, value: 7, to: selectedDate) ?? Date()
                                        updateDateRange()
                                    }) {
                                        HStack {
                                            Image(systemName: "calendar")
                                            Text("Try Next Week")
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.timelyPurple)
                                        )
                                        .timelyButtonShadow()
                                    }
                                    
                                    Button(action: {
                                        // Expand search to multiple days
                                        let startDate = calendar.startOfDay(for: selectedDate)
                                        let endDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
                                        dateRange = DateInterval(start: startDate, end: endDate)
                                        
                                        Task {
                                            await viewModel.loadCalendarEvents(for: dateRange)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "calendar.badge.clock")
                                            Text("Search Next 7 Days")
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.timelyGreen)
                                        )
                                        .timelyButtonShadow()
                                    }
                                    
                                    Button(action: {
                                        showingCustomTimePicker = true
                                    }) {
                                        HStack {
                                            Image(systemName: "plus.circle")
                                            Text("Create Custom Time")
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.timelyOrange)
                                        )
                                        .timelyButtonShadow()
                                    }
                                }
                                .padding(.horizontal, 32)
                            }
                        } else {
                            TimeSlotGridView(
                                timeSlots: viewModel.availableTimeSlots,
                                selectedSlot: viewModel.selectedTimeSlot,
                                onSlotSelected: { slot in
                                    HapticFeedback.shared.selection()
                                    withAnimation(AnimationConstants.gentleSpring) {
                                        viewModel.selectTimeSlot(slot)
                                    }
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                    
                    // Confirm Button
                    if viewModel.selectedTimeSlot != nil {
                        VStack(spacing: 16) {
                            Button(action: {
                                onContinue()
                            }) {
                                HStack {
                                    Text("Confirm Time")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.timelyGreen)
                                )
                                .timelyButtonShadow()
                            }
                            .padding(.horizontal)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationTitle("Choose Time")
            .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            updateDateRange()
        }
        .sheet(isPresented: $showingCustomTimePicker) {
            CustomTimePickerView(
                isPresented: $showingCustomTimePicker,
                selectedTimeSlot: .constant(viewModel.selectedTimeSlot),
                onTimeSelected: { timeSlot in
                    HapticFeedback.shared.selection()
                    withAnimation(AnimationConstants.gentleSpring) {
                        viewModel.selectTimeSlot(timeSlot)
                    }
                }
            )
        }
        }
    }
    
    private func updateDateRange() {
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        dateRange = DateInterval(start: startOfDay, end: endOfDay)
        
        Task {
            await viewModel.loadCalendarEvents(for: dateRange)
        }
    }
    
    private func getAvailableDates() -> [Date] {
        let today = Date()
        var dates: [Date] = []
        
        // Generate dates for the next 90 days (about 3 months)
        for i in 0..<90 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
        
        return dates
    }
}

struct DateButton: View {
    let date: Date
    let isSelected: Bool
    let onTap: () -> Void
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }
    
    private var dayNumberFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: date))
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(dayNumberFormatter.string(from: date))
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(width: 50, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.timelyBlue : Color.timelyCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
            )
            .timelySubtleShadow()
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TimeSelectionView(onContinue: {})
        .environmentObject(EventViewModel())
}
