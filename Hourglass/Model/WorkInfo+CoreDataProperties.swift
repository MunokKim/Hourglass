//
//  WorkInfo+CoreDataProperties.swift
//  Hourglass
//
//  Created by 김문옥 on 2018. 9. 21..
//  Copyright © 2018년 김문옥. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkInfo> {
        return NSFetchRequest<WorkInfo>(entityName: "WorkInfo")
    }

    @NSManaged public var averageElapsedTime: Float
    @NSManaged public var averageRemainingTime: Float
    @NSManaged public var currentSuccessiveAchievementWhether: Int16
    @NSManaged public var createdDate: Date
    @NSManaged public var estimatedWorkTime: Int32
    @NSManaged public var goalFail: Int32
    @NSManaged public var goalSuccess: Int32
    @NSManaged public var iconImagePath: String?
    @NSManaged public var successiveAchievementHighestRecord: Int16
    @NSManaged public var successRate: Float
    @NSManaged public var totalWork: Int32
    @NSManaged public var workID: Int16
    @NSManaged public var workName: String?
    @NSManaged public var eachTurnsOfWork: NSSet?

}

// MARK: Generated accessors for eachTurnsOfWork
extension WorkInfo {

    @objc(addEachTurnsOfWorkObject:)
    @NSManaged public func addToEachTurnsOfWork(_ value: TimeMeasurementInfo)

    @objc(removeEachTurnsOfWorkObject:)
    @NSManaged public func removeFromEachTurnsOfWork(_ value: TimeMeasurementInfo)

    @objc(addEachTurnsOfWork:)
    @NSManaged public func addToEachTurnsOfWork(_ values: NSSet)

    @objc(removeEachTurnsOfWork:)
    @NSManaged public func removeFromEachTurnsOfWork(_ values: NSSet)

}
