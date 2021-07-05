//
//  APIClient.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation
import UIKit

// MARK: - DataTask
protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// MARK: - URLSession
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

final class APIClient {
    private var session: URLSessionProtocol
    init(withSession session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func loadData<T: Decodable>(from url: URL,
                                completion: @escaping (Result<T, FlickrAppError>) -> Void) {
        let dataTask =  session.dataTask(with: url, completionHandler: { data, _, _ in
            do {
                guard let data = data else {
                    completion(.failure(.noResults))
                    return
                }

                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))

            } catch let error {
                completion(.failure(.runtimeError(error.localizedDescription)))

            }
        })

        dataTask.resume()
    }
}
