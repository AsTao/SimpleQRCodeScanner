# SimpleQRCodeScanner


# Usage

```swift
override func viewDidLoad() {
    super.viewDidLoad()
        self.scanner.resultBlock = { [weak self] code in
        print(code)
        self?.navigationController?.popViewController(animated: true)
    }
}

@IBOutlet weak var scanner: QRCodeScannerView!

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.scanner.start()
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.scanner.stop()
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SimpleQRCodeScanner is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SimpleQRCodeScanner'
```

## Author

tobias, 236048180@qq.com

## License

SimpleQRCodeScanner is available under the MIT license. See the LICENSE file for more info.
