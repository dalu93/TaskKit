//
//  TaskResultHandler.swift
//  TaskKit
//
//  Created by D'Alberti, Luca on 7/5/17.
//  Copyright © 2017 dalu93. All rights reserved.
//

import Foundation

// MARK: - TaskResultHandler class declaration
public class TaskResultHandler<ResultType, ErrorType: Error> {
    
    // MARK: - Private properties
    fileprivate var _result: Result<ResultType, ErrorType>! {
        didSet {
            if _result.isSuccess, let value = _result.value {
                onValue?(value)
            } else if _result.isFailure, let error = _result.error {
                onError?(error)
            } else {
                fatalError("Unexpected behavior. Expected a valid result. Please report a bug.")
            }
        }
    }
    
    // MARK: - Public properties
    var onValue: VoidClosure<ResultType>?
    var onError: VoidClosure<ErrorType>?
}

// MARK: - Public methods
extension TaskResultHandler {
    public func send(value: ResultType) {
        _result = .success(value)
    }
    
    public func send(error: ErrorType) {
        _result = .failure(error)
    }
}
