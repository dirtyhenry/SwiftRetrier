import Foundation
import Combine

public struct ColdRepeater {
    let policy: RetryPolicy
    let repeatDelay: TimeInterval
    let conditionPublisher: AnyPublisher<Bool, Never>?
}

public extension ColdRepeater {

    func giveUp(on giveUpCriterium: @escaping (AttemptFailure) -> Bool) -> ColdRepeater {
        let policy = policy.giveUp(on: giveUpCriterium)
        return ColdRepeater(policy: policy, repeatDelay: repeatDelay, conditionPublisher: conditionPublisher)
    }

    func giveUpAfter(maxAttempts: UInt) -> ColdRepeater {
        let policy = policy.giveUpAfter(maxAttempts: maxAttempts)
        return ColdRepeater(policy: policy, repeatDelay: repeatDelay, conditionPublisher: conditionPublisher)
    }

    func giveUpOnErrors(matching finalErrorCriterium: @escaping (Error) -> Bool) -> ColdRepeater {
        let policy = policy.giveUpOnErrors(matching: finalErrorCriterium)
        return ColdRepeater(policy: policy, repeatDelay: repeatDelay, conditionPublisher: conditionPublisher)
    }

    func retry(on retryCriterium: @escaping (AttemptFailure) -> Bool) -> ColdRepeater {
        let policy = RetryOnPolicyWrapper(wrapped: policy, retryCriterium: retryCriterium)
        return ColdRepeater(policy: policy, repeatDelay: repeatDelay, conditionPublisher: conditionPublisher)
    }

    func retryOnErrors(matching retryCriterium: @escaping (Error) -> Bool) -> ColdRepeater {
        retry(on: { retryCriterium($0.error) })
    }

    func onlyWhen<P>(
        _ conditionPublisher: P
    ) -> ColdRepeater where P: Publisher, P.Output == Bool, P.Failure == Never {
        ColdRepeater(policy: policy,
                     repeatDelay: repeatDelay,
                     conditionPublisher: conditionPublisher.combineWith(condition: self.conditionPublisher))
    }

    @discardableResult
    func execute<Output>(_ job: @escaping Job<Output>) -> Repeater<Output> {
        Repeater(policy: policy, repeatDelay: repeatDelay, job: job)
    }

    @discardableResult
    func callAsFunction<Output>(_ job: @escaping Job<Output>) -> Repeater<Output> {
        execute(job)
    }
}
