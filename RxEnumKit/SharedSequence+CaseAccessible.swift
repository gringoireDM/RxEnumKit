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
}
