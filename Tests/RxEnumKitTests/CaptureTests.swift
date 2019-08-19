import XCTest
import RxSwift
import RxTest
import EnumKit

@testable import RxEnumKit

final class CaptureTests: XCTestCase {
    let disposeBag = DisposeBag()
    func testItCanCaptureAnonymousAssociatedValueEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let events: TestableObservable<CaseAccessible> = scheduler.createHotObservable([
            .next(100, MockEnum.withAnonymousAssociatedValue("100")),
            .next(200, MockEnum.withAnonymousAssociatedValue("200")),
            .next(300, MockEnum.withNamedAssociatedValue(value: "100")),
            .next(400, MockEnum.withAnonymousAssociatedValue("400")),
            .next(300, MockEnum.noAssociatedValue)
            ])
        let results = scheduler.createObserver(String.self)
        
        events.capture(case: MockEnum.withAnonymousAssociatedValue)
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<String>>] = [
            .next(100, "100"),
            .next(200, "200"),
            .next(400, "400")
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanCaptureNamedAssociatedValueEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let events: TestableObservable<CaseAccessible> = scheduler.createHotObservable([
            .next(100, MockEnum.withNamedAssociatedValue(value: "100")),
            .next(200, MockEnum.withAnonymousAssociatedValue("200")),
            .next(300, MockEnum.withNamedAssociatedValue(value: "100")),
            .next(400, MockEnum.withAnonymousAssociatedValue("400")),
            .next(300, MockEnum.noAssociatedValue)
            ])
        let results = scheduler.createObserver(String.self)
        
        events.capture(case: MockEnum.withNamedAssociatedValue)
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<String>>] = [
            .next(100, "100"),
            .next(300, "100")
        ]
        
        XCTAssertEqual(results.events, expected)
    }
    
    func testItCanCaptureNoAssociatedValueEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let events: TestableObservable<CaseAccessible> = scheduler.createHotObservable([
            .next(100, MockEnum.noAssociatedValue),
            .next(200, MockEnum.noAssociatedValue),
            .next(300, MockEnum.withNamedAssociatedValue(value: "100")),
            .next(400, MockEnum.withAnonymousAssociatedValue("400")),
            .next(300, MockEnum.noAssociatedValue)
            ])
        let results = scheduler.createObserver(String.self)
        
        events.capture(case: MockEnum.noAssociatedValue)
            .map { _ in "" }
            .subscribe(results)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected: [Recorded<Event<String>>] = [
            .next(100, ""),
            .next(200, ""),
            .next(300, "")
        ]
        
        XCTAssertEqual(results.events, expected)
    }
}
