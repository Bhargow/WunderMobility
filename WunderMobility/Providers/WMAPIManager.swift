//
//  WMAPIManager.swift
//  WunderMobility
//
//  Created by Bhargow's MacBook Pro Black on 15/08/19.
//  Copyright © 2019 Bhargow. All rights reserved.
//

import UIKit

public enum HTTPMethod: String {
    case get     = "GET"
}

public enum APIManagerError: Error {
    case InvalidResponse(String)
    case InvalidURL(String)
    case InvalidResponseFormat(String)
    case InternalError(String)
}

class WMAPIManager {
    
    private var session: URLSession
    
    init(sessionObj: URLSession = URLSession.shared) {
        session = sessionObj
    }
    
    //    - Description: Returns raw data from the API using params based on the HTTP method type the URL is modified.
    //    - Parameters: httpMethod: HTTPMethod, params: [String : Any], completion: Action block, errorOccured: Action block
    //    - Returns: Void
    func request(urlString: String, httpMethod: HTTPMethod, params: [String : Any]?, completion: @escaping (_ response: Any) -> Void, errorOccured: @escaping (_ error: APIManagerError) -> Void) {

        if let url = URL(string: urlString) {
            let task = session.dataTask(with: url, completionHandler: { data, response, error in
                if error == nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: [])
                        completion(json)
                    } catch let error {
                        errorOccured(.InvalidResponseFormat(error.localizedDescription))
                    }
                } else {
                    errorOccured(.InvalidResponse(error?.localizedDescription ?? ""))
                }
            })
            task.resume()
        } else {
            errorOccured(.InvalidURL(urlString))
        }
    }
}
