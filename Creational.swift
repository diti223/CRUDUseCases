//
//  Creational.swift
//
//  Created by Adrian-Dieter Bilescu on 9/22/19.
//  Copyright © 2019 Bilescu. All rights reserved.
//

import Foundation

protocol CreationalGateway {
    associatedtype Request
    associatedtype Entity
    associatedtype GatewayError: Error
    var request: Request? { get }
    func create() throws
}


class CreationalUseCase<Gateway: CreationalGateway> {
    typealias Handler = ((Result<Void, Gateway.GatewayError>) -> Void)
    let readableGateway: Gateway
    let request: Gateway.Request
    let handler: Handler
    
    init(readableGateway: Gateway, request: Gateway.Request, handler: @escaping Handler) {
        self.readableGateway = readableGateway
        self.request = request
        self.handler = handler
    }
    
    func execute() {
        do {
            handler(.success(try readableGateway.create()))
        } catch let error as Gateway.GatewayError {
            handler(.failure(error))
        } catch {
            fatalError("Error type not supported")
        }
        
    }
}
