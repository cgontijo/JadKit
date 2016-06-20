//
//  FetchedListTests.swift
//  JadKit
//
//  Created by Jad Osseiran on 3/5/16.
//  Copyright © 2016 Jad Osseiran. All rights reserved.
//

import CoreData
import UIKit
import XCTest

@testable import JadKit

class FetchedListTests: JadKitTests, FetchedList {
  typealias ListView = UIView
  typealias Cell = UIView
  typealias Object = TestObject

  override func setUp() {
    super.setUp()

    insertAndSave(numberOfObjects: 10, inSectionName: "First")
    insertAndSave(numberOfObjects: 5, inSectionName: "Second")

    performFetch()
  }

  func testitemCountAndSetions() {
    if let sections = fetchedResultsController.sections {
      XCTAssertEqual(sectionCount, sections.count)

      for sectionIndex in 0..<sections.count {
        XCTAssertEqual(itemCount(at: sectionIndex), sections[sectionIndex].numberOfObjects)
      }
    }
  }

  func testValidIndexPath() {
    XCTAssertTrue(isValidIndexPath(IndexPath(row: 0, section: 1)))
  }

  func testInvalidIndexPath() {
    XCTAssertFalse(isValidIndexPath(IndexPath(row: 1, section: 10)))
  }

  func testObjectAtIndexPathSectionTooBig() {
    XCTAssertNil(object(at: IndexPath(row: 0, section: 2)))
  }

  func testObjectAtIndexPathSectionTooSmall() {
    XCTAssertNil(object(at: IndexPath(row: 0, section: -1)))
  }

  func testObjectAtIndexPathRowTooBig() {
    XCTAssertNil(object(at: IndexPath(row: 10, section: 0)))
  }

  func testObjectAtIndexPathRowTooSmall() {
    XCTAssertNil(object(at: IndexPath(row: -1, section: 0)))
  }

  func testValidSectionNames() {
    XCTAssertEqual(titleForHeader(at: 0), "First")
    XCTAssertEqual(titleForHeader(at: 1), "Second")
  }

  func testInvalidSectionNames() {
    XCTAssertNil(titleForHeader(at: 2))
    XCTAssertNil(titleForHeader(at: -2))
  }

  // MARK: Conformance

  func cellIdentifier(at: IndexPath) -> String {
    return testReuseIdentifier
  }

  func listView(_ listView: ListView, configureCell cell: Cell, withObject object: Object,
    atIndexPath indexPath: IndexPath) { }

  func listView(_ listView: ListView, didSelectObject object: Object,
    atIndexPath indexPath: IndexPath) { }
}
