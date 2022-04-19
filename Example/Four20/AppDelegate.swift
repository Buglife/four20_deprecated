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

import UIKit
import Four20

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    enum MyError: Swift.Error {
        case foobar
    }
    
    func test(_ error: Swift.Error) {
        print("DSDSDS 3 error: \(error)")
        
        let nsError = error.ft_NSError as Swift.Error
        print("DSDSDS 3 nsError: \(type(of: nsError))")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let url = URL(string: "https://www.google.com")!
        let task = URLSession.shared.dataTask(with: url) { _, _, error in
            if let error = error {
                print("DSDSDS 2 error: \(error)")
                
                let nsError = error.ft_NSError.ft_NSError
                print("DSDSDS 2 nsError: \(nsError)")
                
                if let underlyingError = nsError.ft_underlyingError {
                    print("DSDSDS 2 underlyingError: \(underlyingError)")
                    
                    self.test(underlyingError)
                }
            }
        }
        
        task.resume()
        
        let error = MyError.foobar
        print("DSDSDS 1 error: \(error)")
        
        let nsError = error.ft_NSError
        print("DSDSDS 1 nsError: \(nsError)")
        
        return true
    }
}
