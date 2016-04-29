/*
 *  Copyright (c) 2016, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 */

import Foundation

///
/// An error type that contains or more underlying errors
///
public struct AggregateError: ErrorType {
    public let errors: [ErrorType]

    init(errors: [ErrorType]) {
        self.errors = errors
    }
}

///
/// An error type that indicates that the task was cancelled.
///
/// Return this from a closure to propagate to the `task.cancelled` property.
///
public struct CancelledError: ErrorType { }
