//
//  Commit+CoreDataClass.swift
//  Project38
//
//  Created by Sergii Miroshnichenko on 01.09.2022.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
            super.init(entity: entity, insertInto: context)
            print("Init called!")
        }
}
