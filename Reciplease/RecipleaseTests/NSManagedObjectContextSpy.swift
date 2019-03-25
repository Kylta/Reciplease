//
//  NSManagedObjectContextSpy.swift
//  RecipleaseTests
//
//  Created by Christophe Bugnon on 25/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation
import CoreData

@testable import Reciplease

class NSManagedObjectContextSpy: NSManagedObjectContextProtocol {
    var fetchErrorToThrow: Error?
    var entitiesToReturn: [Any]?
    var addEntityToReturn: Any?
    var saveErrorToReturn: Error?
    var deletedObject: NSManagedObject?

    func allEntities<T: NSManagedObject>(withType type: T.Type) throws -> [T] {
        return try allEntities(withType: type, predicate: nil)
    }

    func allEntities<T: NSManagedObject>(withType type: T.Type, predicate: NSPredicate?) throws -> [T] {
        if let fetchErrorToThrow = fetchErrorToThrow {
            throw fetchErrorToThrow
        } else {
            return entitiesToReturn as! [T]
        }
    }

    func addEntity<T: NSManagedObject>(withType type : T.Type) -> T? {
        return addEntityToReturn as? T
    }

    func save() throws {
        if let saveErrorToReturn = saveErrorToReturn {
            throw saveErrorToReturn
        }
    }

    func delete(_ object: NSManagedObject) {
        deletedObject = object
    }
}

