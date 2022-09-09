//
//  EmassiURLSession.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 09.09.2022.
//

import Foundation

private var mb = 1024 * 1024

class EmassiApiFetcher: NSObject {
    let apiKey: String
    let skey: String
    let imageDownloadURLSession: URLSession
    let dataFetchURLSession: URLSession
    
    init(apiKey: String, skey: String){
        self.apiKey = apiKey
        self.skey = skey
        let dataFetchConfig = getDataFetchConfiguration(apiKey: apiKey)
        let imageDownloadConfig = getImageDownloadConfiguration(apiKey: apiKey)
        
        imageDownloadURLSession = URLSession(configuration: imageDownloadConfig)
        dataFetchURLSession = URLSession(configuration: dataFetchConfig)
        super.init()
    }
}

private func getDataFetchConfiguration(apiKey: String) -> URLSessionConfiguration{
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = [
        "apiKey" : apiKey,
    ]
    
    configuration.networkServiceType = .responsiveData
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 300
    configuration.waitsForConnectivity = true
    
    configuration.urlCache = URLCache(memoryCapacity: 100 * mb, diskCapacity: 150 * mb,diskPath: "mainData")

    return configuration
}

private func getImageDownloadConfiguration(apiKey: String) -> URLSessionConfiguration {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = [
        "apiKey": apiKey
    ]
    
    configuration.urlCache = URLCache(memoryCapacity: 200 * mb, diskCapacity: 300 * mb, diskPath: "images")
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    
    configuration.timeoutIntervalForResource = 120
    configuration.timeoutIntervalForRequest = 30
    configuration.waitsForConnectivity = true
    
    configuration.networkServiceType = .responsiveAV
    configuration.httpMaximumConnectionsPerHost = 8
    
    return configuration
}
