//
//  CodableSerializer.swift
//  Ryd
//
//  Created by Rakib Rz  on 31/10/22.
//

import Foundation

extension Encodable {
    
    var encodedJsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }

    func toEncode() -> (data: Data?, error: Error?) {
        do {
            let encoder: JSONEncoder = JSONEncoder()
            //            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(self)
            return (data, nil)
        } catch let error {
            debugPrint("Getting error while \(#function): \(String(describing: self.self))... \(error.localizedDescription)")
            return(nil, error)
        }
    }

    func toJSON() -> String {
        return self.toEncode().data?.toJSON() ?? ""
    }

    func toDictionary() -> [String: AnyObject] {
        return self.toEncode().data?.toDictionary() ?? [:]
    }
}

extension Decodable {
    
    static func decode(from data: Data) -> Self? {
        let decoder: JSONDecoder = JSONDecoder()
        //        decoder.dateDecodingStrategy = .iso8601
        do {
            let decodable = try decoder.decode(Self.self, from: data)
            return decodable
        } catch let error {
            debugPrint("Getting error while \(#function): \(String(describing: self.self))... \(error.localizedDescription)")
            return nil
        }
    }
}

extension Data {
    func decodeTo<GenericType: Decodable>(classType: GenericType.Type) -> (model: GenericType?, error: Error?) {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let decodable = try decoder.decode(classType, from: self)
            return (decodable, nil)
        } catch let error {
            debugPrint("Getting error while \(#function): \(String(describing: GenericType.self))... \(error.localizedDescription)")
            return (nil, error)
        }
    }

    func toJSON() -> String {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return "something wrong to convert to JSON" }

        return prettyPrintedString
    }

    func toDictionary() -> [String: AnyObject] {
        let dictionary = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: AnyObject]
        return dictionary ?? [:]
    }
    
    var json: String? {
        return String(bytes: self, encoding: String.Encoding.utf8)
    }
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

extension Dictionary {
    func toJson() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError(domain: "Dictionary", code: 1, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
    
    func decodeTo<GenericType: Decodable>(classType: GenericType.Type) -> (model: GenericType?, error: Error?) {
        do {
            
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let model = try JSONDecoder().decode(GenericType.self, from: data)
            return (model, nil)
        } catch  {
            debugPrint("Getting error while \(#function): \(String(describing: GenericType.self))... \(error.localizedDescription)")
            return (nil, error)
        }
    }

//    func toParamString() -> String {
//        var params = String()
//        self.forEach { (key, value) in
//            params.append("\(key)")
//            params.append("=")
//            params.append("\(value)")
//            params.append("&")
//        }
//        params.removeLast()
//        return params
//    }
}
