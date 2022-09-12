//
//  URLExtension.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
extension URL {

    func appending(queryItems: [URLQueryItem]) -> URL? {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        var queryItemsCurrent: [URLQueryItem] = urlComponents.queryItems ??  []

        queryItemsCurrent.append(contentsOf: queryItems)

        urlComponents.queryItems = queryItemsCurrent

        return urlComponents.url
    }
    
    func appending(queryItem: URLQueryItem) -> URL? {
        return appending(queryItems: [queryItem])
    }
}
