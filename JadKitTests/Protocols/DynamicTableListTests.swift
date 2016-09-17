//
//  DynamicStaticTableListTests.swift
//  JadKit
//
//  Created by Jad Osseiran on 3/6/16.
//  Copyright © 2016 Jad Osseiran. All rights reserved.
//

import CoreData
import UIKit
import XCTest

@testable import JadKit

class DynamicStaticTableListTests: JadKitTests {
  private var tableViewController: DynamicTableListViewController!

  private var tableView: UITableView {
    return tableViewController.tableView
  }

  override func setUp() {
    super.setUp()

    tableViewController = DynamicTableListViewController(style: .plain)
    tableViewController.fetchedResultsController = fetchedResultsController

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: testReuseIdentifier)

    insertAndSave(numberOfObjects: 10, inSectionName: "First")
    insertAndSave(numberOfObjects: 5, inSectionName: "Second")

    performFetch()
  }

  override func tearDown() {
    // Make sure our list controller and view are always in sync.
    testListRowsAndSections()

    super.tearDown()
  }

  func testListRowsAndSections() {
    XCTAssertEqual(tableView.numberOfSections, tableViewController.sectionCount)

    for section in 0..<tableView.numberOfSections {
      XCTAssertEqual(tableView.numberOfRows(inSection: section),
                     tableViewController.itemCount(at: section))
    }
  }

  func testDequeueCells() {
    // Mimic-ish what a UITableViewController would do
    for section in 0..<tableViewController.numberOfSections(in: tableView) {
      for row in 0..<tableViewController.tableView(tableView, numberOfRowsInSection: section) {
        let indexPath = IndexPath(row: row, section: section)
        let cell = tableViewController.tableView(tableView,
                                                 cellForRowAt: indexPath)

        if let testObject = tableViewController.object(at: indexPath) {
          XCTAssertEqual(cell.textLabel!.text, testObject.name)
        } else {
          XCTFail()
        }
      }
    }
  }

  func testSelectCells() {
    // Mimic-ish what a UITableViewController would do
    for section in 0..<tableViewController.numberOfSections(in: tableView) {
      for row in 0..<tableViewController.tableView(tableView, numberOfRowsInSection: section) {
        let indexPath = IndexPath(row: row, section: section)

        XCTAssertFalse(tableViewController.selectedCellIndexPaths.contains(indexPath))
        tableViewController.tableView(tableView, didSelectRowAt: indexPath)
        XCTAssertTrue(tableViewController.selectedCellIndexPaths.contains(indexPath))
      }
    }
  }

  func testAddingRow() {
    let numRowsBeforeAdd = tableViewController.itemCount(at: 0)

    addAndSave(objectWithColor: #colorLiteral(red: 0.1431525946, green: 0.4145618975, blue: 0.7041897774, alpha: 1), inSectionName: "First")
    XCTAssertEqual(numRowsBeforeAdd + 1, tableViewController.itemCount(at: 0))
  }

  func testUpdatingRow() {
    let updateIndexPath = IndexPath(row: 0, section: 0)

    guard let objectToUpdate = tableViewController.object(at: updateIndexPath) else {
      XCTFail()
      return
    }

    XCTAssertNotEqual(objectToUpdate.color, UIColor.cyan)

    updateAndSave(objectWithName: objectToUpdate.name) { object in
      object.color = #colorLiteral(red: 0.1431525946, green: 0.4145618975, blue: 0.7041897774, alpha: 1)
    }

    guard let updatedObject = tableViewController.object(at: updateIndexPath) else {
      XCTFail()
      return
    }

    XCTAssertEqual(updatedObject.color, #colorLiteral(red: 0.1431525946, green: 0.4145618975, blue: 0.7041897774, alpha: 1))
  }

  func testDeletingRow() {
    let numRowsBeforeDelete = tableViewController.itemCount(at: 0)

    guard let objectToDelete = tableViewController.object(at: IndexPath(row: 0, section: 0)) else {
      XCTFail()
      return
    }

    deleteAndSave(object: objectToDelete)
    XCTAssertEqual(numRowsBeforeDelete - 1, tableViewController.itemCount(at: 0))
  }

  func testMovingRow() {
    let numRowsInSectionOneBeforeMove = tableViewController.itemCount(at: 0)
    let numRowsInSectionTwoBeforeMove = tableViewController.itemCount(at: 1)

    guard let objectToMove = tableViewController.object(at: IndexPath(row: 0, section: 0)) else {
      XCTFail()
      return
    }

    updateAndSave(objectWithName: objectToMove.name) { object in
      object.sectionName = "Second"
    }

    XCTAssertEqual(numRowsInSectionOneBeforeMove - 1, tableViewController.itemCount(at: 0))
    XCTAssertEqual(numRowsInSectionTwoBeforeMove + 1, tableViewController.itemCount(at: 1))
  }

  func testAddingSection() {
    // TODO: Add a section.
  }

  func testUpdatingSection() {
    // TODO: Figure out how to test updating a section.
  }

  func testDeletingSection() {
    let numSectionsBeforeDelete = tableViewController.sectionCount
    deleteAndSave(sectionWithName: "First")
    XCTAssertEqual(numSectionsBeforeDelete - 1, tableViewController.sectionCount)
  }
}

private class DynamicTableListViewController: UITableViewController, DynamicTableList {
  var fetchedResultsController: NSFetchedResultsController<TestObject>! {
    didSet {
      fetchedResultsController.delegate = self
    }
  }

  var selectedCellIndexPaths = [IndexPath]()

  func cellIdentifier(at: IndexPath) -> String {
    return testReuseIdentifier
  }

  func listView(_ listView: UITableView, configureCell cell: UITableViewCell, withObject object: TestObject,
                atIndexPath indexPath: IndexPath) {
    cell.textLabel?.text = object.name
  }

  func listView(_ listView: UITableView, didSelectObject object: TestObject, atIndexPath indexPath: IndexPath) {
    selectedCellIndexPaths.append(indexPath)
  }

  // MARK: Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return sectionCount
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemCount(at: section)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return cell(at: indexPath)
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    didSelectItem(at: indexPath)
  }

  // MARK: Fetched Controller

  @objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    willChangeContent()
  }

  @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                        didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,
                        for type: NSFetchedResultsChangeType) {
    didChangeSection(sectionIndex, withChangeType: type)
  }

  @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                        didChange anObject: Any, at indexPath: IndexPath?,
                        for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    didChangeObject(at: indexPath, withChangeType: type, newIndexPath: newIndexPath)
  }

  @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    didChangeContent()
  }
}
