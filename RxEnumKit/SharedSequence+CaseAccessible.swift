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
    func filter(case: Element) -> SharedSequence<SharingStrategy, Element> {
        return filter { $0 ~= `case` }
    }
    
    func filter<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element) -> SharedSequence<SharingStrategy, Element> {
        return filter { $0 ~= pattern }
    }

    func exclude(case: Element) -> SharedSequence<SharingStrategy, Element> {
        return filter { $0 !~= `case` }
    }

    func exclude<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element) -> SharedSequence<SharingStrategy, Element> {
        return filter { $0 !~= pattern }
    }
    
    func capture(case: Element) -> SharedSequence<SharingStrategy, Void> {
        return filter { $0 ~= `case` }.map { _ in }
    }
    
    func capture<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Element) -> SharedSequence<SharingStrategy, AssociatedValue> {
        return asObservable()
            .compactMap { $0[case: pattern] }
            .asSharedSequence(onErrorRecover: { _ in .empty() })
    }
    
    func map<T>(case: Element, _ transform: @escaping () -> T) -> SharedSequence<SharingStrategy, T> {
        return capture(case: `case`).map(transform)
    }
    
    func map<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Element,
                                 _ transfrom: @escaping (AssociatedValue) -> T) -> SharedSequence<SharingStrategy, T> {
        return capture(case: pattern).map(transfrom)
    }

    func compactMap<T>(case: Element, _ transform: @escaping () -> T?) -> SharedSequence<SharingStrategy, T> {
        return capture(case: `case`)
            .asObservable()
            .compactMap(transform)
            .asSharedSequence(onErrorRecover: { _ in .empty() })
    }
    
    func compactMap<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Element,
                                        _ transform: @escaping (AssociatedValue) -> T?) -> SharedSequence<SharingStrategy, T> {
        return capture(case: pattern)
            .asObservable()
            .compactMap(transform)
            .asSharedSequence(onErrorRecover: { _ in .empty() })
    }

}
