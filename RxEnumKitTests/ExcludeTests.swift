//
//  ExcludeTests.swift
//  RxEnumKitTests
//
//  Created by Giuseppe Lanza on 19/08/2019.
//

import XCTest
import RxSwift
import RxTest
import EnumKit

@testable import RxEnumKit

class ExcludeTests: XCTestCase {
    let disposeBag = DisposeBag()

    func testItCanExcludeNoAssociatedValueEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let events: TestableObservable<CaseAccessible> = scheduler.createHotObservable([
            .next(100, MockEnum.noAssociatedValue),
            .next(200, MockEnum.noAssociatedValue),
            .next(300, MockEnum.withNamedAssociatedValue(value: "100")),
            .next(400, MockEnum.withAnonymousAssociatedValue("400")),
            .next(300, MockEnum.noAssociatedValue)
            ])
        let results = scheduler.createObserver(MockEnum.self)
        
        events.exclude(case: MockEnum.noAssociatedValue)
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<MockEnum>>] = [
            .next(300, .withNamedAssociatedValue(value: "100")),
            .next(400, .withAnonymousAssociatedValue("400"))
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanExcludeWithAssociatedValueEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let events: TestableObservable<CaseAccessible> = scheduler.createHotObservable([
            .next(100, MockEnum.noAssociatedValue),
            .next(200, MockEnum.noAssociatedValue),
            .next(300, MockEnum.withNamedAssociatedValue(value: "100")),
            .next(400, MockEnum.withAnonymousAssociatedValue("400")),
            .next(500, MockEnum.noAssociatedValue)
            ])
        let results = scheduler.createObserver(MockEnum.self)
        
        events.exclude(case: MockEnum.withNamedAssociatedValue)
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<MockEnum>>] = [
            .next(100, MockEnum.noAssociatedValue),
            .next(200, MockEnum.noAssociatedValue),
            .next(400, .withAnonymousAssociatedValue("400")),
            .next(500, MockEnum.noAssociatedValue)
        ]
        
        XCTAssertEqual(results.events, expected)
    }

    
    func testItCanExcludeNoAssociatedValueEventsDriver() {
        let scheduler = TestScheduler(initialClock: 0)
        let events: TestableObservable<CaseAccessible> = scheduler.createHotObservable([
            .next(100, MockEnum.noAssociatedValue),
            .next(200, MockEnum.noAssociatedValue),
            .next(300, MockEnum.withNamedAssociatedValue(value: "100")),
            .next(400, MockEnum.withAnonymousAssociatedValue("400")),
            .next(300, MockEnum.noAssociatedValue)
            ])
        let results = scheduler.createObserver(MockEnum.self)
        
        events.asDriver(onErrorRecover: { _ in .empty() })
            .exclude(case: MockEnum.noAssociatedValue)
            .drive(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<MockEnum>>] = [
            .next(300, .withNamedAssociatedValue(value: "100")),
            .next(400, .withAnonymousAssociatedValue("400"))
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanExcludeWithAssociatedValueEventsDriver() {
        let scheduler = TestScheduler(initialClock: 0)
        let events: TestableObservable<CaseAccessible> = scheduler.createHotObservable([
            .next(100, MockEnum.noAssociatedValue),
            .next(200, MockEnum.noAssociatedValue),
            .next(300, MockEnum.withNamedAssociatedValue(value: "100")),
            .next(400, MockEnum.withAnonymousAssociatedValue("400")),
            .next(500, MockEnum.noAssociatedValue)
            ])
        let results = scheduler.createObserver(MockEnum.self)
        
        events.asDriver(onErrorRecover: { _ in .empty() })
            .exclude(case: MockEnum.withNamedAssociatedValue)
            .drive(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<MockEnum>>] = [
            .next(100, MockEnum.noAssociatedValue),
            .next(200, MockEnum.noAssociatedValue),
            .next(400, .withAnonymousAssociatedValue("400")),
            .next(500, MockEnum.noAssociatedValue)
        ]
        
        XCTAssertEqual(results.events, expected)
    }
}
