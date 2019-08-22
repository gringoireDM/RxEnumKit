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

    
}
