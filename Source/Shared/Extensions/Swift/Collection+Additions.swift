//
//  Collection+Additions
//  Copyright © 2020 Observant. All rights reserved.
//

public extension Collection {
    func ft_dictionary<K: Hashable, V>(transform:(_ element: Iterator.Element) -> (key: K, value: V)) -> [K : V] {
        return self.reduce(into: [K : V]()) { (accu, current) in
            let kvp = transform(current)
            accu[kvp.key] = kvp.value
        }
    }
    
    func ft_chunked(into size: Int) -> [SubSequence] {
        var chunks: [SubSequence] = []
        chunks.reserveCapacity((underestimatedCount + size - 1) / size)
        
        var currentIndex = startIndex
        while let nextIndex = index(currentIndex, offsetBy: size, limitedBy: endIndex) {
            chunks.append(self[currentIndex ..< nextIndex])
            currentIndex = nextIndex
        }
        
        let finalChunk = suffix(from: currentIndex)
        if !finalChunk.isEmpty {
            chunks.append(finalChunk)
        }
        return chunks
    }
}
