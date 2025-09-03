//
//  StringExtension.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import Foundation

extension String {
    var localized: String {
        return LanguageManager.shared.localizedString(for: self)
    }
} 