//
//  Task+CoreDataProperties.swift
//  ListTodo
//
//  Created by Ganesh on 17/01/17.
//  Copyright © 2017 ganesh. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }

    @NSManaged public var name: String?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var isComplete: Bool
    @NSManaged public var group: Group?

}
