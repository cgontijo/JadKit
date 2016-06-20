////
////  FetchedCollectionListTests.swift
////  JadKit
////
////  Created by Jad Osseiran on 3/6/16.
////  Copyright © 2016 Jad Osseiran. All rights reserved.
////
//
//import CoreData
//import UIKit
//import XCTest
//
//@testable import JadKit
//
//class FetchedCollectionListTests: JadKitTests {
//  private var collectionViewController: FetchedCollectionListViewController!
//
//  private var collectionView: UICollectionView {
//    return collectionViewController.collectionView!
//  }
//
//  override func setUp() {
//    super.setUp()
//
//    collectionViewController = FetchedCollectionListViewController(
//      collectionViewLayout: UICollectionViewFlowLayout())
//    collectionViewController.fetchedResultsController = fetchedResultsController
//
//    collectionView.register(UICollectionViewCell.self,
//                            forCellWithReuseIdentifier: testReuseIdentifier)
//
//    insertAndSave(numberOfObjects: 10, inSectionName: "First")
//    insertAndSave(numberOfObjects: 5, inSectionName: "Second")
//
//    performFetch()
//  }
//
//  override func tearDown() {
//    // Make sure our list controller and view are always in sync.
//    testListRowsAndSections()
//
//    super.tearDown()
//  }
//
//  func testListRowsAndSections() {
//    XCTAssertEqual(collectionView.numberOfSections(), collectionViewController.sectionCount)
//
//    for section in 0..<collectionView.numberOfSections() {
//      XCTAssertEqual(collectionView.numberOfItems(inSection: section),
//                     collectionViewController.itemCount(at: section))
//    }
//  }
//
//  func testDequeueCells() {
//    // Mimic-ish what a UICollectionViewController would do
//    for section in 0..<collectionViewController.numberOfSections(in: collectionView) {
//      for row in 0..<collectionViewController.collectionView(collectionView,
//                                                             numberOfItemsInSection: section) {
//                                                              let indexPath = IndexPath(row: row, section: section)
//                                                              let cell = collectionViewController.collectionView(collectionView,
//                                                                                                                 cellForItemAt: indexPath)
//
//                                                              if let testObject = collectionViewController.object(at: indexPath) {
//                                                                XCTAssertEqual(cell.backgroundColor, testObject.color)
//                                                              } else {
//                                                                XCTFail()
//                                                              }
//      }
//    }
//  }
//
//  func testSelectCells() {
//    // Mimic-ish what a UICollectionViewController would do
//    for section in 0..<collectionViewController.numberOfSections(in: collectionView) {
//      for row in 0..<collectionViewController.collectionView(collectionView,
//                                                             numberOfItemsInSection: section) {
//                                                              let indexPath = IndexPath(row: row, section: section)
//
//                                                              XCTAssertFalse(collectionViewController.selectedCellIndexPaths.contains(indexPath))
//                                                              collectionViewController.collectionView(collectionView,
//                                                                                                      didSelectItemAt: indexPath)
//                                                              XCTAssertTrue(collectionViewController.selectedCellIndexPaths.contains(indexPath))
//      }
//    }
//  }
//
//  func testAddingRow() {
//    // FIXME: This crashes, it seems like the backing store (fetched results controller) is not
//    // updating at the right time and we are getting some NSInternalInconsistency exception.
//    // I don't think it is that hard to figure out... just need time.
//    //    let numRowsBeforeAdd = collectionViewController.itemCount(at: 0)
//    //    addAndSaveObject(UIColor.cyanColor(), sectionName: "First")
//    //    XCTAssertEqual(numRowsBeforeAdd + 1, collectionViewController.itemCount(at: 0))
//  }
//
//  func testUpdatingRow() {
//    let updateIndexPath = IndexPath(row: 0, section: 0)
//
//    guard let objectToUpdate = collectionViewController.object(at: updateIndexPath)
//      as? TestObject else {
//        XCTFail()
//        return
//    }
//
//    XCTAssertNotEqual(objectToUpdate.color, UIColor.cyan())
//
//    updateAndSave(objectWithName: objectToUpdate.name) { object in
//      object.color = UIColor.cyan()
//    }
//
//    guard let updatedObject = collectionViewController.object(at: updateIndexPath)
//      as? TestObject else {
//        XCTFail()
//        return
//    }
//
//    XCTAssertEqual(updatedObject.color, UIColor.cyan())
//  }
//
//  func testDeletingRow() {
//    let numRowsBeforeDelete = collectionViewController.itemCount(at: 0)
//
//    guard let objectToDelete = collectionViewController.object(at: IndexPath(row: 0, section: 0))
//      as? TestObject else {
//        XCTFail()
//        return
//    }
//
//    deleteAndSaveObject(objectToDelete)
//    XCTAssertEqual(numRowsBeforeDelete - 1, collectionViewController.itemCount(at: 0))
//  }
//
//  func testMovingRow() {
//    let numRowsInSectionOneBeforeMove = collectionViewController.itemCount(at: 0)
//    let numRowsInSectionTwoBeforeMove = collectionViewController.itemCount(at: 1)
//
//    guard let objectToMove = collectionViewController.object(at: IndexPath(row: 0, section: 0))
//      as? TestObject else {
//        XCTFail()
//        return
//    }
//
//    updateAndSaveObject(forName: objectToMove.name) { object in
//      object.sectionName = "Second"
//    }
//
//    XCTAssertEqual(numRowsInSectionOneBeforeMove - 1, collectionViewController.itemCount(at: 0))
//    XCTAssertEqual(numRowsInSectionTwoBeforeMove + 1, collectionViewController.itemCount(at: 1))
//  }
//
//  func testAddingSection() {
//    // TODO: Add a section.
//  }
//
//  func testUpdatingSection() {
//    // TODO: Figure out how to test updating a section.
//  }
//
//  func testDeletingSection() {
//    let numSectionsBeforeDelete = collectionViewController.numberOfSections
//    deleteAndSaveSection("First")
//    XCTAssertEqual(numSectionsBeforeDelete - 1, collectionViewController.numberOfSections)
//  }
//}
//
//private class FetchedCollectionListViewController: UICollectionViewController, FetchedCollectionList {
//  var changeOperations: [BlockOperation] = [BlockOperation]()
//
//  var fetchedResultsController: NSFetchedResultsController<TestObject>! {
//    didSet {
//      fetchedResultsController.delegate = self
//    }
//  }
//
//  var selectedCellIndexPaths = [IndexPath]()
//
//  func cellIdentifier(at: IndexPath) -> String {
//    return testReuseIdentifier
//  }
//
//  func listView(_ listView: UICollectionView, configureCell cell: UICollectionViewCell,
//                withObject object: AnyObject, atIndexPath indexPath: IndexPath) {
//    if let testObject = object as? TestObject {
//      cell.backgroundColor = testObject.color
//    }
//  }
//
//  func listView(_ listView: UICollectionView, didSelectObject object: AnyObject,
//                atIndexPath indexPath: IndexPath) {
//    selectedCellIndexPaths.append(indexPath)
//  }
//
//  // MARK: Collection View
//
//  override func numberOfSections(in collectionView: UICollectionView) -> Int {
//    return sectionCount
//  }
//
//  override func collectionView(_ collectionView: UICollectionView,
//                               numberOfItemsInSection section: Int) -> Int {
//    return itemCount(at: section)
//  }
//
//  override func collectionView(_ collectionView: UICollectionView,
//                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    return cell(at: indexPath)
//  }
//  
//  override func collectionView(_ collectionView: UICollectionView,
//                               didSelectItemAt indexPath: IndexPath) {
//    didSelectItem(at: indexPath)
//  }
//  
//  // MARK: Fetched Controller
//  
//  @objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//    willChangeContent()
//  }
//  
//  @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                        didChange sectionInfo: NSFetchedResultsSectionInfo,
//                        atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//    didChangeSection(sectionIndex, withChangeType: type)
//  }
//  
//  @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                        didChange anObject: AnyObject, at indexPath: IndexPath?,
//                        for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//    didChangeObject(at: indexPath, withChangeType: type, newIndexPath: newIndexPath)
//  }
//  
//  @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//    didChangeContent()
//  }
//}
