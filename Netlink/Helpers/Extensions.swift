//
//  Extensions.swift
//  NetLink
//
//  Created by Rohit Kumar on 08/05/24.
//

import Foundation
import Combine

public enum NetworkError: Error {
    case invalidURL
    case invalidRequest
    case invalidSession
    case invalidResponse
}

public struct EmptyModel: Codable {}

public extension Publisher {
    /// Puts success and failure streams in `Result`. In some publishers like `Future` both sink methods were required to get sucess and failure values
    /// to avoid that, this operator clubs both the streams in Result type so that you can get both success and failure as success wrapped in `Result`
    func clubIntoResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self
            .map { .success($0) }
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
