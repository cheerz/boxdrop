import Foundation

public extension UIFont {

    public enum FontType: String {
        case trueTypeFont = "ttf"
    }

    public static func getCustomFont(name: String, size: CGFloat, bundle: Bundle, type: FontType) -> UIFont? {
        registerFontWithFilenameString(filenameString: "\(name).\(type.rawValue)", bundle: bundle)
        return UIFont(name: name, size: size)
    }

    private static func registerFontWithFilenameString(filenameString: String, bundle: Bundle) {
        if let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil),
            let fontData = NSData(contentsOfFile: pathForResourceString),
            let dataProvider = CGDataProvider(data: fontData),
            let fontRef = CGFont(dataProvider) {
            var errorRef: Unmanaged<CFError>? = nil
            CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)
        }
    }
}
