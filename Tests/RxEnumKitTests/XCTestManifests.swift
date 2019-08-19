import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FilterTests.allTests),
        testCase(ExcludeTests.allTests),
        testCase(CaptureTests.allTests),
        testCase(MapTests.allTests),
    ]
}
#endif
