//
//  Result.swift
//  RecipleaseTests
//
//  Created by Christophe Bugnon on 25/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation
@testable import Reciplease

extension Result: Equatable { }

public func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    // Shouldn't be used for PRODUCTION enum comparison. Good enough for unit tests.
    return String(stringInterpolationSegment: lhs) == String(stringInterpolationSegment: rhs)
}

