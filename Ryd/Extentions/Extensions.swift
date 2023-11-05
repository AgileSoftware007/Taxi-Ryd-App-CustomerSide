//
//  Extensions.swift
//  Ryd
//
//  Created by Rakib Rz  on 08/11/22.
//

import Foundation

extension Double {
    func minutesToTime() -> String {
        let totalSeconds = self * 60
        let hour = Int(totalSeconds) / 3600
        let minute = Int(totalSeconds) / 60 % 60
        let second = Int(totalSeconds) % 60
        print("Total time: \(hour)h \(minute)m \(second)s")
        let formated = String(format: "%02d:%02d:%02d", hour, minute, second)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        let formattedString = formatter.string(from: TimeInterval(totalSeconds))!
        print(formattedString)
        //        return formattedString
        return formated
        
    }
}

enum Dateformat: String {
    case yyyyddmmhhmmss = "yyyy-MM-dd HH:mm:ss"
}

extension Date {
    static func convertFrom(string: String, format: Dateformat) -> Date? {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format.rawValue
        return dateformat.date(from: string)
    }
    
    func getTime() -> String? {
        let dateFormatter = DateFormatter()

        // Set Date/Time Style
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}

extension RangeReplaceableCollection where Element == ChatMessage {
    mutating func appendUnique(_ element: Element) -> Bool {
        guard self.contains(where: {$0.id == element.id }) == false else { return false }
        
        self.append(element)
        return true
    }
}
