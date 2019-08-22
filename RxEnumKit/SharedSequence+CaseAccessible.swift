//
//  SharedSequence+CaseAccessible.swift
//  RxEnumKit
//
//  Created by Giuseppe Lanza on 22/08/2019.
//  Copyright © 2019 MERLin Tech. All rights reserved.
//

import RxCocoa
import RxSwift
import EnumKit

public extension SharedSequence where Element: CaseAccessible {
    /// Filters the elements of an observable sequence based on a specific case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that satisfy the case condition.
    func filter(case: Element) -> SharedSequence<SharingStrategy, Element> {
        return filter { $0 ~= `case` }
    }
    
    /// Filters the elements of an observable sequence based on a specific case pattern.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that satisfy the case condition.
    func filter<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element) -> SharedSequence<SharingStrategy, Element> {
        return filter { $0 ~= pattern }
    }

    /// Filters the elements of an observable sequence based on a specific case, excluding it from the stream.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that do not satisfy the case condition.
    func exclude(case: Element) -> SharedSequence<SharingStrategy, Element> {
        return filter { $0 !~= `case` }
    }

    /// Filters the elements of an observable sequence based on a specific case pattern, excluding it from the stream.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that do not satisfy the case condition.
    func exclude<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element) -> SharedSequence<SharingStrategy, Element> {
        return filter { $0 !~= pattern }
    }
    
    /// Projects each matching enum case of an observable sequence into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence whose elements are the result of associated value extraction on each matching cases of source.
    func capture(case: Element) -> SharedSequence<SharingStrategy, Void> {
        return filter { $0 ~= `case` }.map { _ in }
    }
    
    /// Projects each matching enum case of an observable sequence into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence whose elements are the result of associated value extraction on each matching cases of source.
    func capture<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element) -> SharedSequence<SharingStrategy, AssociatedValue> {
        return asObservable()
            .compactMap { $0[case: pattern] }
            .asSharedSequence(onErrorRecover: { _ in .empty() })
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new form.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum
    /// case's associated value of the source.
    func map<T>(case: Element, _ transform: @escaping () -> T) -> SharedSequence<SharingStrategy, T> {
        return capture(case: `case`).map(transform)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new form.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum
    /// case's associated value of the source.
    func map<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Element,
                                 _ transfrom: @escaping (AssociatedValue) -> T) -> SharedSequence<SharingStrategy, T> {
        return capture(case: pattern).map(transfrom)
    }

    /// Projects each matching enum case's associated value of an observable sequence into an optional form and filters all optional results.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value and which returns an
    /// element or nil.
    /// - returns: An observable sequence whose elements are the result of filtering the transform function for each matching enum case's
    /// associated value of the source.
    func compactMap<T>(case: Element, _ transform: @escaping () -> T?) -> SharedSequence<SharingStrategy, T> {
        return capture(case: `case`)
            .asObservable()
            .compactMap(transform)
            .asSharedSequence(onErrorRecover: { _ in .empty() })
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into an optional form and filters all optional results.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value and which returns an
    /// element or nil.
    /// - returns: An observable sequence whose elements are the result of filtering the transform function for each matching enum case's
    /// associated value of the source.
    func compactMap<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Element,
                                        _ transform: @escaping (AssociatedValue) -> T?) -> SharedSequence<SharingStrategy, T> {
        return capture(case: pattern)
            .asObservable()
            .compactMap(transform)
            .asSharedSequence(onErrorRecover: { _ in .empty() })
    }

    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each each matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence.
    func flatMap<Sharing: SharingStrategyProtocol, Result>(case: Element, _ selector: @escaping () -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return capture(case: `case`).flatMap(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each each matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence.
    func flatMap<Sharing: SharingStrategyProtocol, Result, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element,
                                                                            _ selector: @escaping (AssociatedValue) -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return capture(case: pattern).flatMap(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapFirst<Sharing: SharingStrategyProtocol, Result>(case: Element, _ selector: @escaping () -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return capture(case: `case`).flatMapFirst(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapFirst<Sharing: SharingStrategyProtocol, Result, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element,
                                                                            _ selector: @escaping (AssociatedValue) -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return capture(case: pattern).flatMapFirst(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapLatest<Sharing: SharingStrategyProtocol, Result>(case: Element, _ selector: @escaping () -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return capture(case: `case`).flatMapLatest(selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapLatest<Sharing: SharingStrategyProtocol, Result, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element,
                                                                            _ selector: @escaping (AssociatedValue) -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return capture(case: pattern).flatMapLatest(selector)
    }
}


public extension SharedSequence where Element == CaseAccessible {
    private func model<T: CaseAccessible>(_ type: T.Type) -> SharedSequence<SharingStrategy, T> {
        return asObservable().compactMap { $0 as? T }
            .asSharedSequence(onErrorRecover: { _ in .empty() })
    }
    

    /// Filters the elements of an observable sequence based on a specific case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that satisfy the case condition.
    func filter<T: CaseAccessible>(case: T) -> SharedSequence<SharingStrategy, T> {
        return model(T.self).filter(case: `case`)
    }
    
    /// Filters the elements of an observable sequence based on a specific case pattern.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that satisfy the case condition.
    func filter<T: CaseAccessible, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> T) -> SharedSequence<SharingStrategy, T> {
        return model(T.self).debug("MATCH").filter(case: pattern)
    }
    
    /// Filters the elements of an observable sequence based on a specific case, excluding it from the stream.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that do not satisfy the case condition.
    func exclude<T: CaseAccessible>(case: T) -> SharedSequence<SharingStrategy, T> {
        return model(T.self).exclude(case: `case`)
    }
    
    /// Filters the elements of an observable sequence based on a specific case pattern, excluding it from the stream.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence that contains enum cases from the input sequence that do not satisfy the case condition.
    func exclude<T: CaseAccessible, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> T) -> SharedSequence<SharingStrategy, T> {
        return model(T.self).exclude(case: pattern)
    }
    
    
    /// Projects each matching enum case of an observable sequence into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence whose elements are the result of associated value extraction on each matching cases of source.
    func capture<T: CaseAccessible>(case: T) -> SharedSequence<SharingStrategy, Void> {
        return model(T.self).capture(case: `case`)
    }
    
    /// Projects each matching enum case of an observable sequence into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: An observable sequence whose elements are the result of associated value extraction on each matching cases of source.
    func capture<T: CaseAccessible, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> T) -> SharedSequence<SharingStrategy, AssociatedValue> {
        return model(T.self).capture(case: pattern)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new form.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum
    /// case's associated value of the source.
    func map<T, U: CaseAccessible>(case: U, _ transform: @escaping () -> T) -> SharedSequence<SharingStrategy, T> {
        return model(U.self).map(case: `case`, transform)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into a new form.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the transform function on each matching enum
    /// case's associated value of the source.
    func map<AssociatedValue, T, U: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> U,
                                                    _ transfrom: @escaping (AssociatedValue) -> T) -> SharedSequence<SharingStrategy, T> {
        return model(U.self).map(case: pattern, transfrom)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into an optional form and filters all optional results.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value and which returns an
    /// element or nil.
    /// - returns: An observable sequence whose elements are the result of filtering the transform function for each matching enum case's
    /// associated value of the source.
    func compactMap<T, U: CaseAccessible>(case: U, _ transform: @escaping () -> T?) -> SharedSequence<SharingStrategy, T> {
        return model(U.self).compactMap(case: `case`, transform)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence into an optional form and filters all optional results.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A transform function to apply to each source matching enum case's associated value and which returns an
    /// element or nil.
    /// - returns: An observable sequence whose elements are the result of filtering the transform function for each matching enum case's
    /// associated value of the source.
    func compactMap<AssociatedValue, T, U: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> U,
                                                           _ transform: @escaping (AssociatedValue) -> T?) -> SharedSequence<SharingStrategy, T> {
        return model(U.self).compactMap(case: pattern, transform)
    }
    
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each each matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence.
    func flatMap<Sharing: SharingStrategyProtocol, Result, Case: CaseAccessible>(case: Case, _ selector: @escaping () -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return model(Case.self).flatMap(case: `case`, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each each matching enum case's associated value.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence.
    func flatMap<Sharing: SharingStrategyProtocol, Result, AssociatedValue, Case: CaseAccessible>(
        case pattern: @escaping (AssociatedValue) -> Case,
        _ selector: @escaping (AssociatedValue) -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return model(Case.self).flatMap(case: pattern, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapFirst<Sharing: SharingStrategyProtocol, Result, Case: CaseAccessible>(
        case: Case, _ selector: @escaping () -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return model(Case.self).flatMapFirst(case: `case`, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapFirst<Sharing: SharingStrategyProtocol, Result, AssociatedValue, Case: CaseAccessible>(
        case pattern: @escaping (AssociatedValue) -> Case,
        _ selector: @escaping (AssociatedValue) -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return model(Case.self).flatMapFirst(case: pattern, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapLatest<Sharing: SharingStrategyProtocol, Result, Case: CaseAccessible>(
        case: Case, _ selector: @escaping () -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return model(Case.self).flatMapLatest(case: `case`, selector)
    }
    
    /// Projects each matching enum case's associated value of an observable sequence to an observable sequence and merges the resulting
    /// observable sequences into one observable sequence.
    /// If element is received while there is some projected observable sequence being merged it will simply be ignored.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter selector: A transform function to apply to each matching enum case's associated value that was observed while no
    /// observable is executing in parallel.
    /// - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each matching
    /// enum case's associated value of the input sequence that was received while no other sequence was being calculated.
    func flatMapLatest<Sharing: SharingStrategyProtocol, Result, AssociatedValue, Case: CaseAccessible>(
        case pattern: @escaping (AssociatedValue) -> Case,
        _ selector: @escaping (AssociatedValue) -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        return model(Case.self).flatMapLatest(case: pattern, selector)
    }
}
