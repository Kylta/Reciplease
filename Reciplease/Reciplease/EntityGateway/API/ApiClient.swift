//
//  ApiClient.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 21/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Alamofire

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

protocol ApiClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

class ApiClientImplementation: ApiClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        Alamofire.request(url)
            .validate(statusCode: 200...299)
            .responseData { response in
                guard let data = response.data, let httpUrlResponse = response.response else { return
                    completion(.failure(response.error!))
                }

                completion(.success(data, httpUrlResponse))
        }
    }
}
