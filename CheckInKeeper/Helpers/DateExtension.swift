//
//  DateExtension.swift
//  CheckInKeeper
//
//  Created by Mihaela Simion on 9/27/18.
//  Copyright © 2018 Mihaela Simion. All rights reserved.
//

import Foundation

extension Date {
    func toCustomPrint() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy 'at' HH:mm"
        return formatter.string(from: self)
    }
}
