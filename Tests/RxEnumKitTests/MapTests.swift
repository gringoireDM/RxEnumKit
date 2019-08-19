//
//  MapTests.swift
//  RxEnumKitTests
//
//  Created by Giuseppe Lanza on 19/08/2019.
//

import XCTest
import RxSwift
import RxTest
import EnumKit

@testable import RxEnumKit

class MapTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    let events: [Recorded<Event<CaseAccessible>>] = [
        .next(100, MockEnum.withAnonymousAssociatedValue("100")),
        .next(200, MockEnum.withAnonymousAssociatedValue("200")),
        .next(300, MockEnum.withNamedAssociatedValue(value: "100")),
        .next(400, MockEnum.withAnonymousAssociatedValue("400")),
        .next(450, MockEnum.withAnonymousAssociatedValue("David Bowie")),
        .next(300, MockEnum.noAssociatedValue)
    ]

    func testItCanMapAnonymousEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(Int.self)
        
        observable.map(case: MockEnum.withAnonymousAssociatedValue, Int.init)
            .compactMap { $0 }
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<Int>>] = [
            .next(100, 100),
            .next(200, 200),
            .next(400, 400)
        ]
        
        XCTAssertEqual(results.events, expected)
    }

    func testItCanMapNamedEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(Int.self)
        
        observable.map(case: MockEnum.withNamedAssociatedValue, Int.init)
            .compactMap { $0 }
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<Int>>] = [
            .next(300, 100)
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanMapNoAssociatedValueEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(String.self)
        
        observable.map(case: MockEnum.noAssociatedValue) { "Frank Sinatra" }
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<String>>] = [
            .next(300, "Frank Sinatra"),
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanCompactMapAnonymousEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(Int.self)
        
        observable.compactMap(case: MockEnum.withAnonymousAssociatedValue, Int.init)
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<Int>>] = [
            .next(100, 100),
            .next(200, 200),
            .next(400, 400)
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanCompactMapNamedEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(Int.self)
        
        observable.compactMap(case: MockEnum.withNamedAssociatedValue, Int.init)
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<Int>>] = [
            .next(300, 100)
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanCompactMapNoAssociatedValueEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(String.self)
        
        observable.compactMap(case: MockEnum.noAssociatedValue) { "Frank Sinatra" }
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<String>>] = [
            .next(300, "Frank Sinatra"),
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanFlatMapAnonymousEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(String.self)
        
        observable.flatMap(case: MockEnum.withAnonymousAssociatedValue) { Observable.just($0) }
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<String>>] = [
            .next(100, "100"),
            .next(200, "200"),
            .next(400, "400"),
            .next(450, "David Bowie")
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanFlatMapNamedEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(String.self)
        
        observable.flatMap(case: MockEnum.withNamedAssociatedValue) { Observable.just($0) }
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<String>>] = [
            .next(300, "100")
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanFlatMapNoAssociatedValueEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let observable = scheduler.createHotObservable(events)
        
        let results = scheduler.createObserver(String.self)
        
        observable.flatMap(case: MockEnum.noAssociatedValue) { Observable.just("Frank Sinatra") }
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<String>>] = [
            .next(300, "Frank Sinatra"),
        ]
        
        XCTAssertEqual(results.events, expected)
    }
}
