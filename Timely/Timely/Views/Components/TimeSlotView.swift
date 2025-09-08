//
//  TimeSlotView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct TimeSlotView: View {
    let timeSlot: TimeSlot
    let isSelected: Bool
    let onTap: () -> Void
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(timeFormatter.string(from: timeSlot.startTime))
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(timeFormatter.string(from: timeSlot.endTime))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(minWidth: 60, minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            )
            .timelySubtleShadow()
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!timeSlot.isAvailable)
        .accessibleTimeSlot(
            startTime: timeSlot.startTime,
            endTime: timeSlot.endTime,
            isAvailable: timeSlot.isAvailable
        )
    }
    
    private var backgroundColor: Color {
        if !timeSlot.isAvailable {
            return Color.secondary.opacity(0.1)
        } else if isSelected {
            return Color.timelyBlue.opacity(0.2)
        } else {
            return Color.timelyCardBackground
        }
    }
    
    private var borderColor: Color {
        if !timeSlot.isAvailable {
            return Color.secondary.opacity(0.2)
        } else if isSelected {
            return Color.timelyBlue
        } else {
            return Color.secondary.opacity(0.3)
        }
    }
    
    private var borderWidth: CGFloat {
        isSelected ? 2 : 1
    }
}

struct TimeSlotGridView: View {
    let timeSlots: [TimeSlot]
    let selectedSlot: TimeSlot?
    let onSlotSelected: (TimeSlot) -> Void
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(timeSlots) { slot in
                TimeSlotView(
                    timeSlot: slot,
                    isSelected: selectedSlot?.id == slot.id,
                    onTap: { 
                        HapticFeedback.shared.selection()
                        onSlotSelected(slot) 
                    }
                )
            }
        }
    }
}

#Preview {
    let sampleSlots = [
        TimeSlot(startTime: Date(), endTime: Date().addingTimeInterval(3600), isAvailable: true),
        TimeSlot(startTime: Date().addingTimeInterval(3600), endTime: Date().addingTimeInterval(7200), isAvailable: true),
        TimeSlot(startTime: Date().addingTimeInterval(7200), endTime: Date().addingTimeInterval(10800), isAvailable: false),
        TimeSlot(startTime: Date().addingTimeInterval(10800), endTime: Date().addingTimeInterval(14400), isAvailable: true)
    ]
    
    TimeSlotGridView(
        timeSlots: sampleSlots,
        selectedSlot: sampleSlots.first,
        onSlotSelected: { _ in }
    )
    .padding()
}
