//
//  CollectionListTests.swift
//  JadKit
//
//  Created by Jad Osseiran on 3/4/16.
//  Copyright © 2016 Jad Osseiran. All rights reserved.
//

import UIKit
import XCTest

@testable import JadKit

class CollectionListTests: JadKitTests {
  private var collectionViewController: CollectionListViewController!

  private var collectionView: UICollectionView {
    return collectionViewController.collectionView!
  }

  override func setUp() {
    super.setUp()

    collectionViewController = CollectionListViewController(
      collectionViewLayout: UICollectionViewFlowLayout())
    collectionViewController.listData = listData

    collectionView.register(UICollectionViewCell.self,
      forCellWithReuseIdentifier: testReuseIdentifier)
  }

  override func tearDown() {
    // Make sure our list controller and view are always in sync.
    testListRowsAndSections()

    super.tearDown()
  }

  func testListRowsAndSections() {
    XCTAssertEqual(collectionView.numberOfSections(), collectionViewController.sectionCount)

    for section in 0..<collectionView.numberOfSections() {
      XCTAssertEqual(collectionView.numberOfItems(inSection: section),
        collectionViewController.itemCount(at: section))
    }
  }

  func testDequeueCells() {
    // Mimic-ish what a UICollectionViewController would do
    for section in 0..<collectionViewController.numberOfSections(in: collectionView) {
      for row in 0..<collectionViewController.collectionView(collectionView,
        numberOfItemsInSection: section) {
          let cell = collectionViewController.collectionView(collectionView,
            cellForItemAt: IndexPath(row: row, section: section))

          // Make sure that through the protocol extensions we didn't mess up the ordering.
          XCTAssertEqual(cell.backgroundColor, listData[section][row].color)
      }
    }
  }

  func testSelectCells() {
    // Mimic-ish what a UICollectionViewController would do
    for section in 0..<collectionViewController.numberOfSections(in: collectionView) {
      for row in 0..<collectionViewController.collectionView(collectionView,
        numberOfItemsInSection: section) {
          let indexPath = IndexPath(row: row, section: section)

          XCTAssertFalse(collectionViewController.selectedCellIndexPaths.contains(indexPath))
          collectionViewController.collectionView(collectionView, didSelectItemAt: indexPath)
          XCTAssertTrue(collectionViewController.selectedCellIndexPaths.contains(indexPath))
      }
    }
  }
}

private class CollectionListViewController: UICollectionViewController, CollectionList {
  var listData: [[TestObject]]!
  var selectedCellIndexPaths = [IndexPath]()

  func cellIdentifier(at: IndexPath) -> String {
    return testReuseIdentifier
  }

  func listView(_ listView: UICollectionView, configureCell cell: UICollectionViewCell,
    withObject object: TestObject, atIndexPath indexPath: IndexPath) {
      cell.backgroundColor = object.color
  }

  func listView(_ listView: UICollectionView, didSelectObject object: TestObject,
    atIndexPath indexPath: IndexPath) {
      selectedCellIndexPaths.append(indexPath)
  }

  // MARK: Collection View

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sectionCount
  }

  override func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return itemCount(at: section)
  }

  override func collectionView(_ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      return cell(at: indexPath)
  }

  override func collectionView(_ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
      didSelectItem(at: indexPath)
  }
}
