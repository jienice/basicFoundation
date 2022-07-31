//
//  NetworkReachability.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

public class NetworkReachability {

    public enum Status {
        case unknown
        case notReachable
        case ethernetOrWiFi
        case cellular
    }

    private let reachability = NetworkReachabilityManager()

    public static let `default` = NetworkReachability()

    private let status = BehaviorRelay<Status>(value: .unknown)

    @discardableResult
    public func startListening() -> Observable<Status> {
        reachability?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { [weak self] status in
                switch status {
                case .notReachable:
                    self?.status.accept(.notReachable)
                case .unknown:
                    self?.status.accept(.unknown)
                case let .reachable(type):
                    switch type {
                    case .cellular:
                        self?.status.accept(.cellular)
                    case .ethernetOrWiFi:
                        self?.status.accept(.ethernetOrWiFi)
                    }
                }
        })
        return status.asObservable()
    }
}
