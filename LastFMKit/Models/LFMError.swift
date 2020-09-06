//
//  LFMError.swift
//  LastFMKit
//
//  Copyright © 2020 Mark Bourke.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE
//

import Foundation

public typealias LFMError = RecoverableError & LocalizedError

private final class Action: NSObject {

    private let _action: (Bool) -> Void

    init(_ action: @escaping (Bool) -> Void) {
        _action = action
        super.init()
    }

    @objc func didPresentError(withRecovery didRecover: Bool, contextInfo: UnsafeMutableRawPointer?) {
        _action(didRecover)
    }
}

public extension RecoverableError {
    
    var recoveryOptions: [String] {
        return (self as NSError).localizedRecoveryOptions ?? []
    }

    func attemptRecovery(optionIndex recoveryOptionIndex: Int, resultHandler handler: @escaping (Bool) -> Void) {
        let action = Action(handler)
        ((self as NSError).recoveryAttempter as? NSObject)?.attemptRecovery(fromError: self, optionIndex: recoveryOptionIndex, delegate: action, didRecoverSelector: #selector(action.didPresentError(withRecovery:contextInfo:)), contextInfo: nil)
    }

    func attemptRecovery(optionIndex recoveryOptionIndex: Int) -> Bool {
        return ((self as NSError).recoveryAttempter as? NSObject)?.attemptRecovery(fromError: self, optionIndex: recoveryOptionIndex) ?? false
    }
}

public extension LocalizedError {
    var errorDescription: String? {
        return (self as NSError).localizedDescription
    }
    
    var failureReason: String? {
        return (self as NSError).localizedFailureReason
    }
    
    var recoverySuggestion: String? {
        return (self as NSError).localizedRecoverySuggestion
    }
    
    var helpAnchor: String? {
        (self as NSError).helpAnchor
    }
}

extension NSError: LFMError {}
