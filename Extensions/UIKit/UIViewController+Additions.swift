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

public extension UIViewController {
    func ft_presentAlert(title: String, message: String? = nil, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func ft_presentAlert(error: Error) {
        ft_presentAlert(title: "Oops!", message: "Something went wrong:\n\n\(error.localizedDescription)")
    }
}
