//
//  StaticTableListTests.swift
//  JadKit
//
//  Created by Jad Osseiran on 4/03/2016.
//  Copyright © 2016 Jad Osseiran. All rights reserved.
//

import UIKit
import XCTest

@testable import JadKit

class StaticTableListTests: JadKitTests {
  private var tableViewController: TableListViewController!

  private var tableView: UITableView {
    return tableViewController.tableView
  }

  override func setUp() {
    super.setUp()

    tableViewController = TableListViewController(style: .plain)
    tableViewController.listData = listData

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: testReuseIdentifier)
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
        let cell = tableViewController.tableView(tableView,
          cellForRowAt: IndexPath(row: row, section: section))
        
        // Make sure that through the protocol extensions we didn't mess up the ordering.
        XCTAssertEqual(cell.textLabel!.text, listData[section][row].name)
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
}

private class TableListViewController: UITableViewController, StaticTableList {
  var listData: [[TestObject]]!
  var selectedCellIndexPaths = [IndexPath]()

  func cellIdentifier(at: IndexPath) -> String {
    return testReuseIdentifier
  }

  func listView(_ listView: UITableView, configureCell cell: UITableViewCell,
    withObject object: TestObject, atIndexPath indexPath: IndexPath) {
      cell.textLabel?.text = object.name
  }

  func listView(_ listView: UITableView, didSelectObject object: TestObject,
    atIndexPath indexPath: IndexPath) {
      selectedCellIndexPaths.append(indexPath)
  }

  // MARK: Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return sectionCount
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemCount(at: section)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
      return cell(at: indexPath)
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    didSelectItem(at: indexPath)
  }
}
