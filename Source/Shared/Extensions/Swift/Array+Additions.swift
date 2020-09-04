//
//  Four20
//  Copyright (C) 2019 Buglife, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

public extension Array {
    func ft_flattened() -> [Any] {
        var res = [Any]()
        
        for val in self {
            if let arr = val as? [Any] {
                res.append(contentsOf: arr.ft_flattened())
            } else {
                res.append(val)
            }
        }
        
        return res
    }
    
    func ft_subarryWithIndexes(_ indexes: [Int]) -> [Element]? {
        guard let maxIndex = indexes.max(), self.count > maxIndex else { return nil }
        return indexes.map { self[$0] }
    }
}

public extension Array {
    mutating func ft_removeFirstUntil(count: Int) {
        let overflowCount = Swift.max(0, self.count - count)
        self.removeFirst(overflowCount)
    }
}
