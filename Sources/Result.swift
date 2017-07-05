//
//  Result.swift
//  TaskKit
//
//  Created by D'Alberti, Luca on 7/5/17.
//  Copyright © 2017 dalu93. All rights reserved.
//

import Foundation

// MARK: - Result enum declaration
/// Describes any operation result.
///
/// - success: The operation has succeeded.
/// - failure: The operation has failed.
public enum Result<ValueType, ErrorType: Error> {
    case success(ValueType)
    case failure(ErrorType)
}

// MARK: - Error and value utilities
extension Result {
    /// The final operation value.
    ///
    /// `nil` in case the operation has failed.
    public var value: ValueType? {
        switch self {
        case .success(let value):   return value
        case .failure:              return nil
        }
    }
    
    /// The final operation error.
    ///
    /// `nil` in case the operation has succeeded.
    public var error: ErrorType? {
        switch self {
        case .failure(let error):   return error
        case .success:              return nil
        }
    }
}

// MARK: - isFailure and isSuccess utilities
extension Result {
    /// `true` if the operation has succeded.
    public var isSuccess: Bool {
        if case .success = self { return true }
        else { return false }
    }
    
    /// `true` if the operation has failed.
    public var isFailure: Bool {
        if case .failure = self { return true }
        else { return false }
    }
}
