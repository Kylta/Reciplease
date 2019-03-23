//
//  DateComponentsFormatterExtensions.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 23/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

extension Int {
    var timeFormmater: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        return formatter.string(from: TimeInterval(self))!
    }
}
