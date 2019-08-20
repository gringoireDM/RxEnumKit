//
//  FilterTests.swift
//  RxEnumKitTests
//
//  Created by Giuseppe Lanza on 19/08/2019.
//

import XCTest
import RxSwift
import RxTest
import EnumKit

@testable import RxEnumKit

class FilterTests: XCTestCase {
    let disposeBag = DisposeBag()

    let events: [Recorded<Event<CaseAccessible>>] = [
        .next(100, MockEnum.withAnonymousAssociatedValue("100")),
        .next(200, MockEnum.withAnonymousAssociatedValue("200")),
        .next(300, MockEnum.withNamedAssociatedValue(value: "100")),
        .next(400, MockEnum.withAnonymousAssociatedValue("400")),
        .next(300, MockEnum.noAssociatedValue)
    ]
    
    func testItCanFilterAnonymousEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(MockEnum.self)
        
        observable.filter(case: MockEnum.withAnonymousAssociatedValue)
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()

        let expected: [Recorded<Event<MockEnum>>] = [
            .next(100, .withAnonymousAssociatedValue("100")),
            .next(200, .withAnonymousAssociatedValue("200")),
            .next(400, .withAnonymousAssociatedValue("400"))
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanFilterNamedEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(MockEnum.self)
        
        observable.filter(case: MockEnum.withNamedAssociatedValue)
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<MockEnum>>] = [
            .next(300, .withNamedAssociatedValue(value: "100"))
        ]
        
        XCTAssertEqual(results.events, expected)
    }

    func testItCanFilterNoAssociatedValueEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(MockEnum.self)
        
        observable.filter(case: MockEnum.noAssociatedValue)
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<MockEnum>>] = [
            .next(300, .noAssociatedValue)
        ]
        
        XCTAssertEqual(results.events, expected)
    }
}
