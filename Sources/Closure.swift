//
//  Closure.swift
//  TaskKit
//
//  Created by D'Alberti, Luca on 7/5/17.
//  Copyright © 2017 dalu93. All rights reserved.
//

import Foundation

public typealias Closure<ParameterType, ReturnType> = (ParameterType) -> ReturnType
public typealias VoidClosure<ParameterType> = Closure<ParameterType, Void>
public typealias EmptyClosure = () -> ()
