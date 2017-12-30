//
//  YBSlantedCollectionViewLayoutTests.swift
//  YBSlantedCollectionViewLayoutTests
//
//  Created by Yassir Barchi on 10/03/2016.
//  Copyright © 2016 Yassir Barchi. All rights reserved.
//

import XCTest
@testable import YBSlantedCollectionViewLayout

class YBSlantedCollectionViewLayoutTests: XCTestCase {
    
    var verticalSlantedViewLayout: YBSlantedCollectionViewLayout!
    var collectionViewController: CollectionViewController!
    
    var horizontalSlantedViewLayout: YBSlantedCollectionViewLayout!
    var horizontalCollectionViewController: CollectionViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        verticalSlantedViewLayout = YBSlantedCollectionViewLayout()
        verticalSlantedViewLayout.itemSize = 225
        verticalSlantedViewLayout.slantingDelta = 50
        verticalSlantedViewLayout.lineSpacing = 0
        
        collectionViewController = CollectionViewController(collectionViewLayout: verticalSlantedViewLayout)
        collectionViewController.view.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        
        horizontalSlantedViewLayout = YBSlantedCollectionViewLayout()
        horizontalSlantedViewLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        horizontalSlantedViewLayout.lineSpacing = 3
        horizontalSlantedViewLayout.itemSize = 300
        horizontalSlantedViewLayout.slantingDirection = .downward
        horizontalCollectionViewController = CollectionViewController(collectionViewLayout: horizontalSlantedViewLayout)
        horizontalCollectionViewController.view.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
    }
    
    func testSlantedViewLayoutHasDefaultValues() {
        let defaultSlantedViewLayout = YBSlantedCollectionViewLayout()
        XCTAssertEqual(defaultSlantedViewLayout.slantingDelta, 50)
        XCTAssertEqual(defaultSlantedViewLayout.slantingDirection, .upward)
        XCTAssertEqual(defaultSlantedViewLayout.firstCellSlantingEnabled, true)
        XCTAssertEqual(defaultSlantedViewLayout.lastCellSlantingEnabled, true)
        XCTAssertEqual(defaultSlantedViewLayout.lineSpacing, 10)
        XCTAssertEqual(defaultSlantedViewLayout.scrollDirection, UICollectionViewScrollDirection.vertical)
        XCTAssertEqual(defaultSlantedViewLayout.itemSize, 0)
    }
    
    func testLayoutContentViewSizeUsesController() {
        collectionViewController.items = [0, 1, 2, 3, 5, 6, 7, 8, 9]
        collectionViewController.itemSize = 150
        collectionViewController.view.layoutIfNeeded()

        let verticalSlantedViewLayoutSize = self.verticalSlantedViewLayout.collectionViewContentSize
        let collectionViewControllerSize = self.collectionViewController.view.frame.size
        
        let size = collectionViewController.itemSize
        let lineSpicing = verticalSlantedViewLayout.lineSpacing
        let slantingDelta = CGFloat(verticalSlantedViewLayout.slantingDelta)
        
        let contentSize = CGFloat(collectionViewController.items.count) * (size! - slantingDelta + lineSpicing ) + slantingDelta - lineSpicing
        XCTAssertEqual(verticalSlantedViewLayoutSize.width, collectionViewControllerSize.width)
        XCTAssertEqual(verticalSlantedViewLayoutSize.height,  contentSize)
    }
    
    func testHorizontalLayoutContentViewSizeUsesController() {
        horizontalCollectionViewController.items = [0, 1, 2, 3, 5, 6, 7, 8, 9]
        horizontalCollectionViewController.view.layoutIfNeeded()
        
        let horizontalSlantedViewLayoutSize = horizontalSlantedViewLayout.collectionViewContentSize
        let collectionViewControllerSize = horizontalCollectionViewController.view.frame.size
        
        let size = horizontalSlantedViewLayout.itemSize
        let lineSpicing = horizontalSlantedViewLayout.lineSpacing
        let slantingDelta = CGFloat(horizontalSlantedViewLayout.slantingDelta)
        
        let contentSize = CGFloat(horizontalCollectionViewController.items.count) * (size - slantingDelta + lineSpicing ) + slantingDelta - lineSpicing
        XCTAssertEqual(horizontalSlantedViewLayoutSize.width, contentSize)
        XCTAssertEqual(horizontalSlantedViewLayoutSize.height,  collectionViewControllerSize.height)
    }

    func testLayoutContentViewSizeUsesItemSizeIfDelegateMethodIsNotImplemented() {
        collectionViewController.items = [0, 1, 2, 3, 5, 6, 7, 8, 9]
        collectionViewController.collectionView?.delegate = nil
        collectionViewController.view.layoutIfNeeded()
        
        let verticalSlantedViewLayoutSize = self.verticalSlantedViewLayout.collectionViewContentSize
        let collectionViewControllerSize = self.collectionViewController.view.frame.size
        
        let size = verticalSlantedViewLayout.itemSize
        let lineSpicing = verticalSlantedViewLayout.lineSpacing
        let slantingDelta = CGFloat(verticalSlantedViewLayout.slantingDelta)
        
        let contentSize = CGFloat(collectionViewController.items.count) * (size - slantingDelta + lineSpicing ) + slantingDelta - lineSpicing
        XCTAssertEqual(verticalSlantedViewLayoutSize.width, collectionViewControllerSize.width)
        XCTAssertEqual(verticalSlantedViewLayoutSize.height,  contentSize)
        
        collectionViewController.collectionView?.delegate = collectionViewController
    }

    
    func testLayoutHasSmoothScrolling() {
        let proposedOffset = verticalSlantedViewLayout.targetContentOffset(forProposedContentOffset: CGPoint(),
                                                                           withScrollingVelocity: CGPoint())
        XCTAssertEqual(proposedOffset.x, 0)
        XCTAssertEqual(proposedOffset.y, 0)
    }
    
    func testLayoutHasCachedLayoutAttributes() {
        collectionViewController.items = [0]
        collectionViewController.view.layoutIfNeeded()
        XCTAssertEqual(verticalSlantedViewLayout.cachedAttributes.count, 1);
    }
    
    func testLayoutAttributeIsCached() {
        collectionViewController.items = [0]
        collectionViewController.view.layoutIfNeeded()
        let attributes = verticalSlantedViewLayout.layoutAttributesForElements(in: CGRect())!
        XCTAssertEqual(verticalSlantedViewLayout.cachedAttributes, attributes)
    }
    
    func testLayoutHasLayoutAttributesAtIndexPath() {
        collectionViewController.items = [0, 1, 2]
        collectionViewController.view.layoutIfNeeded()
        let indexPath = IndexPath(item: 0, section: 0)
        let attribute = verticalSlantedViewLayout.layoutAttributesForItem(at: indexPath)
        XCTAssertEqual(verticalSlantedViewLayout.cachedAttributes[0], attribute)
    }
    
    func testLayoutShouldInvalidateLayoutForBoundsChange() {
        XCTAssertTrue(verticalSlantedViewLayout.shouldInvalidateLayout(forBoundsChange: CGRect()))
    }
}

