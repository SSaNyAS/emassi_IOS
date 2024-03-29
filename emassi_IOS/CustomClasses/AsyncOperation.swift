//
//  AsyncOperation.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 05.10.2022.
//

import Foundation

class AsyncOperation: Operation {
    private let lockQueue = DispatchQueue(label: "asyncOperationQueue", attributes: .concurrent)
    
    override var isAsynchronous: Bool {
        return true
    }
    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }

    override func start() {
        print("Starting")
        guard !isCancelled else {
            finish()
            return
        }

        isFinished = false
        isExecuting = true
        main()
    }

    override func main() {
        fatalError("Subclasses must implement `main` without overriding super.")
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }
}

class AsyncBlockOperation: AsyncOperation{
    var action: () -> Void = {}
    
    override init() {
        super.init()
        let action: () -> Void = { [weak self] in
            self?.finish()
        }
        self.action = action
    }
    
    override func main() {
        action()
    }
}
