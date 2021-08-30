//
//  SequenceExtension.swift
//  SequenceExtension
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
//Removes duplcicate elements from an array
//From https://stackoverflow.com/questions/25738817/removing-duplicate-elements-from-an-array-in-swift
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

