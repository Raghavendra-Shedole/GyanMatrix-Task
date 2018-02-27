//
//  Country+CoreDataProperties.swift
//  
//
//  Created by Raghavendra Shedole on 27/02/18.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var flagUrl: String?

}
