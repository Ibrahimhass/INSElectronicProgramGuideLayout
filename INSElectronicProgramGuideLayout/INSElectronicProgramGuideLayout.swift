//  Converted to Swift 5.2 by Swiftify v5.2.31636 - https://swiftify.com/
//
//  INSElectronicProgramGuideLayout.swift
//  INSElectronicProgramGuideLayout
//
//  Created by Michał Zaborowski on 29.09.2014.
//  Copyright (c) 2014 inspace.io. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

enum INSElectronicProgramGuideLayoutType : Int {
    case timeRowAboveDayColumn
    case dayColumnAboveTimeRow
}

@objc protocol INSElectronicProgramGuideLayoutDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView?, layout electronicProgramGuideLayout: INSElectronicProgramGuideLayout?, startTimeForItemAt indexPath: IndexPath?) -> Date?
    func collectionView(_ collectionView: UICollectionView?, layout electronicProgramGuideLayout: INSElectronicProgramGuideLayout?, endTimeForItemAt indexPath: IndexPath?) -> Date?
    func currentTime(for collectionView: UICollectionView?, layout collectionViewLayout: INSElectronicProgramGuideLayout?) -> Date?

    ///  By Default start and end date is calculated using collectionView:layout:startTimeForItemAtIndexPath: and collectionView:layout:endTimeForItemAtIndexPath:,
    ///  if you want to force layout timeline use these delegate methods.
    @objc optional func collectionView(_ collectionView: UICollectionView?, startTimeFor electronicProgramGuideLayout: INSElectronicProgramGuideLayout?) -> Date?
    @objc optional func collectionView(_ collectionView: UICollectionView?, endTimeForlayout electronicProgramGuideLayout: INSElectronicProgramGuideLayout?) -> Date?
}

@objc protocol INSElectronicProgramGuideLayoutDelegate: UICollectionViewDelegate {
    @objc optional func collectionView(_ collectionView: UICollectionView?, layout electronicProgramGuideLayout: INSElectronicProgramGuideLayout?, sizeForFloatingItemOverlayAt indexPath: IndexPath?) -> CGSize
}

@objcMembers
class INSElectronicProgramGuideLayout: UICollectionViewLayout {
    ///  Vertical space between sections (channels)
    var sectionGap: CGFloat = 0.0
    ///  Section size
    var sectionHeight: CGFloat = 0.0
    var sectionHeaderWidth: CGFloat = 0.0
    ///  Current time indicator and gridline size
    var currentTimeIndicatorSize = CGSize.zero
    var currentTimeVerticalGridlineWidth: CGFloat = 0.0
    ///  Current time indicator zIndex
    var currentTimeIndicatorShouldBeBehind = false
    ///  Gridlines size
    var horizontalGridlineHeight: CGFloat = 0.0
    var verticalGridlineWidth: CGFloat = 0.0
    ///  Hour width and hour header height
    var hourWidth: CGFloat = 0.0
    var hourHeaderHeight: CGFloat = 0.0
    ///  Default size to use for floating headers. If the delegate does not implement the collectionView:layout:sizeForFloatingItemOverlayAtIndexPath: method, the flow layout uses the value in this property to set the size of each floating header.
    var floatingItemOverlaySize = CGSize.zero
    /// Horizontal space between floating header and section.
    /// Default value is 10.0
    var floatingItemOffsetFromSection: CGFloat = 0.0
    /// Distances between the border and the layout content view.
    /// Default value is UIEdgeInsetsMake(0, 0, 0, 0)
    var contentMargin: UIEdgeInsets!
    ///  Margin between cells.
    ///  Default value is UIEdgeInsetsMake(0, 0, 0, 10)
    var cellMargin: UIEdgeInsets!
    var headerLayoutType: INSElectronicProgramGuideLayoutType!
    ///  Set to YES if you want to resize sticky background headers when UICollectionView bounces.
    var shouldResizeStickyHeaders = false
    ///  Set to YES if you want to use floting overlay to each cell. If set to YES you have to register supplementaryViewOfKind INSEPGLayoutElementKindFloatingItemOverlay.
    var shouldUseFloatingItemOverlay = false
    
    private weak var _dataSource: INSElectronicProgramGuideLayoutDataSource?
    weak var dataSource: INSElectronicProgramGuideLayoutDataSource? {
        get {
            return _dataSource
        }
        set(dataSource) {
            _dataSource = dataSource
            collectionView?.dataSource = (dataSource as? UICollectionViewDataSource)
        }
    }
    
    private weak var _delegate: INSElectronicProgramGuideLayoutDelegate?
    weak var delegate: INSElectronicProgramGuideLayoutDelegate? {
        get {
            return _delegate
        }
        set(delegate) {
            _delegate = delegate
            collectionView?.delegate = delegate
        }
    }
    
    ///  Returns the x-axis position on collection view content view for date.
    func xCoordinate(for date: NSDate?) -> CGFloat {
        print (collectionViewContentSize.width) // 44346.5
        let td = abs(CGFloat((latestDate()?.timeIntervalSince1970 ?? 0.0) - (date?.timeIntervalSince1970 ?? 0.0)) / 60.0) // 267468.1734828949
        print (td)
//        return  CGFloat(nearbyintf(Float(collectionViewContentSize.width - (CGFloat((abs(timeDiff)) / Float(60) * Float(minuteWidth))) - contentMargin.right))
//        )
        //41139.000000
        /*
         2020-05-21 17:20:06.199087+0530 INSElectronicProgramGuideLayout[3508:93285] 41139.000000
         (lldb) po ((fabs([self latestDate].timeIntervalSince1970 - date.timeIntervalSince1970)) / 60 * self.minuteWidth)
         3207.6666666666665

         (lldb) po self.minuteWidth
         10

         (lldb) po self.contentMargin.right
         0

         (lldb) po self.collectionViewContentSize.width
         44346.5

         (lldb) po 44346.5 - 3207.6666666666665 - 0
         41138.833333333336
         */
        
//        print (collectionViewContentSize.width - (td * minuteWidth) - contentMargin.right)
        return collectionViewContentSize.width - (td * minuteWidth) - contentMargin.right
    }
    
    /// Returns date for x-axis position on collection view content view.
    func date(forXCoordinate position: CGFloat) -> Date? {
        if position > collectionViewContentSize.width || position < 0 {
            return nil
        }
        
        let earliestDate = self.earliestDate()
        
        let timeInSeconds = position / minuteWidth * 60
        return earliestDate?.addingTimeInterval(TimeInterval(timeInSeconds))
    }
    
    func dateForHourHeader(at indexPath: IndexPath?) -> Date? {
        if let indexPath = indexPath {
            return cachedHours.object(forKey: indexPath as NSIndexPath) as Date?
        }
        return nil
    }
    
    func dateForHalfHourHeader(at indexPath: IndexPath?) -> Date? {
        if let indexPath = indexPath {
            return cachedHalfHours.object(forKey: indexPath as NSIndexPath) as Date?
        }
        return nil
    }
    
    ///  Scrolling to current time on timeline
    func scrollToCurrentTime(animated: Bool) {
        if (collectionView?.numberOfSections ?? 0) > 0 {
            print ((currentTimeVerticalGridlineAttributes?[IndexPath(item: 0, section: 0)] as AnyObject))
            let currentTimeHorizontalGridlineattributesFrame = ((currentTimeVerticalGridlineAttributes?[IndexPath(item: 0, section: 0)] as AnyObject).value(forKey: "frame") as? CGRect) ?? .zero
            var xOffset: CGFloat
            if !currentTimeHorizontalGridlineattributesFrame.equalTo(CGRect.zero) {
                xOffset = CGFloat(nearbyintf(Float(currentTimeHorizontalGridlineattributesFrame.minX - ((collectionView?.frame.width ?? 0.0) / 2.0))))
            } else {
                xOffset = 0.0
            }
            var contentOffset = CGPoint(x: xOffset, y: (collectionView?.contentOffset.y ?? 0.0) - (collectionView?.contentInset.top ?? 0.0))
            
            // Prevent the content offset from forcing the scroll view content off its bounds
            if contentOffset.y > ((collectionView?.contentSize.height ?? 0.0) - (collectionView?.frame.size.height ?? 0.0)) {
                contentOffset.y = (collectionView?.contentSize.height ?? 0.0) - (collectionView?.frame.size.height ?? 0.0)
            }
            if contentOffset.y < -(collectionView?.contentInset.top ?? 0.0) {
                contentOffset.y = -(collectionView?.contentInset.top ?? 0.0)
            }
            if contentOffset.x > ((collectionView?.contentSize.width ?? 0.0) - (collectionView?.frame.size.width ?? 0.0)) {
                contentOffset.x = (collectionView?.contentSize.width ?? 0.0) - (collectionView?.frame.size.width ?? 0.0)
            }
            if contentOffset.x < 0.0 {
                contentOffset.x = 0.0
            }
            
            collectionView?.setContentOffset(contentOffset, animated: animated)
        }
    }
    
    // Since a "reloadData" on the UICollectionView doesn't call "prepareForCollectionViewUpdates:", this method must be called first to flush the internal caches
    func invalidateLayoutCache() {
        needsToPopulateAttributesForAllSections = true
        
        // Invalidate cached Components
        cachedEarliestDate = nil
        cachedLatestDate = nil
        cachedCurrentDate = nil
        
        cachedEarliestDates?.removeAll()
        cachedLatestDates?.removeAll()
        
        cachedFloatingItemsOverlaySize?.removeAll()
        
        cachedHours.removeAllObjects()
        cachedHalfHours.removeAllObjects()
        
        cachedStartTimeDate.removeAllObjects()
        cachedEndTimeDate.removeAllObjects()
        cachedMaxSectionWidth = CGFloat.leastNormalMagnitude
        
        verticalGridlineAttributes?.removeAll()
        itemAttributes?.removeAll()
        floatingItemAttributes?.removeAll()
        sectionHeaderAttributes?.removeAll()
        sectionHeaderBackgroundAttributes?.removeAll()
        hourHeaderAttributes?.removeAll()
        halfHourHeaderAttributes?.removeAll()
        hourHeaderBackgroundAttributes?.removeAll()
        horizontalGridlineAttributes?.removeAll()
        currentTimeIndicatorAttributes?.removeAll()
        currentTimeVerticalGridlineAttributes?.removeAll()
        verticalHalfHourGridlineAttributes?.removeAll()
        allAttributes?.removeAll()
    }
    
    private var minuteTimer: Timer?
    
    private var minuteWidth: CGFloat {
        return hourWidth / 60.0
    }
    // Cache
    private var needsToPopulateAttributesForAllSections = false
    private var cachedEarliestDate: Date?
    private var cachedLatestDate: Date?
    private var cachedCurrentDate: NSDate?
    private var cachedFloatingItemsOverlaySize: [AnyHashable : Any]?
    private var cachedEarliestDates: [AnyHashable : Any]?
    private var cachedLatestDates: [AnyHashable : Any]?
    private var cachedHours = NSCache<NSIndexPath, NSDate>()
    private var cachedHalfHours = NSCache<NSIndexPath, NSDate>()
    private var cachedStartTimeDate = NSCache<NSIndexPath, NSDate>()
    private var cachedEndTimeDate = NSCache<NSIndexPath, NSDate>()
    private var cachedMaxSectionWidth: CGFloat = 0.0
    // Registered Decoration Classes
    private var registeredDecorationClasses: [AnyHashable : Any]?
    // Attributes
    private var allAttributes: [AnyHashable]?
    private var itemAttributes: [AnyHashable : Any]?
    private var floatingItemAttributes: [AnyHashable : Any]?
    private var sectionHeaderAttributes: [AnyHashable : Any]?
    private var sectionHeaderBackgroundAttributes: [AnyHashable : Any]?
    private var hourHeaderAttributes: [AnyHashable : Any]?
    private var halfHourHeaderAttributes: [AnyHashable : Any]?
    private var hourHeaderBackgroundAttributes: [AnyHashable : Any]?
    private var horizontalGridlineAttributes: [AnyHashable : Any]?
    private var verticalGridlineAttributes: [AnyHashable : Any]?
    private var verticalHalfHourGridlineAttributes: [AnyHashable : Any]?
    private var currentTimeIndicatorAttributes: [AnyHashable : Any]?
    private var currentTimeVerticalGridlineAttributes: [AnyHashable : Any]?
    
    // MARK: - <INSElectronicProgramGuideLayoutDataSource>
    
    // MARK: - <INSElectronicProgramGuideLayoutDelegate>
    
    // MARK: - Getters
    
    // MARK: - NSObject
    deinit {
        invalidateLayoutCache()
        minuteTimer?.invalidate()
        minuteTimer = nil
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        needsToPopulateAttributesForAllSections = true
        
        cachedMaxSectionWidth = CGFloat.leastNormalMagnitude
        cachedFloatingItemsOverlaySize = [:]
        
        registeredDecorationClasses = [:]
        
        allAttributes = []
        itemAttributes = [:]
        floatingItemAttributes = [:]
        sectionHeaderAttributes = [:]
        sectionHeaderBackgroundAttributes = [:]
        hourHeaderAttributes = [:]
        halfHourHeaderAttributes = [:]
        hourHeaderBackgroundAttributes = [:]
        verticalGridlineAttributes = [:]
        horizontalGridlineAttributes = [:]
        currentTimeIndicatorAttributes = [:]
        currentTimeVerticalGridlineAttributes = [:]
        verticalHalfHourGridlineAttributes = [:]
        
        shouldUseFloatingItemOverlay = true
        contentMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cellMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        sectionHeight = 60
        sectionHeaderWidth = 100
        hourHeaderHeight = 50
        hourWidth = 600
        currentTimeIndicatorSize = CGSize(width: sectionHeaderWidth, height: 10.0)
        currentTimeVerticalGridlineWidth = 1.0
        verticalGridlineWidth = (UIScreen.main.scale == 2.0) ? 0.5 : 1.0
        horizontalGridlineHeight = (UIScreen.main.scale == 2.0) ? 0.5 : 1.0
        sectionGap = 10
        floatingItemOverlaySize = CGSize(width: 0, height: sectionHeight)
        floatingItemOffsetFromSection = 10.0
        shouldResizeStickyHeaders = false
        // Set CurrentTime Behind cell
        currentTimeIndicatorShouldBeBehind = true
        
        headerLayoutType = .timeRowAboveDayColumn
        
        // Invalidate layout on minute ticks (to update the position of the current time indicator)
        let oneMinuteInFuture = Date().addingTimeInterval(60) as Date
        var components: DateComponents? = nil
        components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: oneMinuteInFuture)
        var nextMinuteBoundary: Date? = nil
        if let components = components {
            nextMinuteBoundary = Calendar.current.date(from: components)
        }
        
        // This needs to be a weak reference, otherwise we get a retain cycle
        let timerWeakTarget = INSTimerWeakTarget(target: self, selector: #selector(minuteTick(_:)))
        if let nextMinuteBoundary = nextMinuteBoundary {
            if let sel = timerWeakTarget?.fireSelector {
                minuteTimer = Timer(fireAt: nextMinuteBoundary, interval: 60, target: timerWeakTarget, selector: sel, userInfo: nil, repeats: true)
            }
        }
        if let minuteTimer = minuteTimer {
            RunLoop.current.add(minuteTimer, forMode: .default)
        }
    }
    
    // MARK: - Public
    
    // MARK: Minute Updates
    @objc func minuteTick(_ sender: Any?) {
        // Invalidate cached current date componets (since the minute's changed!)
        cachedCurrentDate = nil
        invalidateLayout()
    }
    
    // MARK: - UICollectionViewLayout
    
    func layoutAttributesForDecorationView(at indexPath: IndexPath?, ofKind kind: String?, withItemCache itemCache: inout [AnyHashable : Any]) -> UICollectionViewLayoutAttributes? {
        let indexPathKey = key(for: indexPath)
        var _layoutAttributes: UICollectionViewLayoutAttributes? = itemCache[indexPathKey] as? UICollectionViewLayoutAttributes
        if let indexPathKey = indexPathKey {
            if registeredDecorationClasses?[kind ?? ""] != nil && _layoutAttributes == nil {
                _layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: kind ?? "", with: indexPathKey)
                if let layoutAttributes = _layoutAttributes {
                    itemCache[indexPathKey] = layoutAttributes
                }
            }
        }
        return _layoutAttributes
    }
    
    func layoutAttributesForSupplementaryView(at indexPath: IndexPath?, ofKind kind: String?, withItemCache itemCache: inout [AnyHashable : Any]) -> UICollectionViewLayoutAttributes? {
        let indexPathKey = key(for: indexPath)
        var layoutAttributes: UICollectionViewLayoutAttributes?
        if let indexPathKey = indexPathKey {
            layoutAttributes = itemCache[indexPathKey] as? UICollectionViewLayoutAttributes
            if layoutAttributes == nil {
                layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind ?? "", with: indexPathKey)
                itemCache[indexPathKey] = layoutAttributes
            }
        }
        return layoutAttributes
    }
    
    func layoutAttributesForCell(at indexPath: IndexPath?, withItemCache itemCache: inout [AnyHashable : Any]) -> UICollectionViewLayoutAttributes? {
        let indexPathKey = key(for: indexPath)
        var layoutAttributes: UICollectionViewLayoutAttributes?
        layoutAttributes = itemCache[indexPathKey] as? UICollectionViewLayoutAttributes
        if let indexPathKey = indexPathKey {
            if layoutAttributes == nil {
                layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPathKey)
                itemCache[indexPathKey] = layoutAttributes
            }
        }
        return layoutAttributes
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        invalidateLayoutCache()
        
        // Update the layout with the new items
        prepare()
        
        super.prepare(forCollectionViewUpdates: updateItems)
    }
    
    override func finalizeCollectionViewUpdates() {
        // This is a hack to prevent the error detailed in :
        // http://stackoverflow.com/questions/12857301/uicollectionview-decoration-and-supplementary-views-can-not-be-moved
        // If this doesn't happen, whenever the collection view has batch updates performed on it, we get multiple instantiations of decoration classes
        for subview in collectionView?.subviews ?? [] {
            
            for decorationViewClass in registeredDecorationClasses?.values.compactMap({$0}) ?? [] {
                guard let decorationViewClass = decorationViewClass as? AnyClass else {
                    continue
                }
                if subview.isKind(of: decorationViewClass) {
                    subview.removeFromSuperview()
                }
            }
        }
        collectionView?.reloadData()
    }
    
    override func register(_ viewClass: AnyClass?, forDecorationViewOfKind decorationViewKind: String) {
        super.register(viewClass, forDecorationViewOfKind: decorationViewKind)
        registeredDecorationClasses?[decorationViewKind] = viewClass
    }
    
    override func register(_ nib: UINib?, forDecorationViewOfKind elementKind: String) {
        super.register(nib, forDecorationViewOfKind: elementKind)
        
        let topLevelObjects = nib?.instantiate(withOwner: nil, options: nil)
        
        assert(topLevelObjects?.count == 1 && (topLevelObjects?.first is UICollectionReusableView), "must contain exactly 1 top level object which is a UICollectionReusableView")
        
        registeredDecorationClasses?[elementKind] = type(of: topLevelObjects?.first)
    }
    
    override func prepare() {
        super.prepare()
        
        if needsToPopulateAttributesForAllSections {
            prepareSectionLayout(forSections: NSIndexSet(indexesIn: NSRange(location: 0, length: collectionView?.numberOfSections ?? 0)))
            needsToPopulateAttributesForAllSections = false
        }
        
        if (allAttributes?.count ?? 0) == 0 {
            if let all = itemAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = sectionHeaderAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = sectionHeaderBackgroundAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = hourHeaderBackgroundAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = hourHeaderAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = halfHourHeaderAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = verticalGridlineAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = horizontalGridlineAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = currentTimeIndicatorAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = verticalHalfHourGridlineAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = currentTimeVerticalGridlineAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
            if let all = floatingItemAttributes?.values.compactMap({$0}) as? [AnyHashable] {
                allAttributes?.append(contentsOf: all)
            }
        }
    }
    
    // MARK: - Preparing Layout Helpers
    func maximumSectionWidth() -> CGFloat {
        if cachedMaxSectionWidth != CGFloat.leastNormalMagnitude {
            return cachedMaxSectionWidth
        }
        
        //    CGFloat maxSectionWidth = self.sectionHeaderWidth + ([self latestDate].timeIntervalSince1970 - [self earliestDate].timeIntervalSince1970) / 60.0 * self.minuteWidth + self.contentMargin.left + self.contentMargin.right;

        //sectionHeaderWidth 110
        
        let maxSectionWidth: CGFloat = sectionHeaderWidth + (CGFloat((latestDate()?.timeIntervalSince1970 ?? 0.0) - (earliestDate()?.timeIntervalSince1970 ?? 0.0)) / 60.0) * minuteWidth + contentMargin.left + contentMargin.right
        
        cachedMaxSectionWidth = maxSectionWidth
        
        return maxSectionWidth
    }
    
    func minimumGridX() -> CGFloat {
        return sectionHeaderWidth + contentMargin.left
    }
    
    func minimumGridY() -> CGFloat {
        return hourHeaderHeight + contentMargin.top + (collectionView?.contentInset.top ?? 0.0)
    }
    
    // MARK: - Preparing Layout
    func prepareSectionLayout(forSections sectionIndexes: NSIndexSet?) {
        if collectionView?.numberOfSections == 0 {
            return
        }
        
        let needsToPopulateItemAttributes = (itemAttributes?.count ?? 0) == 0
        let needsToPopulateHorizontalGridlineAttributes = (horizontalGridlineAttributes?.count ?? 0) == 0
        
        prepareSectionHeaderBackgroundAttributes()
        prepareHourHeaderBackgroundAttributes()

        prepareCurrentIndicatorAttributes()

        prepareVerticalGridlineAttributes()
        
//        for section in sectionIndexes ?? NSIndexSet.init() {
//            self.prepareSectionAttributes(section, needsToPopulateItemAttributes: needsToPopulateItemAttributes)
//            if needsToPopulateHorizontalGridlineAttributes {
//                self.prepareHorizontalGridlineAttributes(forSection: section)
//            }
//        }
//
        sectionIndexes?.enumerate({ section, stop in
            self.prepareSectionAttributes(section, needsToPopulateItemAttributes: needsToPopulateItemAttributes)

            if needsToPopulateHorizontalGridlineAttributes {
                self.prepareHorizontalGridlineAttributes(forSection: section)
            }
        })
    }
    
    func prepareFloatingItemAttributesOverlay(forSection section: Int, sectionFrame rect: CGRect) {
        let xOffSet = CGFloat(collectionView?.contentOffset.x ?? 0.0)
        let floatingGridMinX = CGFloat(fmaxf(Float(xOffSet), Float(0.0))) + sectionHeaderWidth + floatingItemOffsetFromSection
        
        for item in 0..<(collectionView?.numberOfItems(inSection: section) ?? 0) {
            
            let floatingItemIndexPath = IndexPath(row: item, section: section)
            
            let itemEndTime = endDate(for: floatingItemIndexPath)
            
            if (itemEndTime as NSDate?)?.ins_isLaterThan(latestDate()) != false || (itemEndTime as NSDate?)?.ins_isEarlierThan(earliestDate()) != false {
                continue
            }
            
            let itemAttributes = self.itemAttributes?[floatingItemIndexPath] as? UICollectionViewLayoutAttributes
            var itemAttributesFrame = itemAttributes?.frame ?? .zero
            itemAttributesFrame.origin.y -= cellMargin.top
            
            var _floatingItemAttributes: UICollectionViewLayoutAttributes? = nil
            _floatingItemAttributes = layoutAttributesForSupplementaryView(at: floatingItemIndexPath, ofKind: INSEPGLayoutElementKindFloatingItemOverlay, withItemCache: &(floatingItemAttributes)!)
            
            let floatingItemSize = floatingItemOverlaySize(for: floatingItemIndexPath)
            
            if (floatingItemSize.width >= itemAttributesFrame.size.width) {
                _floatingItemAttributes?.frame = itemAttributesFrame
            } else {
                // Items on the right side of sections
                if (itemAttributesFrame.origin.x >= floatingGridMinX) {
                    _floatingItemAttributes?.frame = CGRect.init(x: itemAttributesFrame.origin.x, y: itemAttributesFrame.origin.y, width: floatingItemSize.width, height: floatingItemSize.height)
                } else {
                    let floatingSpace = itemAttributesFrame.size.width - floatingItemSize.width
                    
                    _floatingItemAttributes?.frame = CGRect.init(x: itemAttributesFrame.origin.x + floatingSpace, y: itemAttributesFrame.origin.y, width: floatingItemSize.width, height: floatingItemSize.height)
                    
                    //Floating
                    if (floatingGridMinX <= (_floatingItemAttributes?.frame.origin.x ?? 0.0) && floatingGridMinX >= itemAttributesFrame.origin.x) {
                        
                        _floatingItemAttributes?.frame = CGRect.init(x: floatingGridMinX, y: _floatingItemAttributes?.frame.origin.y ?? 0.0, width: floatingItemSize.width, height: floatingItemSize.height)
                    }
                }
            }
            _floatingItemAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindFloatingItemOverlay, floating: true))
        }
    }
    
    func prepareItemAttributes(forSection section: Int, sectionFrame rect: CGRect) {
        for item in 0 ..< (collectionView?.numberOfItems(inSection: section) ?? 0) {
            let itemIndexPath = IndexPath(item: item, section: section)
            
            let itemEndTime = endDate(for: itemIndexPath)
            
            if (itemEndTime as NSDate?)?.ins_isLaterThan(latestDate()) != false || (itemEndTime as NSDate?)?.ins_isEarlierThan(earliestDate()) != false {
                continue
            }
            
            let itemStartTime = startDate(for: itemIndexPath)
            
            let itemStartTimePositionX = xCoordinate(for: itemStartTime as NSDate?)
            let itemEndTimePositionX = xCoordinate(for: itemEndTime as NSDate?)
            let itemWidth = itemEndTimePositionX - itemStartTimePositionX
            
            var _itemAttributes: UICollectionViewLayoutAttributes? = nil
            _itemAttributes = layoutAttributesForCell(at: itemIndexPath, withItemCache: &(itemAttributes)!)
            
            _itemAttributes?.frame = CGRect(x: itemStartTimePositionX + cellMargin.left, y: rect.origin.y + cellMargin.top, width: itemWidth - cellMargin.left - cellMargin.right, height: rect.size.height - cellMargin.top - cellMargin.bottom)
            _itemAttributes?.zIndex = Int(zIndex(forElementKind: nil))
        }
    }
    
    func prepareSectionAttributes(_ section: Int, needsToPopulateItemAttributes: Bool) {
        let sectionMinY = hourHeaderHeight + contentMargin.top
        
        let sectionMinX = shouldResizeStickyHeaders ? CGFloat(fmaxf(Float(collectionView?.contentOffset.x ?? 0.0), Float(0.0))) : collectionView?.contentOffset.x ?? 0.0
        
        let sectionY = sectionMinY + ((sectionHeight + sectionGap) * CGFloat(section))
        let sectionIndexPath = IndexPath(item: 0, section: section)
        let sectionAttributes = layoutAttributesForSupplementaryView(at: sectionIndexPath, ofKind: INSEPGLayoutElementKindSectionHeader, withItemCache: &sectionHeaderAttributes!)
        sectionAttributes?.frame = CGRect(x: sectionMinX, y: sectionY, width: sectionHeaderWidth, height: sectionHeight)
        sectionAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindSectionHeader, floating: true))
        
        if needsToPopulateItemAttributes {
            prepareItemAttributes(forSection: section, sectionFrame: sectionAttributes?.frame ?? CGRect.zero)
        }
        if shouldUseFloatingItemOverlay {
            prepareFloatingItemAttributesOverlay(forSection: section, sectionFrame: sectionAttributes?.frame ?? CGRect.zero)
        }
    }
    
    func prepareHorizontalGridlineAttributes(forSection section: Int) {
        let gridMinY = hourHeaderHeight + contentMargin.top
        let gridWidth = collectionViewContentSize.width - contentMargin.right
        
        let horizontalGridlineMinX = CGFloat(fmaxf(Float(collectionView?.contentOffset.x ?? 0.0), Float(0.0))) - (collectionView?.frame.size.width ?? 0.0) + sectionHeaderWidth
        
        var horizontalGridlineMinY: CGFloat = gridMinY + ((sectionHeight + sectionGap) * CGFloat(section)) - CGFloat(nearbyintf(Float(sectionGap / 2)))
        
        if section <= 0 {
            return
        }
        
        horizontalGridlineMinY -= horizontalGridlineHeight / 2
        
        let horizontalGridlineIndexPath = IndexPath(item: section, section: 0)
        var _horizontalGridlineAttributes: UICollectionViewLayoutAttributes? = nil
        
        _horizontalGridlineAttributes = layoutAttributesForDecorationView(at: horizontalGridlineIndexPath, ofKind: INSEPGLayoutElementKindHorizontalGridline, withItemCache: &(horizontalGridlineAttributes)!)
        
        
        _horizontalGridlineAttributes?.frame = CGRect(x: horizontalGridlineMinX, y: horizontalGridlineMinY, width: gridWidth + CGFloat(abs(Float(horizontalGridlineMinX))), height: horizontalGridlineHeight)
        _horizontalGridlineAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindHorizontalGridline))
    }
    
    func prepareVerticalGridlineAttributes() {
        let gridMinX = minimumGridX()
        var gridMaxWidth = maximumSectionWidth() - gridMinX
        let hourWidth = self.hourWidth
        
        let hourMinY = shouldResizeStickyHeaders ? CGFloat(fmaxf(Float((collectionView?.contentOffset.y ?? 0.0) + (collectionView?.contentInset.top ?? 0.0)), 0.0)) : (collectionView?.contentOffset.y ?? 0.0) + (collectionView?.contentInset.top ?? 0.0)
        
        let currentTimeVerticalGridlineMinY = shouldResizeStickyHeaders ? CGFloat(fmaxf(Float(hourHeaderHeight), Float((collectionView?.contentOffset.y ?? 0.0) + minimumGridY()))) : (collectionView?.contentOffset.y ?? 0.0) + minimumGridY() - contentMargin.top
        let gridHeight = collectionViewContentSize.height - currentTimeVerticalGridlineMinY - contentMargin.bottom + (collectionView?.contentOffset.y ?? 0.0)
        
        let startDate = (earliestDate() as NSDate?)?.ins_dateWithoutMinutesAndSeconds()
        let startDatePosition = xCoordinate(for: startDate as NSDate?)
        
        var verticalGridlineIndex = 0
        var hourX = startDatePosition
        while hourX <= gridMaxWidth {
            let verticalGridlineIndexPath = IndexPath(item: verticalGridlineIndex, section: 0)
            var _verticalGridlineAttributes: UICollectionViewLayoutAttributes? = nil
            
            _verticalGridlineAttributes = layoutAttributesForDecorationView(at: verticalGridlineIndexPath, ofKind: INSEPGLayoutElementKindVerticalGridline, withItemCache: &(verticalGridlineAttributes)!)
            
            _verticalGridlineAttributes?.frame = CGRect(x: hourX, y: currentTimeVerticalGridlineMinY, width: verticalGridlineWidth, height: gridHeight)
            _verticalGridlineAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindVerticalGridline))
            
            let hourHeaderIndexPath = IndexPath(item: verticalGridlineIndex, section: 0)
            
            let hourTimeInterval: CGFloat = 3600
            if cachedHours.object(forKey: hourHeaderIndexPath as NSIndexPath) == nil {
                if let date = startDate?.addingTimeInterval(TimeInterval(hourTimeInterval * CGFloat(verticalGridlineIndex))) {
                    cachedHours.setObject(date as NSDate, forKey: hourHeaderIndexPath as NSIndexPath)
                }
            }
            
            var _hourHeaderAttributes: UICollectionViewLayoutAttributes? = nil
            _hourHeaderAttributes = layoutAttributesForSupplementaryView(at: hourHeaderIndexPath, ofKind: INSEPGLayoutElementKindHourHeader, withItemCache: &(hourHeaderAttributes)!)
            let hourHeaderMinX: CGFloat = hourX - CGFloat(nearbyintf(Float(self.hourWidth / 2.0)))
            
            
            _hourHeaderAttributes?.frame = CGRect.init(x: hourHeaderMinX, y: hourMinY, width: self.hourWidth, height: hourHeaderHeight)
            _hourHeaderAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindHourHeader, floating: true))
            
            verticalGridlineIndex += 1
            hourX += hourWidth
        }
        
        var verticalHalfHourGridlineIndex = 0
        var halfHourX = startDatePosition + hourWidth / 2
        while halfHourX <= gridMaxWidth + hourWidth / 2 {
            let verticalHalfHourGridlineIndexPath = IndexPath(item: verticalHalfHourGridlineIndex, section: 0)
            var _verticalHalfHourGridlineAttributes: UICollectionViewLayoutAttributes? = nil
            _verticalHalfHourGridlineAttributes = layoutAttributesForDecorationView(at: verticalHalfHourGridlineIndexPath, ofKind: INSEPGLayoutElementKindHalfHourVerticalGridline, withItemCache: &(verticalHalfHourGridlineAttributes)!)
            
            _verticalHalfHourGridlineAttributes?.frame = CGRect(x: halfHourX, y: currentTimeVerticalGridlineMinY, width: verticalGridlineWidth, height: gridHeight)
            _verticalHalfHourGridlineAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindHalfHourVerticalGridline))
            
            let halfHourHeaderIndexPath = IndexPath(item: verticalHalfHourGridlineIndex, section: 0)
            
            let hourTimeInterval: CGFloat = 3600
            if cachedHalfHours.object(forKey: halfHourHeaderIndexPath as NSIndexPath) == nil {
                if let date = startDate?.addingTimeInterval(TimeInterval(hourTimeInterval * CGFloat(verticalHalfHourGridlineIndex) + hourTimeInterval / 2)) {
                    cachedHalfHours.setObject(date as NSDate, forKey: halfHourHeaderIndexPath as NSIndexPath)
                }
            }
            
            var _halfHourHeaderAttributes: UICollectionViewLayoutAttributes? = nil
            _halfHourHeaderAttributes = layoutAttributesForSupplementaryView(at: halfHourHeaderIndexPath, ofKind: INSEPGLayoutElementKindHalfHourHeader, withItemCache: &(halfHourHeaderAttributes)!)
            let hourHeaderMinX: CGFloat = halfHourX - CGFloat(nearbyintf(Float(self.hourWidth / 2.0)))
            
            _halfHourHeaderAttributes?.frame = CGRect.init(x: hourHeaderMinX, y: hourMinY, width: self.hourWidth, height: hourHeaderHeight)
            _halfHourHeaderAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindHalfHourHeader, floating: true))
            
            verticalHalfHourGridlineIndex += 1
            halfHourX += hourWidth
        }
    }
    
    func prepareCurrentIndicatorAttributes() {
        print ("prepareCurrentIndicatorAttributes()")
        let currentTimeIndicatorIndexPath = IndexPath(row: 0, section: 0)
        var currentTimeIndicatorAttributes: UICollectionViewLayoutAttributes? = nil
        currentTimeIndicatorAttributes = layoutAttributesForDecorationView(at: currentTimeIndicatorIndexPath, ofKind: INSEPGLayoutElementKindCurrentTimeIndicator, withItemCache: &(self.currentTimeIndicatorAttributes)!)
        
        let currentTimeHorizontalGridlineAttributes = layoutAttributesForDecorationView(at: currentTimeIndicatorIndexPath, ofKind: INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline, withItemCache: &(currentTimeVerticalGridlineAttributes)!)
        
        let currentDate = self.currentDate()
        let currentTimeIndicatorVisible = currentDate?.ins_isLaterThanOrEqual(to: earliestDate()) != false && currentDate?.ins_isEarlierThan(latestDate()) != false
        currentTimeIndicatorAttributes?.isHidden = !currentTimeIndicatorVisible
        currentTimeHorizontalGridlineAttributes?.isHidden = !currentTimeIndicatorVisible
        
        if currentTimeIndicatorVisible {
            
            let xPositionToCurrentDate = xCoordinate(for: currentDate)
            
            let currentTimeIndicatorMinX = xPositionToCurrentDate - CGFloat(nearbyintf(Float(currentTimeIndicatorSize.width / 2.0)))
            let v1 = CGFloat(fmaxf(Float(collectionView?.contentOffset.y ?? 0.0), 0.0))
            let v2 = (collectionView?.contentOffset.y ?? 0.0) + (hourHeaderHeight - currentTimeIndicatorSize.height)
            let v3 = (collectionView?.contentInset.top ?? 0.0)
            
            let currentTimeIndicatorMinY = (shouldResizeStickyHeaders ? v1 : v2) + v3
            
            currentTimeIndicatorAttributes?.frame = CGRect.init(x: currentTimeIndicatorMinX, y: currentTimeIndicatorMinY, width: currentTimeIndicatorSize.width, height: currentTimeIndicatorSize.height)
            currentTimeIndicatorAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindCurrentTimeIndicator, floating: true))
            
            let currentTimeVerticalGridlineMinY = shouldResizeStickyHeaders ? CGFloat(fmaxf(Float(hourHeaderHeight), Float((collectionView?.contentOffset.y ?? 0.0) + minimumGridY()))) : (collectionView?.contentOffset.y ?? 0.0) + minimumGridY()
            
            let gridHeight = collectionViewContentSize.height + currentTimeVerticalGridlineMinY
            
            currentTimeHorizontalGridlineAttributes?.frame = CGRect.init(x: xPositionToCurrentDate - currentTimeVerticalGridlineWidth / 2, y: currentTimeVerticalGridlineMinY, width: currentTimeVerticalGridlineWidth, height: gridHeight)
            currentTimeHorizontalGridlineAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline))
        }
    }
    
    func prepareSectionHeaderBackgroundAttributes() {
        
        let sectionHeaderMinX = shouldResizeStickyHeaders ? fmaxf(Float(collectionView?.contentOffset.x ?? 0.0), Float(0.0)) : Float(collectionView?.contentOffset.x ?? 0.0)
        
        let sectionHeaderBackgroundIndexPath = IndexPath(row: 0, section: 0)
        var sectionHeaderBackgroundAttributes: UICollectionViewLayoutAttributes? = nil
        
        sectionHeaderBackgroundAttributes = layoutAttributesForDecorationView(at: sectionHeaderBackgroundIndexPath, ofKind: INSEPGLayoutElementKindSectionHeaderBackground, withItemCache: &(self.sectionHeaderBackgroundAttributes)!)
        
        let sectionHeaderBackgroundHeight = (collectionView?.frame.size.height ?? 0.0) - (collectionView?.contentInset.top ?? 0.0)
        let sectionHeaderBackgroundWidth = collectionView?.frame.size.width ?? 0.0
        let sectionHeaderBackgroundMinX = CGFloat(sectionHeaderMinX) - sectionHeaderBackgroundWidth + sectionHeaderWidth
        
        let sectionHeaderBackgroundMinY = (collectionView?.contentOffset.y ?? 0.0) + (collectionView?.contentInset.top ?? 0.0)
        sectionHeaderBackgroundAttributes?.frame = CGRect(x: sectionHeaderBackgroundMinX, y: sectionHeaderBackgroundMinY, width: sectionHeaderBackgroundWidth, height: sectionHeaderBackgroundHeight)
        
        sectionHeaderBackgroundAttributes?.isHidden = false
        sectionHeaderBackgroundAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindSectionHeaderBackground, floating: true))
    }
    
    func prepareHourHeaderBackgroundAttributes() {
        let hourHeaderBackgroundIndexPath = IndexPath(row: 0, section: 0)
        var hourHeaderBackgroundAttributes: UICollectionViewLayoutAttributes? = nil
        hourHeaderBackgroundAttributes = layoutAttributesForDecorationView(at: hourHeaderBackgroundIndexPath, ofKind: INSEPGLayoutElementKindHourHeaderBackground, withItemCache: &(self.hourHeaderBackgroundAttributes)!)
        var hourHeaderBackgroundHeight = (hourHeaderHeight + CGFloat((((collectionView?.contentOffset.y ?? 0.0) < 0.0) ? abs(Float(collectionView?.contentOffset.y ?? 0.0)) : 0.0))) - (collectionView?.contentInset.top ?? 0.0)
        if !shouldResizeStickyHeaders || hourHeaderHeight >= hourHeaderBackgroundHeight {
            hourHeaderBackgroundHeight = hourHeaderHeight
        }
        hourHeaderBackgroundAttributes?.frame = CGRect.init(x: collectionView?.contentOffset.x ?? 0.0, y: (collectionView?.contentOffset.y ?? 0.0) + (collectionView?.contentInset.top ?? 0.0), width: collectionView?.frame.size.width ?? 0.0, height: hourHeaderBackgroundHeight)
        hourHeaderBackgroundAttributes?.isHidden = false
        hourHeaderBackgroundAttributes?.zIndex = Int(zIndex(forElementKind: INSEPGLayoutElementKindHourHeaderBackground, floating: true))
    }
    
    // MARK: - Layout
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let indexPathKey = key(for: indexPath)
        if let indexPathKey = indexPathKey {
            return itemAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
        }
        return nil
    }
    
    override func layoutAttributesForSupplementaryView(ofKind kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let indexPathKey = key(for: indexPath)
        
        if kind == INSEPGLayoutElementKindSectionHeader {
            if let indexPathKey = indexPathKey {
                return sectionHeaderAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        } else if kind == INSEPGLayoutElementKindHourHeader {
            if let indexPathKey = indexPathKey {
                return hourHeaderAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        } else if kind == INSEPGLayoutElementKindHalfHourHeader {
            if let indexPathKey = indexPathKey {
                return halfHourHeaderAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        } else if kind == INSEPGLayoutElementKindFloatingItemOverlay {
            if let indexPathKey = indexPathKey {
                return floatingItemAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        }
        
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind decorationViewKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let indexPathKey = key(for: indexPath)
        
        if decorationViewKind == INSEPGLayoutElementKindCurrentTimeIndicator {
            if let indexPathKey = indexPathKey {
                return currentTimeIndicatorAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        } else if decorationViewKind == INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline {
            if let indexPathKey = indexPathKey {
                return currentTimeVerticalGridlineAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        } else if decorationViewKind == INSEPGLayoutElementKindVerticalGridline {
            if let indexPathKey = indexPathKey {
                return verticalGridlineAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        } else if decorationViewKind == INSEPGLayoutElementKindHorizontalGridline {
            if let indexPathKey = indexPathKey {
                return horizontalGridlineAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        } else if decorationViewKind == INSEPGLayoutElementKindHourHeaderBackground {
            if let indexPathKey = indexPathKey {
                return hourHeaderBackgroundAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        } else if decorationViewKind == INSEPGLayoutElementKindSectionHeaderBackground {
            if let indexPathKey = indexPathKey {
                return hourHeaderBackgroundAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        } else if decorationViewKind == INSEPGLayoutElementKindHalfHourVerticalGridline {
            if let indexPathKey = indexPathKey {
                return verticalHalfHourGridlineAttributes?[indexPathKey] as? UICollectionViewLayoutAttributes
            }
            return nil
        }
        return nil
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleSections = NSMutableIndexSet()
        
        (NSIndexSet(indexesIn: NSRange(location: 0, length: collectionView?.numberOfSections ?? 0))).enumerate({ section, stop in
            let sectionRect = self.rect(forSection: section)
            if sectionRect.intersects(rect) {
                visibleSections.add(section)
            }
        })
        
        // Update layout for only the visible sections
        prepareSectionLayout(forSections: visibleSections)
        // Return the visible attributes (rect intersection)
        return (allAttributes as NSArray?)?.filtered(using: NSPredicate(block: { layoutAttributes, bindings in
            return ((layoutAttributes as AnyObject?)?.value?(forKey: "frame") as? CGRect)?.intersects(rect) != false
            //layoutAttributes?.frame.intersects(rect) != false
        })) as? [UICollectionViewLayoutAttributes]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Required for sticky headers
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        let width = maximumSectionWidth()
        let height = hourHeaderHeight + CGFloat((sectionHeight + sectionGap) * CGFloat(collectionView?.numberOfSections ?? 0)) + contentMargin.top + contentMargin.bottom - sectionGap
        return CGSize(width: width >= (collectionView?.frame.size.width ?? 0.0) ? width : collectionView?.frame.size.width ?? 0.0, height: height >= (collectionView?.frame.size.height ?? 0.0) ? height : collectionView?.frame.size.height ?? 0.0)
    }
    
    // MARK: Section Sizing
    func rect(forSection section: Int) -> CGRect {
        let sectionHeight = self.sectionHeight
        let sectionY = contentMargin.top + hourHeaderHeight + ((sectionHeight + sectionGap) * CGFloat(section))
        return CGRect(x: 0.0, y: sectionY, width: collectionViewContentSize.width, height: sectionHeight)
    }
    
    // MARK: Z Index
    func zIndex(forElementKind elementKind: String?) -> CGFloat {
        return zIndex(forElementKind: elementKind, floating: false)
    }
    
    func zIndex(forElementKind elementKind: String?, floating: Bool) -> CGFloat {
        if elementKind == INSEPGLayoutElementKindCurrentTimeIndicator {
            print ("elementKind == INSEPGLayoutElementKindCurrentTimeIndicator")
            print (CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 9.0 : 4.0) : (floating ? 7.0 : 2.0)))
            print ("=============================")
            return CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 9.0 : 4.0) : (floating ? 7.0 : 2.0))
        } else if elementKind == INSEPGLayoutElementKindHourHeader || elementKind == INSEPGLayoutElementKindHalfHourHeader {
            print ("elementKind == INSEPGLayoutElementKindHourHeader || elementKind == INSEPGLayoutElementKindHalfHourHeader")
            print (CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 8.0 : 3.0) : (floating ? 6.0 : 1.0)))
            print ("=============================")
            return CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 8.0 : 3.0) : (floating ? 6.0 : 1.0))
        } else if elementKind == INSEPGLayoutElementKindHourHeaderBackground {
            print ("elementKind == INSEPGLayoutElementKindHourHeaderBackground")
            print (CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 7.0 : 2.0) : (floating ? 5.0 : 0.0)))
            print ("=============================")
            return CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 7.0 : 2.0) : (floating ? 5.0 : 0.0))
        } else if elementKind == INSEPGLayoutElementKindSectionHeader {
            print ("elementKind == INSEPGLayoutElementKindSectionHeader")
            print (CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 6.0 : 1.0) : (floating ? 9.0 : 4.0)))
            print ("=============================")
            return CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 6.0 : 1.0) : (floating ? 9.0 : 4.0))
        } else if elementKind == INSEPGLayoutElementKindSectionHeaderBackground {
            print ("elementKind == INSEPGLayoutElementKindSectionHeaderBackground")
            print (CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 5.0 : 0.0) : (floating ? 8.0 : 3.0)))
            print ("=============================")
            // 1005.0
            return CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 5.0 : 0.0) : (floating ? 8.0 : 3.0))
        } else if elementKind == nil {
            print ("elementKind == nil")
            print (INSEPGLayoutMinCellZ)
            print ("=============================")
            return CGFloat(INSEPGLayoutMinCellZ)
        } else if elementKind == INSEPGLayoutElementKindFloatingItemOverlay {
            // 101.5
            print ("elementKind == INSEPGLayoutElementKindFloatingItemOverlay")
            print (CGFloat(INSEPGLayoutMinCellZ) + 1.0)
            print ("=============================")
            return CGFloat(INSEPGLayoutMinCellZ) + 1.0
        } else if elementKind == INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline {
            if currentTimeIndicatorShouldBeBehind {
                print ("elementKind == INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline")
                print (CGFloat(INSEPGLayoutMinBackgroundZ) + 2.0)
                print ("=============================")
                return CGFloat(INSEPGLayoutMinBackgroundZ) + 2.0
            }
            // Place currentTimeGridLine juste behind Section Header and above cell
            print ("Place currentTimeGridLine juste behind Section Header and above cell")
            CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 5.9 : 0.9) : (floating ? 8.9 : 3.9))
            print ("=============================")
            return CGFloat(INSEPGLayoutMinOverlayZ) + ((headerLayoutType == .timeRowAboveDayColumn) ? (floating ? 5.9 : 0.9) : (floating ? 8.9 : 3.9))
        } else if elementKind == INSEPGLayoutElementKindVerticalGridline || elementKind == INSEPGLayoutElementKindHalfHourVerticalGridline {
            print ("elementKind == INSEPGLayoutElementKindVerticalGridline || elementKind == INSEPGLayoutElementKindHalfHourVerticalGridline")
            print (CGFloat(INSEPGLayoutMinBackgroundZ) + 1.0)
            print ("=============================")
            return CGFloat(INSEPGLayoutMinBackgroundZ) + 1.0
        } else if elementKind == INSEPGLayoutElementKindHorizontalGridline {
            print ("elementKind == INSEPGLayoutElementKindHorizontalGridline")
            print (CGFloat(INSEPGLayoutMinBackgroundZ))
            print ("=============================")
            return CGFloat(INSEPGLayoutMinBackgroundZ)
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: - Dates
    func earliestDate() -> Date? {
        if cachedEarliestDate != nil {
            return cachedEarliestDate
        }
        var earliestDate: Date? = nil
        
        if dataSource?.responds(to: #selector(INSElectronicProgramGuideLayoutDataSource.collectionView(_:startTimeFor:))) ?? false {
            earliestDate = dataSource?.collectionView?(collectionView, startTimeFor: self)
        } else {
            for section in 0 ..< (collectionView?.numberOfSections ?? 0) {
                let earliestDateForSection = self.earliestDate(forSection: section)
                if earliestDateForSection != nil {
                    if earliestDate == nil {
                        earliestDate = earliestDateForSection
                    } else if (earliestDateForSection as NSDate?)?.ins_isEarlierThan(earliestDate) != false {
                        earliestDate = earliestDateForSection
                    }
                }
            }
        }
        //2020-05-13 11:08:18 +0000
        if earliestDate != nil {
            cachedEarliestDate = earliestDate
            return cachedEarliestDate
        }
        
        return Date()
    }
    
    /*
     (lldb) po [self earliestDate].timeIntervalSince1970
     1589357049.1734829
     */
    
    func earliestDate(forSection section: Int) -> Date? {
        if cachedEarliestDates?[NSNumber(value: section)] != nil {
            return cachedEarliestDates?[NSNumber(value: section)] as? Date
        }
        
        var earliestDate: Date? = nil
        
        if dataSource?.responds(to: #selector(INSElectronicProgramGuideLayoutDataSource.collectionView(_:startTimeFor:))) ?? false {
            earliestDate = dataSource?.collectionView?(collectionView, startTimeFor: self)
        } else {
            for item in 0..<(collectionView?.numberOfItems(inSection: section) ?? 0) {
                let indexPath = IndexPath(item: item, section: section)
                let itemStartDate = startDate(for: indexPath)
                if itemStartDate != nil {
                    if earliestDate == nil {
                        earliestDate = itemStartDate
                    } else if (itemStartDate as NSDate?)?.ins_isEarlierThan(earliestDate) != false {
                        earliestDate = itemStartDate
                    }
                }
            }
        }
        
        if earliestDate != nil {
            cachedEarliestDates?[NSNumber(value: section)] = earliestDate
            return earliestDate
        }
        
        return nil
    }
    
    /*
     (lldb) po [self latestDate].timeIntervalSince1970
     1589622468.1734829
     */
    
    func latestDate() -> Date? {
        if cachedLatestDate != nil {
            return cachedLatestDate
        }
        var latestDate: Date? = nil
        
        if dataSource?.responds(to: #selector(INSElectronicProgramGuideLayoutDataSource.collectionView(_:endTimeForlayout:))) ?? false {
            latestDate = dataSource?.collectionView?(collectionView, endTimeForlayout: self)
        } else {
            for section in 0 ..< (collectionView?.numberOfSections ?? 0) {
                let latestDateForSection = self.latestDate(forSection: section)
                //2020-05-16 09:47:48 +0000
                if latestDateForSection != nil {
                    if latestDate == nil {
                        latestDate = latestDateForSection
                    } else if (latestDateForSection as NSDate?)?.ins_isLaterThan(latestDate) ?? false {
                        latestDate = latestDateForSection
                    }
                }
            }
        }
        //2020-05-16 09:47:48 +0000
        if latestDate != nil {
            cachedLatestDate = latestDate
            return cachedLatestDate
        }
        
        return Date()
    }
    
    func latestDate(forSection section: Int) -> Date? {
        if cachedLatestDates?[NSNumber(value: section)] != nil {
            return cachedLatestDates?[NSNumber(value: section)] as? Date
        }
        
        var latestDate: Date? = nil
        
        if dataSource?.responds(to: #selector(INSElectronicProgramGuideLayoutDataSource.collectionView(_:endTimeForlayout:))) ?? false {
            latestDate = dataSource?.collectionView?(collectionView, endTimeForlayout: self)
        } else {
            for item in 0 ..< (collectionView?.numberOfItems(inSection: section) ?? 0) {
                let indexPath = IndexPath(item: item, section: section)
                let itemEndDate = endDate(for: indexPath)
                if (itemEndDate != nil && (itemEndDate as NSDate?)?.ins_isLaterThan(latestDate) != nil) || latestDate == nil {
                    latestDate = itemEndDate
                }
            }
        }
        
        if latestDate != nil {
            if let latestDate = latestDate {
                cachedLatestDates?[NSNumber(value: section)] = latestDate
            }
            return latestDate
        }
        
        return nil
    }
    
    // MARK: Delegate Wrappers
    func startDate(for indexPath: IndexPath?) -> Date? {
        let indexPathKey = key(for: indexPath)
        
        if let indexPathKey = indexPathKey {
            if let date = cachedStartTimeDate.object(forKey: indexPathKey as NSIndexPath) {
                return date as Date
            }
        }
        
        let date = dataSource?.collectionView(collectionView, layout: self, startTimeForItemAt: indexPathKey)
        
        if let date = date, let indexPathKey = indexPathKey {
            cachedStartTimeDate.setObject(date as NSDate, forKey: indexPathKey as NSIndexPath)
        }
        return date
    }
    
    func endDate(for indexPath: IndexPath?) -> Date? {
        let indexPathKey = key(for: indexPath)
        
        if let indexPathKey = indexPathKey {
//            print (indexPathKey)
            if let date = cachedEndTimeDate.object(forKey: indexPathKey as NSIndexPath) {
                return date as Date
            }
        }
        
        let date = dataSource?.collectionView(collectionView, layout: self, endTimeForItemAt: indexPathKey)
        
        if let date = date, let indexPathKey = indexPathKey {
            cachedEndTimeDate.setObject(date as NSDate, forKey: indexPathKey as NSIndexPath)
        }
        return date
    }
    
    func currentDate() -> NSDate? {
        if let date = cachedCurrentDate {
            return date
        }
        
        let date = dataSource?.currentTime(for: collectionView, layout: self) as NSDate?
        
        cachedCurrentDate = date
        return date
    }
    
    // MARK: - Helpers
    // Issues using NSIndexPath as key in NSMutableDictionary
    // http://stackoverflow.com/questions/19613927/issues-using-nsindexpath-as-key-in-nsmutabledictionary
    func key(for indexPath: IndexPath?) -> IndexPath? {
//        print ("Infinite")
        if type(of: indexPath) == IndexPath.self {
            return indexPath
        }
        return IndexPath(row: indexPath?.row ?? 0, section: indexPath?.section ?? 0)
    }
    
    func floatingItemOverlaySize(for indexPath: IndexPath?) -> CGSize {
        let indexPathKey = key(for: indexPath)
        if let indexPathKey = indexPathKey {
            if let obj = cachedFloatingItemsOverlaySize?[indexPathKey] as? AnyObject {
                if !(obj is NSNull) {
//                    print (obj)
//                    print (obj.cgSizeValue ?? .zero)
                    return obj.cgSizeValue ?? .zero
                }
            }
        }
        var floatingItemSize = floatingItemOverlaySize
        if delegate?.responds(to: #selector(INSElectronicProgramGuideLayoutDelegate.collectionView(_:layout:sizeForFloatingItemOverlayAt:))) ?? false {
            floatingItemSize = delegate?.collectionView?(collectionView, layout: self, sizeForFloatingItemOverlayAt: indexPathKey) ?? CGSize.zero
        }
        cachedFloatingItemsOverlaySize?[indexPathKey] = NSValue(cgSize: floatingItemSize)
        return floatingItemSize
    }
}
