import Foundation

public extension RetryPolicy {

    func giveUp(on giveUpCriterium: @escaping (AttemptFailure) -> Bool) -> RetryPolicy {
        GiveUpOnPolicyWrapper(wrapped: self, giveUpCriterium: giveUpCriterium)
    }

    func giveUpAfter(maxAttempts: UInt) -> RetryPolicy {
        GiveUpOnPolicyWrapper(wrapped: self, giveUpCriterium: { $0.index >= maxAttempts - 1})
    }

    func giveUpOnErrors(matching finalErrorCriterium: @escaping (Error) -> Bool) -> RetryPolicy {
        GiveUpOnPolicyWrapper(wrapped: self, giveUpCriterium: { finalErrorCriterium($0.error) })
    }
}
