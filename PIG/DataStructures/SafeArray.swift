//
//  SafeArray.swift
//  SafeArray
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI

//Safe array construct, which only lets array accesses happen within the given bounds
//Source: https://stackoverflow.com/questions/66712572/swiftui-list-ondelete-index-out-of-range
struct Safe<T: RandomAccessCollection & MutableCollection, C: View>: View {
    
    typealias BoundElement = Binding<T.Element>
    private let binding: BoundElement
    private let content: (BoundElement) -> C
    
    init(_ binding: Binding<T>, index: T.Index, @ViewBuilder content: @escaping (BoundElement) -> C) {
        self.content = content
        self.binding = .init(get: { binding.wrappedValue[index] },
                             set: { binding.wrappedValue[index] = $0 })
    }
    
    var body: some View {
        content(binding)
    }
}
