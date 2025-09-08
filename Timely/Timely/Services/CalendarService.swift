//
//  CalendarService.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import Foundation
import EventKit

enum CalendarError: Error, LocalizedError {
    case accessDenied
    case saveFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Calendar access is required to use this feature"
        case .saveFailed(let error):
            return "Failed to save event: \(error.localizedDescription)"
        }
    }
}

class CalendarService {
    private let eventStore = EKEventStore()
    
    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [EKEvent] {
        // Check authorization status first
        let status = EKEventStore.authorizationStatus(for: .event)
        guard status == .fullAccess else {
            throw CalendarError.accessDenied
        }
        
        let predicate = eventStore.predicateForEvents(
            withStart: startDate,
            end: endDate,
            calendars: nil
        )
        
        return eventStore.events(matching: predicate)
    }
    
    func createEvent(_ event: Event) async throws {
        // Check authorization status first
        let status = EKEventStore.authorizationStatus(for: .event)
        guard status == .fullAccess else {
            throw CalendarError.accessDenied
        }
        
        let ekEvent = EKEvent(eventStore: eventStore)
        ekEvent.title = event.title
        ekEvent.startDate = event.startDate
        ekEvent.endDate = event.endDate
        ekEvent.location = event.location
        ekEvent.notes = event.description
        
        // Add attendee information to the event notes
        // This is the most reliable way to include attendee information
        let attendeeEmails = event.attendees.compactMap { $0.email }
        if !attendeeEmails.isEmpty {
            let attendeeList = attendeeEmails.joined(separator: ", ")
            let currentNotes = ekEvent.notes ?? ""
            if currentNotes.isEmpty {
                ekEvent.notes = "Attendees: \(attendeeList)"
            } else {
                ekEvent.notes = "\(currentNotes)\n\nAttendees: \(attendeeList)"
            }
        }
        
        // Set calendar (use default calendar)
        if let defaultCalendar = eventStore.defaultCalendarForNewEvents {
            ekEvent.calendar = defaultCalendar
        }
        
        do {
            try eventStore.save(ekEvent, span: .thisEvent)
        } catch {
            throw CalendarError.saveFailed(error)
        }
    }
    
    func requestAccess() async -> EKAuthorizationStatus {
        do {
            let hasAccess = try await eventStore.requestFullAccessToEvents()
            return hasAccess ? .fullAccess : .denied
        } catch {
            return .denied
        }
    }
}
