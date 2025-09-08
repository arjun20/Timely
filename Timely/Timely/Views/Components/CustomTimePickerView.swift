//
//  CustomTimePickerView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct CustomTimePickerView: View {
    @Binding var isPresented: Bool
    @Binding var selectedTimeSlot: TimeSlot?
    let onTimeSelected: (TimeSlot) -> Void
    
    @State private var selectedDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var duration: Int = 60
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Custom Time")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Choose your preferred date and time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Date Picker
                VStack(alignment: .leading, spacing: 12) {
                    Text("Date")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: getCurrentWeekRange(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.horizontal)
                }
                
                // Time Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Time")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        // Start Time
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Start Time")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            DatePicker(
                                "Start Time",
                                selection: $startTime,
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                        }
                        
                        // Duration
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Duration")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Picker("Duration", selection: $duration) {
                                Text("30 min").tag(30)
                                Text("1 hour").tag(60)
                                Text("1.5 hours").tag(90)
                                Text("2 hours").tag(120)
                                Text("3 hours").tag(180)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        // End Time (calculated)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("End Time")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(formatTime(calculatedEndTime))
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.timelyBlue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.timelyBlue.opacity(0.1))
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: createCustomTimeSlot) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Create Time Slot")
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
                    
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            setupInitialTimes()
        }
        .onChange(of: startTime) { _, _ in
            updateEndTime()
        }
        .onChange(of: duration) { _, _ in
            updateEndTime()
        }
    }
    
    private var calculatedEndTime: Date {
        calendar.date(byAdding: .minute, value: duration, to: startTime) ?? startTime
    }
    
    private func setupInitialTimes() {
        let now = Date()
        selectedDate = now
        
        // Set start time to next hour
        let nextHour = calendar.date(byAdding: .hour, value: 1, to: now) ?? now
        let roundedTime = calendar.date(bySettingHour: calendar.component(.hour, from: nextHour), minute: 0, second: 0, of: nextHour) ?? nextHour
        
        startTime = roundedTime
        updateEndTime()
    }
    
    private func updateEndTime() {
        endTime = calculatedEndTime
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func getCurrentWeekRange() -> ClosedRange<Date> {
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7 // Convert Sunday=1 to Monday=0
        
        let startOfWeek = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        return startOfWeek...endOfWeek
    }
    
    private func createCustomTimeSlot() {
        // Combine selected date with start time
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let startHour = calendar.component(.hour, from: startTime)
        let startMinute = calendar.component(.minute, from: startTime)
        
        let finalStartTime = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: startOfDay) ?? startTime
        let finalEndTime = calendar.date(byAdding: .minute, value: duration, to: finalStartTime) ?? finalStartTime
        
        let customSlot = TimeSlot(
            startTime: finalStartTime,
            endTime: finalEndTime,
            isAvailable: true
        )
        
        onTimeSelected(customSlot)
        isPresented = false
    }
}

#Preview {
    CustomTimePickerView(
        isPresented: .constant(true),
        selectedTimeSlot: .constant(nil),
        onTimeSelected: { _ in }
    )
}
