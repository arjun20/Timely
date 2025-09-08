//
//  Typography.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

extension Font {
    // MARK: - Display Fonts
    static let timelyLargeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let timelyTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let timelyTitle2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let timelyTitle3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    
    // MARK: - Body Fonts
    static let timelyHeadline = Font.system(size: 17, weight: .semibold, design: .default)
    static let timelyBody = Font.system(size: 17, weight: .regular, design: .default)
    static let timelyCallout = Font.system(size: 16, weight: .regular, design: .default)
    static let timelySubheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let timelyFootnote = Font.system(size: 13, weight: .regular, design: .default)
    static let timelyCaption = Font.system(size: 12, weight: .regular, design: .default)
    static let timelyCaption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    // MARK: - Special Fonts
    static let timelyButton = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let timelyEmoji = Font.system(size: 24, weight: .regular, design: .default)
}

// MARK: - Text Style Extensions
extension Text {
    func timelyStyle(_ style: TimelyTextStyle) -> some View {
        self
            .font(style.font)
            .foregroundColor(style.color)
            .lineLimit(style.lineLimit)
    }
}

struct TimelyTextStyle {
    let font: Font
    let color: Color
    let lineLimit: Int?
    
    static let largeTitle = TimelyTextStyle(
        font: .timelyLargeTitle,
        color: .timelyPrimaryText,
        lineLimit: nil
    )
    
    static let title = TimelyTextStyle(
        font: .timelyTitle,
        color: .timelyPrimaryText,
        lineLimit: nil
    )
    
    static let title2 = TimelyTextStyle(
        font: .timelyTitle2,
        color: .timelyPrimaryText,
        lineLimit: nil
    )
    
    static let headline = TimelyTextStyle(
        font: .timelyHeadline,
        color: .timelyPrimaryText,
        lineLimit: nil
    )
    
    static let body = TimelyTextStyle(
        font: .timelyBody,
        color: .timelyPrimaryText,
        lineLimit: nil
    )
    
    static let secondary = TimelyTextStyle(
        font: .timelySubheadline,
        color: .timelySecondaryText,
        lineLimit: nil
    )
    
    static let caption = TimelyTextStyle(
        font: .timelyCaption,
        color: .timelyTertiaryText,
        lineLimit: nil
    )
}
