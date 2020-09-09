//
//  Data+Additions.swift
//  Copyright © 2019 Observant. All rights reserved.
//

public extension Data {
    enum Error: Swift.Error {
        case write(Swift.Error)
        case contentsOfURL(Swift.Error)
    }
    
    func ft_write(to url: URL) -> Result<Void, Error> {
        do {
            try write(to: url)
        } catch {
            return .failure(.write(error))
        }
        
        return .success(())
    }
    
    static func ft_contentsOf(_ url: URL) -> Result<Data, Error> {
        do {
            let data = try Data(contentsOf: url)
            return .success(data)
        } catch {
            return .failure(.contentsOfURL(error))
        }
    }
    
    var ft_prettyPrintedJSON: Data? {
        guard let obj = try? JSONSerialization.jsonObject(with: self, options: .init()) else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted) else {
            return nil
        }
        return data
    }
    
    var ft_prettyPrintedJSONString: String? {
        guard let json = ft_prettyPrintedJSON else { return nil }
        return String(data: json, encoding: .utf8)
    }
}
