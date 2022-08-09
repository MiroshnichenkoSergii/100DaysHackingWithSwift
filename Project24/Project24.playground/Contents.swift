import UIKit

//MARK: Project24 about strings stuff
//let name = "Taylor"
//
//for letter in name {
//    print("Give me a \(letter)!")
//}
//let letter = name[name.index(name.startIndex, offsetBy: 3)]
//
//extension String {
//  subscript(i: Int) -> String {
//      return String(self[index(startIndex, offsetBy: i)])
//  }
//}
//
//print(name[3])

// MARK: 2 hasPrefix / hasSuffix
//let password = "12345"
//password.hasPrefix("123")
//password.hasSuffix("345")
//
//extension String {
//    // remove a prefix if it exists
//    func deletingPrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else { return self }
//        return String(self.dropFirst(prefix.count))
//    }
//
//    // remove a suffix if it exists
//    func deletingSuffix(_ suffix: String) -> String {
//        guard self.hasSuffix(suffix) else { return self }
//        return String(self.dropLast(suffix.count))
//    }
//}
//password.deletingPrefix("123")
//password.deletingSuffix("345")

//MARK: 3 Capitalized
//let weather = "it's going to rain"
//print(weather.capitalized)
//
//extension String {
//    var capitalizedFirst: String {
//        guard let firstLetter = self.first else { return "" }
//        return firstLetter.uppercased() + self.dropFirst()
//    }
//}
//print(weather.capitalizedFirst)

//MARK: 4 Contains
//let input = "Swift is like Objective-C without the C"
//input.contains("Swift")
//
//let languages = ["Python", "Ruby", "Swift"]
//languages.contains("Swift")
//
//extension String {
//    func containsAny(of array: [String]) -> Bool {
//        for item in array {
//            if self.contains(item) {
//                return true
//            }
//        }
//
//        return false
//    }
//}
//input.containsAny(of: languages)
//
// MARK: input.contains means input.contains("Python") then input.contains("Ruby") and input.contains("Swift")
//languages.contains(where: input.contains)

//MARK: 5 Attributes of string
//let string = "This is a test string"
//let attributes: [NSAttributedString.Key: Any] = [
//    .foregroundColor: UIColor.white,
//    .backgroundColor: UIColor.red,
//    .font: UIFont.boldSystemFont(ofSize: 36)
//]

//let attributedString = NSAttributedString(string: string, attributes: attributes)

//let attributedString = NSMutableAttributedString(string: string)
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

/*
Set .underlineStyle to a value from NSUnderlineStyle to strike out characters.
Set .strikethroughStyle to a value from NSUnderlineStyle (no, that’s not a typo) to strike out characters.
Set .paragraphStyle to an instance of NSMutableParagraphStyle to control text alignment and spacing.
Set .link to be a URL to make clickable links in your strings.
 */

//MARK: Challenge 1
//let input = "pet"
//
//extension String {
//    func withPrefix(_ prefix: String) -> String {
//        if self.hasPrefix(prefix) {
//            return self
//        } else {
//            return prefix + self
//        }
//    }
//}
//input.withPrefix("car")

//MARK: Challenge 2
//let double = "2.5"
//
//extension String {
//    func isNumeric() -> Bool {
//        let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
//        if digits.contains(where: self.contains) {
//            return true
//        } else {
//            return false
//        }
//    }
//}
//double.isNumeric()

//MARK: Challenge 3
//let input = "this\nis\na\ntest"
//
//extension String {
//    func lines() -> [String] {
//        self.components(separatedBy: "\n")
//    }
//}
//input.lines()

