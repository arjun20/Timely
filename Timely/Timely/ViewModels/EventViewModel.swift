//
//  EventViewModel.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import Foundation
import EventKit
import Combine

@MainActor
class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var eventCards: [EventCard] = []
    @Published var selectedEventCard: EventCard?
    @Published var availableTimeSlots: [TimeSlot] = []
    @Published var selectedTimeSlot: TimeSlot?
    @Published var attendees: [Attendee] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaultsManager = UserDefaultsManager.shared
    
    private let eventStore = EKEventStore()
    private let calendarService = CalendarService()
    private let airtableService = AirtableService()
    
    init() {
        loadEventCards()
    }
    
    // MARK: - Event Card Management
    func loadEventCards() {
        Task {
            do {
                eventCards = try await airtableService.fetchEventCards()
                // Load custom event cards after loading from Airtable
                loadCustomEventCards()
            } catch {
                errorMessage = "Failed to load event cards: \(error.localizedDescription)"
                // Still try to load custom event cards even if Airtable fails
                loadCustomEventCards()
            }
        }
    }
    
    func selectEventCard(_ card: EventCard) {
        selectedEventCard = card
    }
    
    func addCustomEventCard(_ card: EventCard) {
        eventCards.append(card)
        // Save custom event cards to UserDefaults
        saveCustomEventCards()
    }
    
    private func saveCustomEventCards() {
        if let encoded = try? JSONEncoder().encode(eventCards) {
            UserDefaults.standard.set(encoded, forKey: "custom_event_cards")
        }
    }
    
    private func loadCustomEventCards() {
        if let data = UserDefaults.standard.data(forKey: "custom_event_cards"),
           let customCards = try? JSONDecoder().decode([EventCard].self, from: data) {
            eventCards.append(contentsOf: customCards)
        }
    }
    
    func selectTimeSlot(_ slot: TimeSlot) {
        selectedTimeSlot = slot
    }
    
    func resetToHome() {
        selectedEventCard = nil
        selectedTimeSlot = nil
        availableTimeSlots = []
        attendees = []
        errorMessage = nil
    }
    
    // MARK: - Calendar Integration
    func requestCalendarAccess() async -> Bool {
        let status = await calendarService.requestAccess()
        return status == .fullAccess
    }
    
    func loadCalendarEvents(for dateRange: DateInterval) async {
        await MainActor.run {
            isLoading = true
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            let hasAccess = await requestCalendarAccess()
            guard hasAccess else {
                await MainActor.run {
                    errorMessage = "Calendar access is required to find available times"
                }
                return
            }
            
            let calendarEvents = try await calendarService.fetchEvents(
                from: dateRange.start,
                to: dateRange.end
            )
            
            // Convert EKEvents to our Event model
            let convertedEvents = calendarEvents.map { ekEvent in
                Event(
                    title: ekEvent.title ?? "Untitled Event",
                    startDate: ekEvent.startDate,
                    endDate: ekEvent.endDate,
                    location: ekEvent.location
                )
            }
            
            await MainActor.run {
                events = convertedEvents
            }
            
            // Calculate available time slots
            await calculateAvailableTimeSlots(for: dateRange)
            
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load calendar events: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Time Slot Calculation
    func calculateAvailableTimeSlots(for dateRange: DateInterval) async {
        let workingHours = getWorkingHours()
        let timeSlots = generateTimeSlots(
            for: dateRange,
            workingHours: workingHours,
            duration: selectedEventCard?.estimatedDuration ?? 60
        )
        
        // Mark time slots as unavailable if they conflict with existing events
        let updatedTimeSlots = timeSlots.map { slot in
            let hasConflict = events.contains { event in
                slot.startTime < event.endDate && slot.endTime > event.startDate
            }
            return TimeSlot(
                startTime: slot.startTime,
                endTime: slot.endTime,
                isAvailable: !hasConflict
            )
        }
        
        await MainActor.run {
            availableTimeSlots = updatedTimeSlots
        }
    }
    
    private func getWorkingHours() -> (start: Int, end: Int) {
        // Default working hours: 9 AM to 6 PM
        return (start: 9, end: 18)
    }
    
    private func generateTimeSlots(
        for dateRange: DateInterval,
        workingHours: (start: Int, end: Int),
        duration: Int
    ) -> [TimeSlot] {
        var slots: [TimeSlot] = []
        let calendar = Calendar.current
        
        var currentDate = dateRange.start
        while currentDate < dateRange.end {
            let startOfDay = calendar.startOfDay(for: currentDate)
            let startHour = calendar.date(byAdding: .hour, value: workingHours.start, to: startOfDay)!
            let endHour = calendar.date(byAdding: .hour, value: workingHours.end, to: startOfDay)!
            
            var slotStart = startHour
            while slotStart < endHour {
                let slotEnd = calendar.date(byAdding: .minute, value: duration, to: slotStart)!
                
                if slotEnd <= endHour {
                    slots.append(TimeSlot(startTime: slotStart, endTime: slotEnd))
                }
                
                // Move to next 15-minute slot for more options
                slotStart = calendar.date(byAdding: .minute, value: 15, to: slotStart)!
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return slots
    }
    
    // MARK: - Event Creation
    func createEvent(
        title: String,
        startDate: Date,
        endDate: Date,
        attendees: [Attendee]
    ) async {
        do {
            let event = Event(
                title: title,
                startDate: startDate,
                endDate: endDate,
                attendees: attendees,
                isConfirmed: true
            )
            
            // Add to calendar
            try await calendarService.createEvent(event)
            
            // Add to local events and save to history
            await MainActor.run {
                self.events.append(event)
                self.userDefaultsManager.saveEventToHistory(event)
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "Failed to create event: \(error.localizedDescription)"
            }
        }
    }
}
