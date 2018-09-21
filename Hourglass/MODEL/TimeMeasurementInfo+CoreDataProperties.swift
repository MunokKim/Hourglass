//
//  TimeMeasurementInfo+CoreDataProperties.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 9. 21..
//  Copyright © 2018년 김문옥. All rights reserved.
//
//

import Foundation
import CoreData


extension TimeMeasurementInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeMeasurementInfo> {
        return NSFetchRequest<TimeMeasurementInfo>(entityName: "TimeMeasurementInfo")
    }

    @NSManaged public var eachTurnOfWorkID: Int32
    @NSManaged public var elapsedTime: Int32
    @NSManaged public var workStart: NSDate?
    @NSManaged public var goalSuccessOrFailWhether: Bool
    @NSManaged public var successiveGoalAchievement: Int16
    @NSManaged public var actualCompletion: NSDate?
    @NSManaged public var remainingTime: Int32
    @NSManaged public var work: WorkInfo?

}
