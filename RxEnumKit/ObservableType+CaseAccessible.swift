import RxSwift
import EnumKit

public extension ObservableType where Element: CaseAccessible {
    
     /// Filters the elements of an observable sequence based on a specific case.
     /// - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
     /// - parameter case: An enum case to test each source element for a matching condition.
     /// - returns: An observable sequence that contains enum cases from the input sequence that satisfy the case condition.
    func filter(case: Element) -> Observable<Element> {
        return filter { $0 ~= `case` }
    }
    
    /// Filters the elements of an observable sequence based on a specific case pattern.
    /// - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that satisfy the case condition.
    func filter<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element) -> Observable<Element> {
        return filter { $0 ~= pattern }
    }
    
    /// Filters the elements of an observable sequence based on a specific case, excluding it from the stream.
    /// - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that do not satisfy the case condition.
    func exclude(case: Element) -> Observable<Element> {
        return filter { $0 !~= `case` }
    }
    
    /// Filters the elements of an observable sequence based on a specific case pattern, excluding it from the stream.
    /// - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that do not satisfy the case condition.
    func exclude<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element) -> Observable<Element> {
        return filter { $0 !~= pattern }
    }
    
    
    /// Projects each matching enum case of an observable sequence into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence whose elements are the result of associated value extraction on each matching cases of source.
    func capture(case: Element) -> Observable<Void> {
        return filter { $0 ~= `case` }.map { _ in }
    }
    
    /// Projects each matching enum case of an observable sequence into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence whose elements are the result of associated value extraction on each matching cases of source.
    func capture<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element) -> Observable<AssociatedValue> {
        return compactMap { $0[case: pattern] }
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new form.
    /// - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum
    /// case's associated value of the source.
    func map<T>(case: Element, _ transform: @escaping () throws -> T) -> Observable<T> {
        return capture(case: `case`).map(transform)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new form.
    /// - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum
    /// case's associated value of the source.
    func map<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Element,
                                 _ transfrom: @escaping (AssociatedValue) throws -> T) -> Observable<T> {
        return capture(case: pattern).map(transfrom)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into an optional form and filters all optional results.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value and which returns an
    /// element or nil.
    /// - returns: An observable sequence whose elements are the result of filtering the transform function for each matching enum case's
    /// associated value of the source.
    func compactMap<T>(case: Element, _ transform: @escaping () throws -> T?) -> Observable<T> {
        return capture(case: `case`).compactMap(transform)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into an optional form and filters all optional results.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value and which returns an
    /// element or nil.
    /// - returns: An observable sequence whose elements are the result of filtering the transform function for each matching enum case's
    /// associated value of the source.
    func compactMap<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Element,
                                        _ transform: @escaping (AssociatedValue) throws -> T?) -> Observable<T> {
        return capture(case: pattern).compactMap(transform)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each each matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence.
    func flatMap<Source: ObservableConvertibleType>(case: Element,
                                                    _ selector: @escaping () throws -> Source) -> Observable<Source.Element> {
        return capture(case: `case`).flatMap(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each each matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence.
    func flatMap<AssociatedValue, Source: ObservableConvertibleType>(case pattern: @escaping (AssociatedValue) -> Element,
                                                    _ selector: @escaping (AssociatedValue) throws -> Source) -> Observable<Source.Element> {
        return capture(case: pattern).flatMap(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - seealso: [flatMapFirst operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapFirst<Source: ObservableConvertibleType>(case: Element,
                                                         _ selector: @escaping () throws -> Source) -> Observable<Source.Element> {
        return capture(case: `case`).flatMapFirst(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - seealso: [flatMapFirst operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapFirst<AssociatedValue, Source: ObservableConvertibleType>(case pattern: @escaping (AssociatedValue) -> Element,
                                                                          _ selector: @escaping (AssociatedValue) throws -> Source) -> Observable<Source.Element> {
        return capture(case: pattern).flatMapFirst(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new sequence of observable sequences and then
    /// transforms an observable sequence of observable sequences into an observable sequence producing values only from the most recent
    /// observable sequence.
    /// - seealso: [flatMapLatest operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each element.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum case's
    /// associated value of source producing an
    /// Observable of Observable sequences and that at any point in time produces the elements of the most recent inner observable sequence
    /// that has been received.
    func flatMapLatest<Source: ObservableConvertibleType>(case: Element,
                                                         _ selector: @escaping () throws -> Source) -> Observable<Source.Element> {
        return capture(case: `case`).flatMapLatest(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new sequence of observable sequences and then
    /// transforms an observable sequence of observable sequences into an observable sequence producing values only from the most recent
    /// observable sequence.
    /// - seealso: [flatMapLatest operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each element.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum case's
    /// associated value of source producing an
    /// Observable of Observable sequences and that at any point in time produces the elements of the most recent inner observable sequence
    /// that has been received.
    func flatMapLatest<AssociatedValue, Source: ObservableConvertibleType>(case pattern: @escaping (AssociatedValue) -> Element,
                                                                          _ selector: @escaping (AssociatedValue) throws -> Source) -> Observable<Source.Element> {
        return capture(case: pattern).flatMapLatest(selector)
    }
}

public extension ObservableType where Element == CaseAccessible {
    
    private func model<T: CaseAccessible>(_ type: T.Type) -> Observable<T> {
        return compactMap { $0 as? T }
    }
    
    /// Filters the elements of an observable sequence based on a specific case.
    /// - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that satisfy the case condition.
    func filter<T: CaseAccessible>(case: T) -> Observable<T> {
        return model(T.self).filter(case: `case`)
    }
    
    /// Filters the elements of an observable sequence based on a specific case pattern.
    /// - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that satisfy the case condition.
    func filter<T: CaseAccessible, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> T) -> Observable<T> {
        return model(T.self).debug("MATCH").filter(case: pattern)
    }
    
    /// Filters the elements of an observable sequence based on a specific case, excluding it from the stream.
    /// - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that do not satisfy the case condition.
    func exclude<T: CaseAccessible>(case: T) -> Observable<T> {
        return model(T.self).exclude(case: `case`)
    }
    
    /// Filters the elements of an observable sequence based on a specific case pattern, excluding it from the stream.
    /// - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that do not satisfy the case condition.
    func exclude<T: CaseAccessible, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> T) -> Observable<T> {
        return model(T.self).exclude(case: pattern)
    }
    
    
    /// Projects each matching enum case of an observable sequence into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence whose elements are the result of associated value extraction on each matching cases of source.
    func capture<T: CaseAccessible>(case: T) -> Observable<Void> {
        return model(T.self).capture(case: `case`)
    }
    
    /// Projects each matching enum case of an observable sequence into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence whose elements are the result of associated value extraction on each matching cases of source.
    func capture<T: CaseAccessible, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> T) -> Observable<AssociatedValue> {
        return model(T.self).capture(case: pattern)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new form.
    /// - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum
    /// case's associated value of the source.
    func map<T, U: CaseAccessible>(case: U, _ transform: @escaping () throws -> T) -> Observable<T> {
        return model(U.self).map(case: `case`, transform)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new form.
    /// - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum
    /// case's associated value of the source.
    func map<AssociatedValue, T, U: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> U,
                                 _ transfrom: @escaping (AssociatedValue) throws -> T) -> Observable<T> {
        return model(U.self).map(case: pattern, transfrom)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into an optional form and filters all optional results.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value and which returns an
    /// element or nil.
    /// - returns: An observable sequence whose elements are the result of filtering the transform function for each matching enum case's
    /// associated value of the source.
    func compactMap<T, U: CaseAccessible>(case: U, _ transform: @escaping () throws -> T?) -> Observable<T> {
        return model(U.self).compactMap(case: `case`, transform)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into an optional form and filters all optional results.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value and which returns an
    /// element or nil.
    /// - returns: An observable sequence whose elements are the result of filtering the transform function for each matching enum case's
    /// associated value of the source.
    func compactMap<AssociatedValue, T, U: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> U,
                                        _ transform: @escaping (AssociatedValue) throws -> T?) -> Observable<T> {
        return model(U.self).compactMap(case: pattern, transform)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each each matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence.
    func flatMap<Source: ObservableConvertibleType, T: CaseAccessible>(case: T,
                                                    _ selector: @escaping () throws -> Source) -> Observable<Source.Element> {
        return model(T.self).flatMap(case: `case`, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each each matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence.
    func flatMap<AssociatedValue, Source: ObservableConvertibleType, T: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> T,
                                                                     _ selector: @escaping (AssociatedValue) throws -> Source) -> Observable<Source.Element> {
        return model(T.self).flatMap(case: pattern, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - seealso: [flatMapFirst operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapFirst<Source: ObservableConvertibleType, T: CaseAccessible>(case: T,
                                                         _ selector: @escaping () throws -> Source) -> Observable<Source.Element> {
        return model(T.self).flatMapFirst(case: `case`, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - seealso: [flatMapFirst operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapFirst<AssociatedValue, Source: ObservableConvertibleType, T: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> T,
                                                                          _ selector: @escaping (AssociatedValue) throws -> Source) -> Observable<Source.Element> {
        return model(T.self).flatMapFirst(case: pattern, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new sequence of observable sequences and then
    /// transforms an observable sequence of observable sequences into an observable sequence producing values only from the most recent
    /// observable sequence.
    /// - seealso: [flatMapLatest operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each element.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum case's
    /// associated value of source producing an
    /// Observable of Observable sequences and that at any point in time produces the elements of the most recent inner observable sequence
    /// that has been received.
    func flatMapLatest<Source: ObservableConvertibleType, T: CaseAccessible>(case: T,
                                                          _ selector: @escaping () throws -> Source) -> Observable<Source.Element> {
        return model(T.self).flatMapLatest(case: `case`, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new sequence of observable sequences and then
    /// transforms an observable sequence of observable sequences into an observable sequence producing values only from the most recent
    /// observable sequence.
    /// - seealso: [flatMapLatest operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each element.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum case's
    /// associated value of source producing an
    /// Observable of Observable sequences and that at any point in time produces the elements of the most recent inner observable sequence
    /// that has been received.
    func flatMapLatest<AssociatedValue, Source: ObservableConvertibleType, T: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> T,
                                                                           _ selector: @escaping (AssociatedValue) throws -> Source) -> Observable<Source.Element> {
        return model(T.self).flatMapLatest(case: pattern, selector)
    }
}
