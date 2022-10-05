//
//  NetworkConnectionChecker.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 05.10.2022.
//

import Foundation
import Network
import RealRechability

class NetworkConnectionChecker{
    private var networkChecker: NWPathMonitor
    var connectionChanged: ((_ isConnected: Bool) -> Void)?
    var networkTypeChanged: ((_ connectionType: ConnectionType) -> Void)?
    private var dispatchQueue: DispatchQueue
    var isConnected: Bool = false
    var isLowDataMode: Bool = false
    var isMobileInternet: Bool = false
    var connectionType: ConnectionType = .other
    
    deinit{
        networkChecker.cancel()
    }
    
    init(){
        networkChecker = .init()
        
        dispatchQueue = DispatchQueue(label: "InternetConnection")
        
        networkChecker.pathUpdateHandler = { [weak self, weak networkChecker] path in
            guard let self = self else {
                networkChecker?.cancel()
                return
            }
            self.isLowDataMode = path.isConstrained
            self.isMobileInternet = path.isExpensive
            self.isConnected = path.status == .satisfied
            
            self.checkNetworkType(path: path)
            self.connectionChanged?(self.isConnected)
        }
        networkChecker.start(queue: dispatchQueue)
    }
    
    private func checkNetworkType(path: NWPath){
        if path.usesInterfaceType(.wifi){
            self.connectionType = .wifi
        } else if path.usesInterfaceType(.cellular){
            self.connectionType = .mobileInternet
        } else if path.usesInterfaceType(.wiredEthernet){
            self.connectionType = .wiredInternet
        } else {
            self.connectionType = .other
        }
        networkTypeChanged?(self.connectionType)
    }
    
    public enum ConnectionType: String{
        case wifi = "Wi-fi"
        case mobileInternet = "Cellular"
        case wiredInternet = "Wired Ethernet"
        case other = "Other"
    }
}
