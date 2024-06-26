//
//  CalendarActivityView.swift
//  ExampleActivityView
//
//  Created by agustiyan on 12/05/24.
//

import UIKit

@objc protocol CalendarActivityViewDelegate {
    func colorFor(dateComponents: DateComponents) -> UIColor
    @objc optional func didSelectedAt(dateComponents: DateComponents)
    @objc optional func finishLoadCalendar()
}

class CalendarActivityView: UIView {
    
    // MARK: ui components
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(CalendarActivityViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: config.contentRightInset)
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.layer.masksToBounds = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.itemSize = CGSize(width: config.itemSide, height: config.itemSide)
        flow.sectionInset = UIEdgeInsets(top: config.monthHeight, left: 0, bottom: 0, right: config.lineSpacing)
        flow.minimumLineSpacing = config.lineSpacing
        flow.minimumInteritemSpacing = config.interitemSpacing
        return flow
    }()
    
    private lazy var weekDayView: WeekDayView = {
        return WeekDayView(config: config)
    }()
    
    private lazy var monthHeaderView: MonthHeaderView = {
        return MonthHeaderView(config: config)
    }()
    
    private let cellId = "CalendarActivityViewCellId"
    private let config: CalendarActivityConfig
    private var startDate: Date
    private var endDate: Date
    
    private var calendarData: CalendarActivityData?
    
    weak var delegate: CalendarActivityViewDelegate?
    
    init(config: CalendarActivityConfig = CalendarActivityConfig(), startDate: Date = Date().addingTimeInterval(-365 * 24 * 60 * 60), endDate: Date = Date()) {
        self.config = config
        self.startDate = startDate
        self.endDate = endDate
        super.init(frame: .zero)
        render()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storyboard implementation, should not enter here")
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func reload(newStartDate: Date?, newEndDate: Date?) {
        guard newStartDate != nil || newEndDate != nil else {
            reload()
            return
        }
        startDate = newStartDate ?? startDate
        endDate = newEndDate ?? endDate
        setup()
    }
    
    func scrollTo(date: Date, at: UICollectionView.ScrollPosition, animated: Bool) {
        let difference = Date.daysBetween(start: startDate, end: date)
        collectionView.scrollToItem(at: IndexPath(item: difference - 1, section: 0), at: at, animated: animated)
    }
    
    private func setup() {
        backgroundColor = config.backgroundColor
        DispatchQueue.global(qos: .userInteractive).async {
            // calculate calendar date in background
            self.calendarData = CalendarActivityData(config: self.config,
                                                    startDate: self.startDate,
                                                    endDate: self.endDate)
            self.monthHeaderView.build(headers: self.calendarData!.headerData)
            DispatchQueue.main.async { [weak self] in
                // then reload
                self?.collectionView.reloadData()
                self?.delegate?.finishLoadCalendar?()
            }
        }
    }
    
    private func render() {
        clipsToBounds = true
        
        addSubview(collectionView)
        addSubview(weekDayView)
        collectionView.addSubview(monthHeaderView)
        collectionView.bringSubviewToFront(monthHeaderView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        weekDayView.translatesAutoresizingMaskIntoConstraints = false
        monthHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weekDayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weekDayView.topAnchor.constraint(equalTo: self.topAnchor),
            weekDayView.widthAnchor.constraint(equalToConstant: config.weekDayWidth),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: config.itemSide * 7 + config.interitemSpacing * 6 + config.monthHeight),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: weekDayView.trailingAnchor),
            monthHeaderView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            monthHeaderView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            monthHeaderView.heightAnchor.constraint(equalToConstant: config.monthHeight)
        ])
        let bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
    }
}

extension CalendarActivityView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarData?.daysCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalendarActivityViewCell
        cell.config = config
        if let date = calendarData?.itemAt(indexPath: indexPath),
            let itemColor = delegate?.colorFor(dateComponents: Calendar.current.dateComponents([.year, .month, .day], from: date)) {
            cell.itemColor = itemColor
        } else {
            cell.itemColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let date = calendarData?.itemAt(indexPath: indexPath) else { return }
        delegate?.didSelectedAt?(dateComponents: Calendar.current.dateComponents([.year, .month, .day], from: date))
    }
}
