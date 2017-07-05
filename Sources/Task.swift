//
//  Task.swift
//  TaskKit
//
//  Created by D'Alberti, Luca on 7/5/17.
//  Copyright © 2017 dalu93. All rights reserved.
//

import Foundation

// MARK: - TaskNextOperation enum declaration
public enum TaskNextOperation {
    case retry, stop
}

// MARK: - Task class declaration
/// Defines an asynchronous task.
///
/// Initialize a `Task`, then call the `then()` method to start it and listen for success.
/// You can catch any error by calling the `catchError()` method.
/// If an action has to be exectuted in both cases, use the `always()` method.
open class Task<ResultType, ErrorType: Error> {
    
    // MARK: - Private properties
    fileprivate var _isOperationStarted = false
    fileprivate lazy var _resultHandler: TaskResultHandler<ResultType, ErrorType> = self._makeResultHandler()
    fileprivate let _taskOperation: VoidClosure< TaskResultHandler<ResultType, ErrorType> >
    fileprivate var _onSuccess: VoidClosure<ResultType>?
    fileprivate var _onError: Closure<ErrorType, TaskNextOperation>?
    fileprivate var _onEnd: EmptyClosure?
    
    // MARK: - Object lifecycle
    public required init(_ operation: @escaping VoidClosure< TaskResultHandler<ResultType, ErrorType> >) {
        _taskOperation = operation
    }
}

// MARK: - Public methods
extension Task {
    @discardableResult
    func then(_ thenClosure: @escaping VoidClosure<ResultType>) -> Self {
        _onSuccess = thenClosure
        _start()
        return self
    }
    
    @discardableResult
    func catchError(_ errorClosure: @escaping Closure<ErrorType, TaskNextOperation>) -> Self {
        _onError = errorClosure
        return self
    }
    
    @discardableResult
    func always(_ alwaysClosure: @escaping EmptyClosure) -> Self {
        _onEnd = alwaysClosure
        return self
    }
}

// MARK: - Operation start utility
private extension Task {
    func _start() {
        guard !_isOperationStarted else {
            return
        }
        
        _isOperationStarted = true
        _taskOperation(_resultHandler)
    }
    
    func _retry() {
        guard let thenClosure = _onSuccess else {
            fatalError("Cannot retry an operation if the operation hasn't been started at least once. Please report a bug.")
        }
        
        then(thenClosure)
    }
}

// MARK: - Builders
private extension Task {
    func _makeResultHandler() -> TaskResultHandler<ResultType, ErrorType> {
        let handler = TaskResultHandler<ResultType, ErrorType>()
        
        handler.onValue = { [weak self] value in
            self?._isOperationStarted = false
            self?._onSuccess?(value)
            self?._onEnd?()
        }
        
        handler.onError = { [weak self] error in
            guard let weakSelf = self else { return }
            weakSelf._isOperationStarted = false
            guard let nextOperation = weakSelf._onError?(error) else { return }
            
            switch nextOperation {
            case .retry:
                weakSelf._retry()
                
            case .stop:
                weakSelf._onEnd?()
            }
        }
        
        return handler
    }
}
