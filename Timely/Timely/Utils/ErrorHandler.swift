//
//  ErrorHandler.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import Foundation
import SwiftUI

enum TimelyError: Error, LocalizedError {
    case calendarAccessDenied
    case calendarEventCreationFailed
    case networkError
    case dataCorruption
    case invalidInput
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .calendarAccessDenied:
            return "Calendar access is required to use Timely. Please enable it in Settings."
        case .calendarEventCreationFailed:
            return "Failed to create calendar event. Please try again."
        case .networkError:
            return "Network connection error. Please check your internet connection."
        case .dataCorruption:
            return "Data corruption detected. Please restart the app."
        case .invalidInput:
            return "Invalid input provided. Please check your data and try again."
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .calendarAccessDenied:
            return "Go to Settings > Privacy & Security > Calendars and enable access for Timely."
        case .calendarEventCreationFailed:
            return "Make sure you have a default calendar set up in your Calendar app."
        case .networkError:
            return "Check your Wi-Fi or cellular connection and try again."
        case .dataCorruption:
            return "Restart the app or reinstall if the problem persists."
        case .invalidInput:
            return "Please verify all information is correct and try again."
        case .unknown:
            return "If this problem continues, please contact support."
        }
    }
}

class ErrorHandler: ObservableObject {
    @Published var currentError: TimelyError?
    @Published var showError = false
    
    func handle(_ error: Error) {
        let timelyError: TimelyError
        
        if let calendarError = error as? CalendarError {
            switch calendarError {
            case .accessDenied:
                timelyError = .calendarAccessDenied
            case .saveFailed:
                timelyError = .calendarEventCreationFailed
            }
        } else if let airtableError = error as? AirtableError {
            timelyError = .networkError
        } else {
            timelyError = .unknown(error)
        }
        
        DispatchQueue.main.async {
            self.currentError = timelyError
            self.showError = true
        }
    }
    
    func clearError() {
        currentError = nil
        showError = false
    }
}

struct ErrorAlert: ViewModifier {
    @ObservedObject var errorHandler: ErrorHandler
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $errorHandler.showError) {
                Button("OK") {
                    errorHandler.clearError()
                }
            } message: {
                if let error = errorHandler.currentError {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(error.errorDescription ?? "An error occurred")
                        
                        if let suggestion = error.recoverySuggestion {
                            Text(suggestion)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
    }
}

extension View {
    func errorAlert(errorHandler: ErrorHandler) -> some View {
        self.modifier(ErrorAlert(errorHandler: errorHandler))
    }
}
