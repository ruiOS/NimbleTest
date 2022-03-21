//
//  Box.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation
import Foundation

///Box binding
final class Box<Object>{

    typealias Listener = (Object) -> Void
    private var listener: Listener?

    var value: Object {
        didSet {
            listener?(value)
        }
    }

    init(_ value: Object) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

}
