//
//  FileManager+Additions.swift
//  Four20
//

import Foundation

public extension FileManager {
    
    // MARK: - Types
    
    enum Error: Swift.Error {
        case createDirectory(Swift.Error)
        case contentsOfDirectory(Swift.Error)
        case dataWithContentsOfURL(Swift.Error)
        case removeItem(Swift.Error)
        case other(Swift.Error)
    }
    
    enum SortProperty: String {
        case filename = "Filename"
        case creationDate = "Creation Date"
    }
    
    // MARK: - Public methods
    
    func ft_contentsOfDirectory(at parentURL: URL, sortedBy: SortProperty) -> Result<[URL], Error> {
        let unsorted: [URL]
        
        do {
            unsorted = try FileManager.default.contentsOfDirectory(at: parentURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants])
        } catch {
            return .failure(.contentsOfDirectory(error))
        }
        
        let sorted = unsorted.sorted { f1, f2 in
            let f1isDir = FileManager.default.ft_isDirectory(f1)
            let f2isDir = FileManager.default.ft_isDirectory(f2)
            
            if f1isDir && !f2isDir {
                return true
            } else if !f1isDir && f2isDir {
                return false
            } else {
                switch sortedBy {
                case .filename:
                    return f1.lastPathComponent > f2.lastPathComponent
                case .creationDate:
                    if let f1_creationDate = f1.ft_creationDate, let f2_creationDate = f2.ft_creationDate {
                        return f1_creationDate > f2_creationDate
                    } else if let _ = f1.ft_creationDate {
                        return true
                    } else if let _ = f2.ft_creationDate {
                        return false
                    } else {
                        return true
                    }
                }
            }
        }
        
        return .success(sorted)
    }
    
    /// Returns the filenames in a given directory
    func ft_contentsOfDirectory(atPath path: String) -> Result<[String], Error> {
        do {
            let contents = try contentsOfDirectory(atPath: path)
            return .success(contents)
        } catch {
            return .failure(.contentsOfDirectory(error))
        }
    }
    
    // MARK: - Create directory
    
    // returns true if the directory was created, false if it already existed, error if it failed
    func ft_createDirectoryIfNeeded(at directory: URL) -> Result<Bool, Error> {
        if !fileExists(atPath: directory.path) {
            return ft_createDirectory(at: directory)
        } else {
            return .success(false)
        }
    }
    // always returns true or error
    func ft_createDirectory(at directory: URL) -> Result<Bool, Error> {
        do {
            try createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return .failure(.createDirectory(error))
        }
        
        return .success(true)
    }
    
    // MARK: - Remove item
    
    func ft_removeItemIfExists(at fileURL: URL) -> Result<Void, Error> {
        let path = fileURL.path
        guard fileExists(atPath: path) else { return .success(()) }
        return ft_removeItem(atPath: path)
    }
    
    func ft_removeItem(at fileURL: URL) -> Result<Void, Error> {
        do {
            try removeItem(at: fileURL)
            return .success(())
        } catch {
            return .failure(.removeItem(error))
        }
    }
    
    func ft_removeItem(atPath filePath: String) -> Result<Void, Error> {
        do {
            try removeItem(atPath: filePath)
            return .success(())
        } catch {
            return .failure(.removeItem(error))
        }
    }
    
    // MARK: - Everything else
    
    func ft_url(for searchPathDirectory: SearchPathDirectory, in searchPathDomainMask: SearchPathDomainMask, appropriateFor: URL?, create: Bool) -> Result<URL, Error> {
        do {
            let result = try url(for: searchPathDirectory, in: searchPathDomainMask, appropriateFor: appropriateFor, create: create)
            return .success(result)
        } catch {
            return .failure(.other(error))
        }
    }
    
    func ft_moveItem(at: URL, to: URL) -> Result<Void, Error> {
        do {
            try moveItem(at: at, to: to)
            return .ft_success
        } catch {
            return .failure(.other(error))
        }
    }
}
