//
//  Date+Extensions.swift
//  MyTask
//
//  Created by Vikas Kumar on 19/07/23.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let result = dateFormatter.string(from: self)
        return result
    }
}
