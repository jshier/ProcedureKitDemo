//
//  ProcedureKit
//
//  Copyright © 2016 ProcedureKit. All rights reserved.
//

public protocol ProcedureKitComponent {
    var name: String { get }
}

public struct ProcedureKitError: Error, Equatable {

    public static func == (lhs: ProcedureKitError, rhs: ProcedureKitError) -> Bool {
        return lhs.context == rhs.context
    }

    public enum CapabilityError: Error {
        case unavailable, unauthorized
    }

    public enum Context: Equatable {

        public static func == (lhs: Context, rhs: Context) -> Bool {
            switch (lhs, rhs) {
            case (.unknown, .unknown), (.dependencyFinishedWithErrors, .dependencyFinishedWithErrors), (.parentCancelledWithErrors, .parentCancelledWithErrors), (.requirementNotSatisfied, .requirementNotSatisfied):
                return true
            case let (.programmingError(lhs), .programmingError(rhs)):
                return lhs == rhs
            case let (.capability(lhs), .capability(rhs)):
                return lhs == rhs
            case let (.component(lhs), .component(rhs)):
                return lhs.name == rhs.name
            default:
                return false
            }
        }

        case unknown
        case component(ProcedureKitComponent)
        case programmingError(String)
        case timedOut(Delay)
        case conditionFailed
        case dependenciesFailed
        case dependenciesCancelled
        case dependencyFinishedWithErrors
        case dependencyCancelledWithErrors
        case parentCancelledWithErrors
        case requirementNotSatisfied
        case capability(CapabilityError)
    }

    public static let unknown = ProcedureKitError(context: .unknown, errors: [])

    public static func programmingError(reason: String) -> ProcedureKitError {
        return ProcedureKitError(context: .programmingError(reason), errors: [])
    }

    public static func timedOut(with delay: Delay) -> ProcedureKitError {
        return ProcedureKitError(context: .timedOut(delay), errors: [])
    }

    public static func dependenciesFailed() -> ProcedureKitError {
        return ProcedureKitError(context: .dependenciesFailed, errors: [])
    }

    public static func conditionFailed(withErrors errors: [Error] = []) -> ProcedureKitError {
        return ProcedureKitError(context: .conditionFailed, errors: errors)
    }

    public static func dependenciesCancelled() -> ProcedureKitError {
        return ProcedureKitError(context: .dependenciesCancelled, errors: [])
    }

    public static func dependency(finishedWithErrors errors: [Error]) -> ProcedureKitError {
        return ProcedureKitError(context: .dependencyFinishedWithErrors, errors: errors)
    }

    public static func dependency(cancelledWithErrors errors: [Error]) -> ProcedureKitError {
        return ProcedureKitError(context: .dependencyCancelledWithErrors, errors: errors)
    }

    public static func parent(cancelledWithErrors errors: [Error]) -> ProcedureKitError {
        return ProcedureKitError(context: .parentCancelledWithErrors, errors: errors)
    }

    public static func requirementNotSatisfied() -> ProcedureKitError {
        return ProcedureKitError(context: .requirementNotSatisfied, errors: [])
    }

    public static func capabilityUnavailable() -> ProcedureKitError {
        return ProcedureKitError(context: .capability(.unavailable), errors: [])
    }

    public static func capabilityUnauthorized() -> ProcedureKitError {
        return ProcedureKitError(context: .capability(.unauthorized), errors: [])
    }

    public static func component(_ component: ProcedureKitComponent, error: Error) -> ProcedureKitError {
        return ProcedureKitError(context: .component(component), errors: [error])
    }

    public let context: Context
    public let errors: [Error]
}
