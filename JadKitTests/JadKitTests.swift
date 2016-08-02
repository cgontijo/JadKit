//
//  JadKitTests.swift
//  JadKitTests
//
//  Created by Jad Osseiran on 29/05/2015.
//  Copyright (c) 2016 Jad Osseiran. All rights reserved.
//

import CoreData
import UIKit
import XCTest

let testReuseIdentifier = "Identifier"

private(set) var testManagedObjectContext: NSManagedObjectContext!

private func setUpCoreData() {
  let bundles = [Bundle(for: JadKitTests.self)]
  guard let model = NSManagedObjectModel.mergedModel(from: bundles) else {
    fatalError("Model not found")
  }

  let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
  try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
    configurationName: nil, at: nil, options: nil)

  let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

  testManagedObjectContext = managedObjectContext
}

private func tearDownCoreData() {
  let fetchRequest = NSFetchRequest<TestObject>(entityName: TestObject.entityName)

  do {
    let fetchedObjects = try testManagedObjectContext.fetch(fetchRequest)
    for fetchedObject in fetchedObjects {
      testManagedObjectContext.delete(fetchedObject)
    }
  } catch let error {
    XCTFail("\(error)")
  }

  saveCoreData()

  testManagedObjectContext.reset()
}

private func saveCoreData() {
  do {
    try testManagedObjectContext.save()
  } catch let error {
    XCTFail("\(error)")
  }
}

class JadKitTests: XCTestCase {
  var listData: [[TestObject]]!

  var fetchedResultsController: NSFetchedResultsController<TestObject>!

  override func setUp() {
    super.setUp()

    setUpCoreData()

    listData = [[TestObject(color: UIColor.blue), TestObject(color: UIColor.white),
      TestObject(color: UIColor.red)], [TestObject(color: UIColor.black)]]

    let fetchRequest = NSFetchRequest<TestObject>(entityName: TestObject.entityName)
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionName", ascending: true)]
    fetchRequest.predicate = NSPredicate(value: true)

    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
      managedObjectContext: testManagedObjectContext, sectionNameKeyPath: "sectionName",
      cacheName: nil)
  }

  override func tearDown() {
    tearDownCoreData()

    super.tearDown()
  }

  func performFetch() {
    do {
      try fetchedResultsController.performFetch()
    } catch let error {
      XCTFail("\(error)")
    }
  }

  func insertAndSave(numberOfObjects numObjects: Int, inSectionName sectionName: String) {
    for _ in 0..<numObjects {
      let color: UIColor
      let randomInt = arc4random_uniform(4)
      switch randomInt {
      case 0:
        color = #colorLiteral(red: 0.7540004253, green: 0, blue: 0.2649998069, alpha: 1)

      case 1:
        color = #colorLiteral(red: 0.1603052318, green: 0, blue: 0.8195188642, alpha: 1)

      case 2:
        color = #colorLiteral(red: 0.2818343937, green: 0.5693024397, blue: 0.1281824261, alpha: 1)

      default:
        // I love yellow.
        color = #colorLiteral(red: 0.9346159697, green: 0.6284804344, blue: 0.1077284366, alpha: 1)
      }

      insert(objectWithColor: color, inSectionName: sectionName)
    }

    saveCoreData()
  }

  func addAndSave(objectWithColor color: UIColor, inSectionName sectionName: String) {
    insert(objectWithColor: color, inSectionName: sectionName)
    saveCoreData()
  }

  func updateAndSave(objectWithName name: String, updateClosure: (object: TestObject) -> Void) {
      let request = NSFetchRequest<TestObject>(entityName: TestObject.entityName)
      request.predicate = NSPredicate(format: "name == %@", name)

      do {
        guard let foundObject = try testManagedObjectContext.fetch(request).first else {
            XCTFail()
            return
        }

        // Let the updater do its thing.
        updateClosure(object: foundObject)
        // Save after the update.
        saveCoreData()
      } catch let error {
        XCTFail("\(error)")
      }
  }

  func deleteAndSave(object: TestObject) {
    testManagedObjectContext.delete(object)
    saveCoreData()
  }

  func deleteAndSave(sectionWithName sectionName: String) {
    let request = NSFetchRequest<TestObject>(entityName: TestObject.entityName)
    request.predicate = NSPredicate(format: "sectionName == %@", sectionName)

    do {
      for foundObject in try testManagedObjectContext.fetch(request) {
        testManagedObjectContext.delete(foundObject)
      }

      saveCoreData()
    } catch let error {
      XCTFail("\(error)")
    }
  }

  private func insert(objectWithColor color: UIColor, inSectionName sectionName: String) {
    let object = NSEntityDescription.insertNewObject(forEntityName: TestObject.entityName,
      into: testManagedObjectContext) as! TestObject

    object.name = UUID().uuidString
    object.sectionName = sectionName
    object.color = color
  }
}

class TestObject: NSManagedObject {
  @NSManaged var name: String
  @NSManaged var color: UIColor
  @NSManaged var sectionName: String?

  private class var entityName: String {
    return "TestObject"
  }

  private class var entityDescription: NSEntityDescription {
    return NSEntityDescription.entity(forEntityName: entityName,
      in: testManagedObjectContext)!
  }

  convenience init(color: UIColor) {
    self.init(entity: TestObject.entityDescription, insertInto: nil)

    self.name = UUID().uuidString
    self.color = color
  }
}
