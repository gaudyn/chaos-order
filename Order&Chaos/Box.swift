//
//  Box.swift
//  Order&Chaos
//
//  Created by Administrator on 25/06/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T{
        didSet{
            listener?(value)
        }
    }
    init(_ value: T){
        self.value = value
    }
    func bind(_ listener: Listener?){
        self.listener = listener
        listener?(value)
    }
}
