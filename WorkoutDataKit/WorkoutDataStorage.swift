//
//  WorkoutDataStorage.swift
//  WorkoutDataKit
//
//  Created by Karim Abou Zeid on 05.12.19.
//  Copyright © 2019 Karim Abou Zeid Software. All rights reserved.
//

import Foundation
import CoreData
import Combine

public class WorkoutDataStorage {
    public static var model: NSManagedObjectModel {
        guard let modelURL = Bundle(for: Self.self).url(forResource: "WorkoutData", withExtension: "momd") else { fatalError("invalid WorkoutData model URL") }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("could not create managed object model from \(modelURL)") }
        return model
    }
    
    public let persistentContainer: NSPersistentContainer
    
    private var workoutDataObserverCancellable: Cancellable?
    
    public init(storeDescription: NSPersistentStoreDescription? = nil) {
        // create the core data stack
        persistentContainer = NSPersistentContainer(name: "WorkoutData", managedObjectModel: Self.model)
        if let storeDescription = storeDescription {
            persistentContainer.persistentStoreDescriptions = [storeDescription]
        }
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("could not load persistent store \(storeDescription): \(error), \(error.userInfo)")
            } else {
                print("loaded persistent store: \(storeDescription)")
            }
        })
    }
}

import os.signpost
extension WorkoutDataStorage {
    public static func sendObjectsWillChange(changes: NSManagedObjectContext.ObjectChanges) {
        for changedObject in changes.inserted.union(changes.updated).union(changes.deleted) {
            // instruments debugging
            let signPostID = OSSignpostID(log: SignpostLog.workoutDataPublisher)
            let signPostName: StaticString = "process single workout data change"
            os_signpost(.begin, log: SignpostLog.workoutDataPublisher, name: signPostName, signpostID: signPostID, "%{public}s", changedObject.objectID.description)
            defer { os_signpost(.end, log: SignpostLog.workoutDataPublisher, name: signPostName, signpostID: signPostID) }
            //
            
            changedObject.objectWillChange.send()
            if let workout = changedObject as? Workout {
                workout.workoutExercises?.compactMap { $0 as? WorkoutExercise }
                    .forEach { workoutExercise in
                        workoutExercise.objectWillChange.send()
                        workoutExercise.workoutSets?.compactMap { $0 as? WorkoutSet }
                            .forEach { $0.objectWillChange.send() }
                }
            } else if let workoutExercise = changedObject as? WorkoutExercise {
                workoutExercise.workout?.objectWillChange.send()
                workoutExercise.workoutSets?.compactMap { $0 as? WorkoutSet }
                    .forEach { $0.objectWillChange.send() }
            } else if let workoutSet = changedObject as? WorkoutSet {
                workoutSet.workoutExercise?.objectWillChange.send()
                workoutSet.workoutExercise?.workout?.objectWillChange.send()
            } else {
                print("change in unknown NSManagedObject \(changedObject)")
            }
        }
    }
}
