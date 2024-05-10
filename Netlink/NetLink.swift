//
//  NetLink.swift
//  NetLink
//
//  Created by Rohit Kumar on 08/05/24.
//

import Foundation
import Combine

public class NetLink {
    private init() {}
    private static var storage = Set<AnyCancellable>()
    
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    public static func get<T>(urlString: String, queryItems: [String: String]? = nil, headers: [String: String]? = nil) -> Future<T, Error> where T: Codable {
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(NetworkError.invalidURL))
            }
        }
        
        guard let request = makeURLRequest(url: url, method: .get, queryItems: queryItems, headers: headers) else {
            return Future { promise in
                promise(.failure(NetworkError.invalidRequest))
            }
        }
        
        return apiRequestWithGenericResponse(request)
    }
    
    public static func post<T>(urlString: String, queryItems: [String: String]? = nil, headers: [String: String]? = nil, payload: [String: Any]) -> Future<T, Error> where T: Codable {
        guard let url = URL(string: urlString) else {
            return Future { promise in
                promise(.failure(NetworkError.invalidURL))
            }
        }
        
        guard let request = makeURLRequest(url: url, method: .post, queryItems: queryItems, headers: headers, payload: payload) else {
            return Future { promise in
                promise(.failure(NetworkError.invalidRequest))
            }
        }
        
        return apiRequestWithGenericResponse(request)
    }
    
    private static func makeURLRequest(url: URL, method: HTTPMethod, queryItems: [String: String]? = nil, headers: [String: String]? = nil, payload: [String: Any]? = nil) -> URLRequest? {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let finalURL = urlComponents?.url else {
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let payload = payload {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: payload)
                request.httpBody = jsonData
            } catch {
                return nil
            }
        }
        
        return request
    }
    
    private static func apiRequestWithGenericResponse<T>(_ request: URLRequest) -> Future<T, Error> where T: Codable {
        Future { promise in
            apiRequest(request)
                .decode(type: T.self, decoder: JSONDecoder())
                .clubIntoResult()
                .sink { promise($0) }
                .store(in: &storage)
        }
    }
    
    private static func apiRequest(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { response in
                if let httpResponse = response.response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        return response.data
                    default:
                        throw NetworkError.invalidResponse
                    }
                }
                return response.data
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
