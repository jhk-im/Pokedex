//
//  NetworkManager.swift
//  Pokedex
//
//  Created by HUN on 2023/01/19.
//

import Foundation

public class NetworkManager {
    
    static var shared = NetworkManager()
    
    private let strAccept = "*/*"
    private let strContetType = "application/json" //"application/x-www-form-urlencoded; charset=utf-8"
    private let strMultipartContetType = "multipart/form-data"
    
    static let statusDesc = [
        400 : "Bad Request",
        401 : "Token Expired",
        403 : "Forbidden",
        404 : "Not Found",
        405 : "Method Not Allowed",
        409 : "Conflict",
        500 : "Internal Server Error",
        503 : "Service Unavailable",
        998 : "Token Expired , refresh token not exist",
        999 : "Token Expired , access token fetch failed"
    ]
}
