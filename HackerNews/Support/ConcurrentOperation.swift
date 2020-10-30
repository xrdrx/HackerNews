//
//  ConcurrentOperation.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 30.10.2020.
//

import Foundation

class ConcurrentOperation<T>: Operation {
    
    private enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }
    
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    typealias OperationCompletionHandler = (_ result: Result<T>) -> Void
    
    var completionHandler: (OperationCompletionHandler)?
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        if !isExecuting {
            state = .executing
        }
        
        main()
    }
    
    func finish() {
        if isExecuting {
            state = .finished
        }
    }
    
    func complete(result: Result<T>) {
        finish()
        
        if !isCancelled {
            completionHandler?(result)
        }
    }
    
    override func cancel() {
        super.cancel()
        
        finish()
    }
}

enum Result<T> {
    case success(T)
    case failure(Error)
}
