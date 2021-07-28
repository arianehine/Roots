//
//  SequenceExtension.swift
//  SequenceExtension
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

