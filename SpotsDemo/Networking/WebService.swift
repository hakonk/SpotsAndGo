//
//  WebService.swift
//  SpotsDemo
//
//  Created by Håkon Knutzen on 10/12/2017.
//  Copyright © 2017 Håkon Knutzen. All rights reserved.
//

import Foundation

enum RequestResult<T> {
    case success(T)
    case failure(Error)
}

struct WebService {
    enum WebServiceError: Error {
        case malformedUrl
        case failedRequest(statusCode: Int)
    }
    let url: String

    func fetch<Mappable: Codable>(completion: @escaping (RequestResult<Mappable>) -> Void) {
        guard let url = URL(string: self.url) else {
            let error = WebServiceError.malformedUrl
            return completion(.failure(error))
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard
                (200...399).contains(statusCode),
                let data = data else {
                let error = WebServiceError.failedRequest(statusCode: statusCode)
                return completion(.failure(error))
            }
            DispatchQueue.global(qos: .userInitiated).async {
                let result = self.map(data: data, to: Mappable.self)
                completion(result)
            }
        }
        task.resume()
    }

    private func map<Mappable: Codable>(data: Data, to mappableType: Mappable.Type) -> RequestResult<Mappable> {
        do {
            let mappedData = try JSONDecoder().decode(mappableType, from: data)
            return RequestResult<Mappable>.success(mappedData)
        } catch {
            return RequestResult<Mappable>.failure(error)
        }
    }
}
