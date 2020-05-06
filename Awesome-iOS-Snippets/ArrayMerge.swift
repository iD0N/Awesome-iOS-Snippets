//
//  ArrayMerge.swift
//  Awesome-iOS-Snippets
//
//  Created by Don on 11/18/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation


extension Dictionary {
	init<S>(_ values: S, uniquelyKeyedBy keyPath: KeyPath<S.Element, Key>) where S : Sequence, S.Element == Value {
		let keys = values.map { $0[keyPath: keyPath] }
		
		self.init(uniqueKeysWithValues: zip(keys, values))
	}
}

// Unordered example
extension Sequence {
	func merge<T: Sequence, U: Hashable>(mergeWith: T, uniquelyKeyedBy: KeyPath<T.Element, U>) -> [Element] where T.Element == Element {
		let dictOld = Dictionary(self, uniquelyKeyedBy: uniquelyKeyedBy)
		let dictNew = Dictionary(mergeWith, uniquelyKeyedBy: uniquelyKeyedBy)
		
		return dictNew.merging(dictOld, uniquingKeysWith: { old, new in old }).map { $0.value }
	}
}

// Ordered example
extension Array {
	mutating func mergeWithOrdering<U: Hashable>(mergeWith: Array, uniquelyKeyedBy: KeyPath<Array.Element, U>) {
		let dictNew = Dictionary(mergeWith, uniquelyKeyedBy: uniquelyKeyedBy)
		
		for (key, value) in dictNew {
			guard let index = firstIndex(where: { $0[keyPath: uniquelyKeyedBy] == key }) else {
				append(value)
				continue
			}
			
			self[index] = value
		}
	}
}
