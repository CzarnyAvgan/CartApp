//
//  FileResourceService.swift
//  CartApp
//
//  Created by Kacper Wysocki on 19/10/2025.
//

import Foundation

struct FileResourceService {
    private enum FileResourceServiceError: Error, LocalizedError {
        case fileNotFound(name: String, ext: String)
        case decodingFailed(underlying: Error)
        
        var errorDescription: String? {
            switch self {
            case .fileNotFound(let name, let ext):
                return "Mock file not found: \(name).\(ext)"
            case .decodingFailed(let underlying):
                if let decodingError = underlying as? DecodingError {
                    return "Decoding failed: \(decodingError.localizedDescription)"
                } else {
                    return "Decoding failed: \(underlying.localizedDescription)"
                }
            }
        }
    }
    
    func loadDataFromBundle(fileName: String, fileExtension: String) throws -> Data {
        let bundle = Bundle.main
        guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            throw FileResourceServiceError.fileNotFound(name: fileName, ext: fileExtension)
        }
        return try Data(contentsOf: url)
    }
    
    func decodeExchangeResponse<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw FileResourceServiceError.decodingFailed(underlying: error)
        }
    }
}
