//
//  Copyright (c) 2021 Open Whisper Systems. All rights reserved.
//

import Foundation

// MARK: - Color Helpers

@objc
public extension UIColor {

    @objc(colorWithRGBHex:)
    class func color(rgbHex: UInt) -> UIColor {
        return UIColor(rgbHex: rgbHex)
    }

    convenience init(rgbHex value: UInt) {
        let red = CGFloat(((value >> 16) & 0xff)) / 255.0
        let green = CGFloat(((value >> 8) & 0xff)) / 255.0
        let blue = CGFloat(((value >> 0) & 0xff)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    @objc(blendedWithColor:alpha:)
    func blended(with otherColor: UIColor, alpha alphaParam: CGFloat) -> UIColor {
        var r0: CGFloat = 0
        var g0: CGFloat = 0
        var b0: CGFloat = 0
        var a0: CGFloat = 0
        let result0 = self.getRed(&r0, green: &g0, blue: &b0, alpha: &a0)
        assert(result0)

        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        let result1 = otherColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        assert(result1)

        let alpha = CGFloatClamp01(alphaParam)
        return UIColor(red: CGFloatLerp(r0, r1, alpha),
                       green: CGFloatLerp(g0, g1, alpha),
                       blue: CGFloatLerp(b0, b1, alpha),
                       alpha: CGFloatLerp(a0, a1, alpha))

    }
}

// MARK: - Palette

@objc
public extension UIColor {

    // MARK: Brand Colors

    @objc(loopLightColor)
    class var loopLightColor: UIColor {
        return ows_white
    }

    @objc(loopDarkColor)
    class var loopDarkColor: UIColor {
        return ows_black
    }

    // MARK: Accent Colors

    /// Nav Bar, Primary Buttons
    @objc(ows_accentBlueColor)
    class var ows_accentBlue: UIColor {
        // Ultramarine UI
        return UIColor(rgbHex: 0x0666D6)
    }

    @objc(ows_accentBlueDarkColor)
    class var ows_accentBlueDark: UIColor {
        // Ultramarine UI Light
        return UIColor(rgbHex: 0x0666D6)
    }

    @objc(ows_accentBlueTintColor)
    class var ows_accentBlueTint: UIColor {
        return UIColor(rgbHex: 0x0666D6)
    }

    /// Making calls, success states
    @objc(ows_accentGreenColor)
    class var ows_accentGreen: UIColor {
        return UIColor(rgbHex: 0x4CAF50)
    }
    
    @objc(ows_accentGreenColorLight)
    class var ows_accentGreenLight: UIColor {
        return UIColor(rgbHex: 0x042228)
    }
    
    @objc(ows_accentGreenColorDark)
    class var ows_accentGreenDark: UIColor {
        return UIColor(rgbHex: 0x023D47)
    }

    /// Warning, update states
    @objc(ows_accentYellowColor)
    class var ows_accentYellow: UIColor {
        return UIColor(rgbHex: 0xF09A37)
    }

    /// Ending calls, error states
    @objc(ows_accentRedColor)
    class var ows_accentRed: UIColor {
        return UIColor(rgbHex: 0xFE3B30)
    }

    // MARK: - GreyScale

    @objc(ows_whiteColor)
    class var ows_white: UIColor {
        return UIColor(rgbHex: 0xFFFFFF)
    }

    @objc(ows_gray02Color)
    class var ows_gray02: UIColor {
        return UIColor(rgbHex: 0xF6F6F6)
    }

    @objc(ows_gray05Color)
    class var ows_gray05: UIColor {
        return UIColor(rgbHex: 0xE9E9E9)
    }

    @objc(ows_gray10Color)
    class var ows_gray10: UIColor {
        return UIColor(rgbHex: 0xf0f0f0)
    }

    @objc(ows_gray15Color)
    class var ows_gray15: UIColor {
        return UIColor(rgbHex: 0xD4D4D4)
    }

    @objc(ows_gray20Color)
    class var ows_gray20: UIColor {
        return UIColor(rgbHex: 0xCCCCCC)
    }

    @objc(ows_gray25Color)
    class var ows_gray25: UIColor {
        return UIColor(rgbHex: 0xB9B9B9)
    }

    @objc(ows_gray40Color)
    class var ows_gray40: UIColor {
        return UIColor(rgbHex: 0x999999)
    }

    @objc(ows_gray45Color)
    class var ows_gray45: UIColor {
        return UIColor(rgbHex: 0x848484)
    }

    @objc(ows_gray60Color)
    class var ows_gray60: UIColor {
        return UIColor(rgbHex: 0x5E5E5E)
    }

    @objc(ows_gray65Color)
    class var ows_gray65: UIColor {
        return UIColor(rgbHex: 0x4A4A4A)
    }

    @objc(ows_gray75Color)
    class var ows_gray75: UIColor {
        return UIColor(rgbHex: 0x3B3B3B)
    }

    @objc(ows_gray80Color)
    class var ows_gray80: UIColor {
        return UIColor(rgbHex: 0x2E2E2E)
    }

    @objc(ows_gray85Color)
    class var ows_gray85: UIColor {
        return UIColor(rgbHex: 0x23252A)
    }

    @objc(ows_gray90Color)
    class var ows_gray90: UIColor {
        return UIColor(rgbHex: 0x1B1B1B)
    }

    @objc(ows_gray95Color)
    class var ows_gray95: UIColor {
        return UIColor(rgbHex: 0x121212)
    }

    @objc(ows_blackColor)
    class var ows_black: UIColor {
        return UIColor(rgbHex: 0x000000)
    }

    // MARK: Masks

    @objc(ows_whiteAlpha00Color)
    class var ows_whiteAlpha00: UIColor {
        return UIColor(white: 1.0, alpha: 0)
    }

    @objc(ows_whiteAlpha20Color)
    class var ows_whiteAlpha20: UIColor {
        return UIColor(white: 1.0, alpha: 0.2)
    }

    @objc(ows_whiteAlpha25Color)
    class var ows_whiteAlpha25: UIColor {
        return UIColor(white: 1.0, alpha: 0.25)
    }

    @objc(ows_whiteAlpha30Color)
    class var ows_whiteAlpha30: UIColor {
        return UIColor(white: 1.0, alpha: 0.3)
    }

    @objc(ows_whiteAlpha40Color)
    class var ows_whiteAlpha40: UIColor {
        return UIColor(white: 1.0, alpha: 0.4)
    }

    @objc(ows_whiteAlpha50Color)
    class var ows_whiteAlpha50: UIColor {
        return UIColor(white: 1.0, alpha: 0.5)
    }
    
    @objc(ows_whiteAlpha60Color)
    class var ows_whiteAlpha60: UIColor {
        return UIColor(white: 1.0, alpha: 0.6)
    }
    
    @objc(ows_whiteAlpha75Color)
    class var ows_whiteAlpha75: UIColor {
        return UIColor(white: 1.0, alpha: 0.75)
    }

    @objc(ows_whiteAlpha80Color)
    class var ows_whiteAlpha80: UIColor {
        return UIColor(white: 1.0, alpha: 0.8)
    }

    @objc(ows_whiteAlpha90Color)
    class var ows_whiteAlpha90: UIColor {
        return UIColor(white: 1.0, alpha: 0.9)
    }

    @objc(ows_blackAlpha05Color)
    class var ows_blackAlpha05: UIColor {
        return UIColor(white: 0, alpha: 0.05)
    }

    @objc(ows_blackAlpha20Color)
    class var ows_blackAlpha20: UIColor {
        return UIColor(white: 0, alpha: 0.20)
    }

    @objc(ows_blackAlpha25Color)
    class var ows_blackAlpha25: UIColor {
        return UIColor(white: 0, alpha: 0.25)
    }

    @objc(ows_blackAlpha40Color)
    class var ows_blackAlpha40: UIColor {
        return UIColor(white: 0, alpha: 0.40)
    }

    @objc(ows_blackAlpha60Color)
    class var ows_blackAlpha60: UIColor {
        return UIColor(white: 0, alpha: 0.60)
    }

    @objc(ows_blackAlpha80Color)
    class var ows_blackAlpha80: UIColor {
        return UIColor(white: 0, alpha: 0.80)
    }

    // MARK: UI Colors

    // FIXME OFF-PALETTE
    @objc(ows_reminderYellowColor)
    class var ows_reminderYellow: UIColor {
        return UIColor(rgbHex: 0xFCF0D9)
    }

    // MARK: -

    class func ows_randomColor(isAlphaRandom: Bool) -> UIColor {
        func randomComponent() -> CGFloat {
            let precision: UInt32 = 255
            return CGFloat(arc4random_uniform(precision + 1)) / CGFloat(precision)
        }
        return UIColor(red: randomComponent(),
                       green: randomComponent(),
                       blue: randomComponent(),
                       alpha: isAlphaRandom ? randomComponent() : 1)
    }
    
    
    // MARK: - Grey

    @objc(ows_gray50)
    class var ows_gray50: UIColor {
        return UIColor(rgbHex: 0xFAFAFA)
    }

    @objc(ows_gray100)
    class var ows_gray100: UIColor {
        return UIColor(rgbHex: 0xF5F5F5)
    }
    
    @objc(ows_gray200)
    class var ows_gray200: UIColor {
        return UIColor(rgbHex: 0xEEEEEE)
    }
    
    @objc(ows_gray300)
    class var ows_gray300: UIColor {
        return UIColor(rgbHex: 0xC9C9C9)
    }
    
    @objc(ows_gray400)
    class var ows_gray400: UIColor {
        return UIColor(rgbHex: 0xA6A6A6)
    }
    
    @objc(ows_gray500)
    class var ows_gray500: UIColor {
        return UIColor(rgbHex: 0x878787)
    }
    
    @objc(ows_gray600)
    class var ows_gray600: UIColor {
        return UIColor(rgbHex: 0x5E5E5E)
    }
    
    @objc(ows_gray700)
    class var ows_gray700: UIColor {
        return UIColor(rgbHex: 0x4A4A4A)
    }
    
    @objc(ows_gray800)
    class var ows_gray800: UIColor {
        return UIColor(rgbHex: 0x2E2E2E)
    }
    
    @objc(ows_gray900)
    class var ows_gray900: UIColor {
        return UIColor(rgbHex: 0x212121)
    }
    
    // MARK: - RedRibbon

    @objc(ows_redRibbon50)
    class var ows_redRibbon50: UIColor {
        return UIColor(rgbHex: 0xFEE7EB)
    }

    @objc(ows_redRibbon100)
    class var ows_redRibbon100: UIColor {
        return UIColor(rgbHex: 0xFBCED6)
    }
    
    @objc(ows_redRibbon200)
    class var ows_redRibbon200: UIColor {
        return UIColor(rgbHex: 0xF89EAD)
    }
    
    @objc(ows_redRibbon300)
    class var ows_redRibbon300: UIColor {
        return UIColor(rgbHex: 0xF46D84)
    }
    
    @objc(ows_redRibbon400)
    class var ows_redRibbon400: UIColor {
        return UIColor(rgbHex: 0xF13D5B)
    }
    
    @objc(ows_redRibbon500)
    class var ows_redRibbon500: UIColor {
        return UIColor(rgbHex: 0xED0C32)
    }
    
    @objc(ows_redRibbon600)
    class var ows_redRibbon600: UIColor {
        return UIColor(rgbHex: 0xB20926)
    }
    
    @objc(ows_redRibbon700)
    class var ows_redRibbon700: UIColor {
        return UIColor(rgbHex: 0x770619)
    }
    
    @objc(ows_redRibbon800)
    class var ows_redRibbon800: UIColor {
        return UIColor(rgbHex: 0x3B030D)
    }
    
    @objc(ows_redRibbon900)
    class var ows_redRibbon900: UIColor {
        return UIColor(rgbHex: 0x180105)
    }
    
    // MARK: - Ecstasy

    @objc(ows_ecstasy50)
    class var ows_ecstasy50: UIColor {
        return UIColor(rgbHex: 0xFFF1E7)
    }

    @objc(ows_ecstasy100)
    class var ows_ecstasy100: UIColor {
        return UIColor(rgbHex: 0xFFE3CF)
    }
    
    @objc(ows_ecstasy200)
    class var ows_ecstasy200: UIColor {
        return UIColor(rgbHex: 0xFEC69E)
    }
    
    @objc(ows_ecstasy300)
    class var ows_ecstasy300: UIColor {
        return UIColor(rgbHex: 0xFEAA6E)
    }
    
    @objc(ows_ecstasy400)
    class var ows_ecstasy400: UIColor {
        return UIColor(rgbHex: 0xFD8D3D)
    }
    
    @objc(ows_ecstasy500)
    class var ows_ecstasy500: UIColor {
        return UIColor(rgbHex: 0xFD710D)
    }
    
    @objc(ows_ecstasy600)
    class var ows_ecstasy600: UIColor {
        return UIColor(rgbHex: 0xBE550A)
    }
    
    @objc(ows_ecstasy700)
    class var ows_ecstasy700: UIColor {
        return UIColor(rgbHex: 0x7F3907)
    }
    
    @objc(ows_ecstasy800)
    class var ows_ecstasy800: UIColor {
        return UIColor(rgbHex: 0x3F1C03)
    }
    
    @objc(ows_ecstasy900)
    class var ows_ecstasy900: UIColor {
        return UIColor(rgbHex: 0x190B01)
    }
    
    
    
    // MARK: - CobaltDark

    @objc(ows_cobaltDark50)
    class var ows_cobaltDark50: UIColor {
        return UIColor(rgbHex: 0xE6EFFD)
    }

    @objc(ows_cobaltDark100)
    class var ows_cobaltDark100: UIColor {
        return UIColor(rgbHex: 0xCCDEFA)
    }
    
    @objc(ows_cobaltDark200)
    class var ows_cobaltDark200: UIColor {
        return UIColor(rgbHex: 0x9ABDF5)
    }
    
    @objc(ows_cobaltDark300)
    class var ows_cobaltDark300: UIColor {
        return UIColor(rgbHex: 0x679BEF)
    }
    
    @objc(ows_cobaltDark400)
    class var ows_cobaltDark400: UIColor {
        return UIColor(rgbHex: 0x357AEA)
    }
    
    @objc(ows_cobaltDark500)
    class var ows_cobaltDark500: UIColor {
        return UIColor(rgbHex: 0x0D69FD)
    }
    
    @objc(ows_cobaltDark600)
    class var ows_cobaltDark600: UIColor {
        return UIColor(rgbHex: 0x0243AC)
    }
    
    @objc(ows_cobaltDark700)
    class var ows_cobaltDark700: UIColor {
        return UIColor(rgbHex: 0x012D73)
    }
    
    @objc(ows_cobaltDark800)
    class var ows_cobaltDark800: UIColor {
        return UIColor(rgbHex: 0x011639)
    }
    
    @objc(ows_cobaltDark900)
    class var ows_cobaltDark900: UIColor {
        return UIColor(rgbHex: 0x000917)
    }
    
    // MARK: - CobaltLight

    @objc(ows_cobaltLight50)
    class var ows_cobaltLight50: UIColor {
        return UIColor(rgbHex: 0xE6EDF9)
    }

    @objc(ows_cobaltLight100)
    class var ows_cobaltLight100: UIColor {
        return UIColor(rgbHex: 0xCCDBF2)
    }
    
    @objc(ows_cobaltLight200)
    class var ows_cobaltLight200: UIColor {
        return UIColor(rgbHex: 0x9AB7E5)
    }
    
    @objc(ows_cobaltLight300)
    class var ows_cobaltLight300: UIColor {
        return UIColor(rgbHex: 0x6792D8)
    }
    
    @objc(ows_cobaltLight400)
    class var ows_cobaltLight400: UIColor {
        return UIColor(rgbHex: 0x356ECB)
    }
    
    @objc(ows_cobaltLight500)
    class var ows_cobaltLight500: UIColor {
        return UIColor(rgbHex: 0x024ABE)
    }
    
    @objc(ows_cobaltLight600)
    class var ows_cobaltLight600: UIColor {
        return UIColor(rgbHex: 0x02388F)
    }
    
    @objc(ows_cobaltLight700)
    class var ows_cobaltLight700: UIColor {
        return UIColor(rgbHex: 0x01255F)
    }
    
    @objc(ows_cobaltLight800)
    class var ows_cobaltLight800: UIColor {
        return UIColor(rgbHex: 0x011330)
    }
    
    @objc(ows_cobaltLight900)
    class var ows_cobaltLight900: UIColor {
        return UIColor(rgbHex: 0x000713)
    }
    
    // MARK: - BlueChillDark

    @objc(ows_blueChillDark50)
    class var ows_blueChillDark50: UIColor {
        return UIColor(rgbHex: 0xE8F7FA)
    }

    @objc(ows_blueChillDark100)
    class var ows_blueChillDark100: UIColor {
        return UIColor(rgbHex: 0xD0EDF3)
    }
    
    @objc(ows_blueChillDark200)
    class var ows_blueChillDark200: UIColor {
        return UIColor(rgbHex: 0xA0DBE7)
    }
    
    @objc(ows_blueChillDark300)
    class var ows_blueChillDark300: UIColor {
        return UIColor(rgbHex: 0x71CADC)
    }
    
    @objc(ows_blueChillDark400)
    class var ows_blueChillDark400: UIColor {
        return UIColor(rgbHex: 0x41B8D0)
    }
    
    @objc(ows_blueChillDark500)
    class var ows_blueChillDark500: UIColor {
        return UIColor(rgbHex: 0x12A6C4)
    }
    
    @objc(ows_blueChillDark600)
    class var ows_blueChillDark600: UIColor {
        return UIColor(rgbHex: 0x0E7D93)
    }
    
    @objc(ows_blueChillDark700)
    class var ows_blueChillDark700: UIColor {
        return UIColor(rgbHex: 0x095362)
    }
    
    @objc(ows_blueChillDark800)
    class var ows_blueChillDark800: UIColor {
        return UIColor(rgbHex: 0x052A31)
    }
    
    @objc(ows_blueChillDark900)
    class var ows_blueChillDark900: UIColor {
        return UIColor(rgbHex: 0x021114)
    }
    
    // MARK: - BlueChillLight
    
    @objc(ows_blueChillLight500)
    class var ows_blueChillLight500: UIColor {
        return UIColor(rgbHex: 0x0E88A0)
    }
    
    @objc(ows_blueChillLight600)
    class var ows_blueChillLight600: UIColor {
        return UIColor(rgbHex: 0x0B6678)
    }
    
    @objc(ows_blueChillLight800)
    class var ows_blueChillLight800: UIColor {
        return UIColor(rgbHex: 0x042228)
    }
    
    // MARK: - AzureRadianceDark

    @objc(ows_azureRadianceDark50)
    class var ows_azureRadianceDark50: UIColor {
        return UIColor(rgbHex: 0xE6F5FF)
    }

    @objc(ows_azureRadianceDark100)
    class var ows_azureRadianceDark100: UIColor {
        return UIColor(rgbHex: 0xCCEAFF)
    }
    
    @objc(ows_azureRadianceDark200)
    class var ows_azureRadianceDark200: UIColor {
        return UIColor(rgbHex: 0x99D5FF)
    }
    
    @objc(ows_azureRadianceDark300)
    class var ows_azureRadianceDark300: UIColor {
        return UIColor(rgbHex: 0x66C0FF)
    }
    
    @objc(ows_azureRadianceDark400)
    class var ows_azureRadianceDark400: UIColor {
        return UIColor(rgbHex: 0x33ABFF)
    }
    
    @objc(ows_azureRadianceDark500)
    class var ows_azureRadianceDark500: UIColor {
        return UIColor(rgbHex: 0x0096FF)
    }
    
    @objc(ows_azureRadianceDark600)
    class var ows_azureRadianceDark600: UIColor {
        return UIColor(rgbHex: 0x0071BF)
    }
    
    @objc(ows_azureRadianceDark700)
    class var ows_azureRadianceDark700: UIColor {
        return UIColor(rgbHex: 0x004B80)
    }
    
    @objc(ows_azureRadianceDark800)
    class var ows_azureRadianceDark800: UIColor {
        return UIColor(rgbHex: 0x002640)
    }
    
    @objc(ows_azureRadianceDark900)
    class var ows_azureRadianceDark900: UIColor {
        return UIColor(rgbHex: 0x000F1A)
    }
    
    // MARK: - AzureRadianceLight

    @objc(ows_azureRadianceLight50)
    class var ows_azureRadianceLight50: UIColor {
        return UIColor(rgbHex: 0xE6F3FC)
    }

    @objc(ows_azureRadianceLight100)
    class var ows_azureRadianceLight100: UIColor {
        return UIColor(rgbHex: 0xCCE6F7)
    }
    
    @objc(ows_azureRadianceLight200)
    class var ows_azureRadianceLight200: UIColor {
        return UIColor(rgbHex: 0x99CCF0)
    }
    
    @objc(ows_azureRadianceLight300)
    class var ows_azureRadianceLight300: UIColor {
        return UIColor(rgbHex: 0x66B3E8)
    }
    
    @objc(ows_azureRadianceLight400)
    class var ows_azureRadianceLight400: UIColor {
        return UIColor(rgbHex: 0x3399E1)
    }
    
    @objc(ows_azureRadianceLight500)
    class var ows_azureRadianceLight500: UIColor {
        return UIColor(rgbHex: 0x0080D9)
    }
    
    @objc(ows_azureRadianceLight600)
    class var ows_azureRadianceLight600: UIColor {
        return UIColor(rgbHex: 0x0060A3)
    }
    
    @objc(ows_azureRadianceLight700)
    class var ows_azureRadianceLight700: UIColor {
        return UIColor(rgbHex: 0x00406D)
    }
    
    @objc(ows_azureRadianceLight800)
    class var ows_azureRadianceLight800: UIColor {
        return UIColor(rgbHex: 0x002036)
    }
    
    @objc(ows_azureRadianceLight900)
    class var ows_azureRadianceLight900: UIColor {
        return UIColor(rgbHex: 0x000D16)
    }
    
    // MARK: - BlueGrey

    @objc(ows_blueGrey50)
    class var ows_blueGrey50: UIColor {
        return UIColor(rgbHex: 0xF5F8FA)
    }

    @objc(ows_blueGrey100)
    class var ows_blueGrey100: UIColor {
        return UIColor(rgbHex: 0xCFD8DC)
    }
    
    @objc(ows_blueGrey200)
    class var ows_blueGrey200: UIColor {
        return UIColor(rgbHex: 0xB0BEC5)
    }
    
    @objc(ows_blueGrey300)
    class var ows_blueGrey300: UIColor {
        return UIColor(rgbHex: 0x90A4AE)
    }
    
    @objc(ows_blueGrey400)
    class var ows_blueGrey400: UIColor {
        return UIColor(rgbHex: 0x78909C)
    }
    
    @objc(ows_blueGrey500)
    class var ows_blueGrey500: UIColor {
        return UIColor(rgbHex: 0x607D8B)
    }
    
    @objc(ows_blueGrey600)
    class var ows_blueGrey600: UIColor {
        return UIColor(rgbHex: 0x546E7A)
    }
    
    @objc(ows_blueGrey700)
    class var ows_blueGrey700: UIColor {
        return UIColor(rgbHex: 0x455A64)
    }
    
    @objc(ows_blueGrey800)
    class var ows_blueGrey800: UIColor {
        return UIColor(rgbHex: 0x37474F)
    }
    
    @objc(ows_blueGrey900)
    class var ows_blueGrey900: UIColor {
        return UIColor(rgbHex: 0x263238)
    }
    
    // MARK: - LipstickDark

    @objc(ows_lipstickDark50)
    class var ows_lipstickDark50: UIColor {
        return UIColor(rgbHex: 0xFCE7F0)
    }

    @objc(ows_lipstickDark100)
    class var ows_lipstickDark100: UIColor {
        return UIColor(rgbHex: 0xF9CEDF)
    }
    
    @objc(ows_lipstickDark200)
    class var ows_lipstickDark200: UIColor {
        return UIColor(rgbHex: 0xF39DBF)
    }
    
    @objc(ows_lipstickDark300)
    class var ows_lipstickDark300: UIColor {
        return UIColor(rgbHex: 0xEC6B9F)
    }
    
    @objc(ows_lipstickDark400)
    class var ows_lipstickDark400: UIColor {
        return UIColor(rgbHex: 0xE63A7F)
    }
    
    @objc(ows_lipstickDark500)
    class var ows_lipstickDark500: UIColor {
        return UIColor(rgbHex: 0xE0095F)
    }
    
    @objc(ows_lipstickDark600)
    class var ows_lipstickDark600: UIColor {
        return UIColor(rgbHex: 0xA80747)
    }
    
    @objc(ows_lipstickDark700)
    class var ows_lipstickDark700: UIColor {
        return UIColor(rgbHex: 0x700530)
    }
    
    @objc(ows_lipstickDark800)
    class var ows_lipstickDark800: UIColor {
        return UIColor(rgbHex: 0x380218)
    }
    
    @objc(ows_lipstickDark900)
    class var ows_lipstickDark900: UIColor {
        return UIColor(rgbHex: 0x16010A)
    }
    
    // MARK: - LipstickLight

    @objc(ows_lipstickLight50)
    class var ows_lipstickLight50: UIColor {
        return UIColor(rgbHex: 0xF9E7EE)
    }

    @objc(ows_lipstickLight100)
    class var ows_lipstickLight100: UIColor {
        return UIColor(rgbHex: 0xF1CEDC)
    }
    
    @objc(ows_lipstickLight200)
    class var ows_lipstickLight200: UIColor {
        return UIColor(rgbHex: 0xE49CB9)
    }
    
    @objc(ows_lipstickLight300)
    class var ows_lipstickLight300: UIColor {
        return UIColor(rgbHex: 0xD66B95)
    }
    
    @objc(ows_lipstickLight400)
    class var ows_lipstickLight400: UIColor {
        return UIColor(rgbHex: 0xC93972)
    }
    
    @objc(ows_lipstickLight500)
    class var ows_lipstickLight500: UIColor {
        return UIColor(rgbHex: 0xBB084F)
    }
    
    @objc(ows_lipstickLight600)
    class var ows_lipstickLight600: UIColor {
        return UIColor(rgbHex: 0x8C063B)
    }
    
    @objc(ows_lipstickLight700)
    class var ows_lipstickLight700: UIColor {
        return UIColor(rgbHex: 0x5E0428)
    }
    
    @objc(ows_lipstickLight800)
    class var ows_lipstickLight800: UIColor {
        return UIColor(rgbHex: 0x2F0214)
    }
    
    @objc(ows_lipstickLight900)
    class var ows_lipstickLight900: UIColor {
        return UIColor(rgbHex: 0x130108)
    }
    
    // MARK: - PersianGreenDark

    @objc(ows_persianGreenDark50)
    class var ows_persianGreenDark50: UIColor {
        return UIColor(rgbHex: 0xE6F8F6)
    }

    @objc(ows_persianGreenDark100)
    class var ows_persianGreenDark100: UIColor {
        return UIColor(rgbHex: 0xCCEFEB)
    }
    
    @objc(ows_persianGreenDark200)
    class var ows_persianGreenDark200: UIColor {
        return UIColor(rgbHex: 0x99DFD7)
    }
    
    @objc(ows_persianGreenDark300)
    class var ows_persianGreenDark300: UIColor {
        return UIColor(rgbHex: 0x66D0C4)
    }
    
    @objc(ows_persianGreenDark400)
    class var ows_persianGreenDark400: UIColor {
        return UIColor(rgbHex: 0x33C0B0)
    }
    
    @objc(ows_persianGreenDark500)
    class var ows_persianGreenDark500: UIColor {
        return UIColor(rgbHex: 0x00B09C)
    }
    
    @objc(ows_persianGreenDark600)
    class var ows_persianGreenDark600: UIColor {
        return UIColor(rgbHex: 0x008475)
    }
    
    @objc(ows_persianGreenDark700)
    class var ows_persianGreenDark700: UIColor {
        return UIColor(rgbHex: 0x00584E)
    }
    
    @objc(ows_persianGreenDark800)
    class var ows_persianGreenDark800: UIColor {
        return UIColor(rgbHex: 0x002C27)
    }
    
    @objc(ows_persianGreenDark900)
    class var ows_persianGreenDark900: UIColor {
        return UIColor(rgbHex: 0x001210)
    }
    
    // MARK: - PersianGreenLight
    
    @objc(ows_persianGreenLight500)
    class var ows_persianGreenLight500: UIColor {
        return UIColor(rgbHex: 0x008A7A)
    }
    
    // MARK: - ScienceBlueDark

    @objc(ows_scienceBlueDark50)
    class var ows_scienceBlueDark50: UIColor {
        return UIColor(rgbHex: 0xE7F2FF)
    }

    @objc(ows_scienceBlueDark100)
    class var ows_scienceBlueDark100: UIColor {
        return UIColor(rgbHex: 0xCDE4FE)
    }
    
    @objc(ows_scienceBlueDark200)
    class var ows_scienceBlueDark200: UIColor {
        return UIColor(rgbHex: 0x9CC9FD)
    }
    
    @objc(ows_scienceBlueDark300)
    class var ows_scienceBlueDark300: UIColor {
        return UIColor(rgbHex: 0x6AADFC)
    }
    
    @objc(ows_scienceBlueDark400)
    class var ows_scienceBlueDark400: UIColor {
        return UIColor(rgbHex: 0x3992FB)
    }
    
    @objc(ows_scienceBlueDark500)
    class var ows_scienceBlueDark500: UIColor {
        return UIColor(rgbHex: 0x0777FA)
    }
    
    @objc(ows_scienceBlueDark600)
    class var ows_scienceBlueDark600: UIColor {
        return UIColor(rgbHex: 0x0559BC)
    }
    
    @objc(ows_scienceBlueDark700)
    class var ows_scienceBlueDark700: UIColor {
        return UIColor(rgbHex: 0x043C7D)
    }
    
    @objc(ows_scienceBlueDark800)
    class var ows_scienceBlueDark800: UIColor {
        return UIColor(rgbHex: 0x021E3F)
    }
    
    @objc(ows_scienceBlueDark900)
    class var ows_scienceBlueDark900: UIColor {
        return UIColor(rgbHex: 0x010C19)
    }
    
    // MARK: - ScienceBlueLight

    @objc(ows_scienceBlueLight50)
    class var ows_scienceBlueLight50: UIColor {
        return UIColor(rgbHex: 0xE7F0FB)
    }

    @objc(ows_scienceBlueLight100)
    class var ows_scienceBlueLight100: UIColor {
        return UIColor(rgbHex: 0xCDE0F7)
    }
    
    @objc(ows_scienceBlueLight200)
    class var ows_scienceBlueLight200: UIColor {
        return UIColor(rgbHex: 0x9BC2EF)
    }
    
    @objc(ows_scienceBlueLight300)
    class var ows_scienceBlueLight300: UIColor {
        return UIColor(rgbHex: 0x6AA3E6)
    }
    
    @objc(ows_scienceBlueLight400)
    class var ows_scienceBlueLight400: UIColor {
        return UIColor(rgbHex: 0x3885DE)
    }
    
    @objc(ows_scienceBlueLight500)
    class var ows_scienceBlueLight500: UIColor {
        return UIColor(rgbHex: 0x0666D6)
    }
    
    @objc(ows_scienceBlueLight600)
    class var ows_scienceBlueLight600: UIColor {
        return UIColor(rgbHex: 0x054DA1)
    }
    
    @objc(ows_scienceBlueLight700)
    class var ows_scienceBlueLight700: UIColor {
        return UIColor(rgbHex: 0x03336B)
    }
    
    @objc(ows_scienceBlueLight800)
    class var ows_scienceBlueLight800: UIColor {
        return UIColor(rgbHex: 0x021A36)
    }
    
    @objc(ows_scienceBlueLight900)
    class var ows_scienceBlueLight900: UIColor {
        return UIColor(rgbHex: 0x010A15)
    }
    
    // MARK: - SupernovaDark

    @objc(ows_supernovaDark50)
    class var ows_supernovaDark50: UIColor {
        return UIColor(rgbHex: 0xFFFAE7)
    }

    @objc(ows_supernovaDark100)
    class var ows_supernovaDark100: UIColor {
        return UIColor(rgbHex: 0xFEF3CE)
    }
    
    @objc(ows_supernovaDark200)
    class var ows_supernovaDark200: UIColor {
        return UIColor(rgbHex: 0xFDE89D)
    }
    
    @objc(ows_supernovaDark300)
    class var ows_supernovaDark300: UIColor {
        return UIColor(rgbHex: 0xFBDC6D)
    }
    
    @objc(ows_supernovaDark400)
    class var ows_supernovaDark400: UIColor {
        return UIColor(rgbHex: 0xFAD13C)
    }
    
    @objc(ows_supernovaDark500)
    class var ows_supernovaDark500: UIColor {
        return UIColor(rgbHex: 0xF9C50B)
    }
    
    @objc(ows_supernovaDark600)
    class var ows_supernovaDark600: UIColor {
        return UIColor(rgbHex: 0xBB9408)
    }
    
    @objc(ows_supernovaDark700)
    class var ows_supernovaDark700: UIColor {
        return UIColor(rgbHex: 0x7D6306)
    }
    
    @objc(ows_supernovaDark800)
    class var ows_supernovaDark800: UIColor {
        return UIColor(rgbHex: 0x3E3103)
    }
    
    @objc(ows_supernovaDark900)
    class var ows_supernovaDark900: UIColor {
        return UIColor(rgbHex: 0x191401)
    }
    
    // MARK: - SupernovaLight

    @objc(ows_supernovaLight50)
    class var ows_supernovaLight50: UIColor {
        return UIColor(rgbHex: 0xFEF9E7)
    }
    
    @objc(ows_supernovaLight500)
    class var ows_supernovaLight500: UIColor {
        return UIColor(rgbHex: 0xEFBD0B)
    }
    
    @objc(ows_supernovaLight800)
    class var ows_supernovaLight800: UIColor {
        return UIColor(rgbHex: 0x3C2F03)
    }
    
    // MARK: - Malachite

    @objc(ows_malachite50)
    class var ows_malachite50: UIColor {
        return UIColor(rgbHex: 0xE8FDF0)
    }

    @objc(ows_malachite100)
    class var ows_malachite100: UIColor {
        return UIColor(rgbHex: 0xD0F9E0)
    }
    
    @objc(ows_malachite200)
    class var ows_malachite200: UIColor {
        return UIColor(rgbHex: 0xA0F3C2)
    }
    
    @objc(ows_malachite300)
    class var ows_malachite300: UIColor {
        return UIColor(rgbHex: 0x71EEA3)
    }
    
    @objc(ows_malachite400)
    class var ows_malachite400: UIColor {
        return UIColor(rgbHex: 0x41E885)
    }
    
    @objc(ows_malachite500)
    class var ows_malachite500: UIColor {
        return UIColor(rgbHex: 0x12E266)
    }
    
    @objc(ows_malachite600)
    class var ows_malachite600: UIColor {
        return UIColor(rgbHex: 0x0EAA4D)
    }
    
    @objc(ows_malachite700)
    class var ows_malachite700: UIColor {
        return UIColor(rgbHex: 0x097133)
    }
    
    @objc(ows_malachite800)
    class var ows_malachite800: UIColor {
        return UIColor(rgbHex: 0x05391A)
    }
    
    @objc(ows_malachite900)
    class var ows_malachite900: UIColor {
        return UIColor(rgbHex: 0x02170A)
    }
    
    // MARK: - Turquoise

    @objc(ows_turquoise50)
    class var ows_turquoise50: UIColor {
        return UIColor(rgbHex: 0xE8FEFE)
    }

    @objc(ows_turquoise100)
    class var ows_turquoise100: UIColor {
        return UIColor(rgbHex: 0xCFFBFC)
    }
    
    @objc(ows_turquoise200)
    class var ows_turquoise200: UIColor {
        return UIColor(rgbHex: 0xA0F7F8)
    }
    
    @objc(ows_turquoise300)
    class var ows_turquoise300: UIColor {
        return UIColor(rgbHex: 0x70F3F5)
    }
    
    @objc(ows_turquoise400)
    class var ows_turquoise400: UIColor {
        return UIColor(rgbHex: 0x41EFF1)
    }
    
    @objc(ows_turquoise500)
    class var ows_turquoise500: UIColor {
        return UIColor(rgbHex: 0x11EBEE)
    }
    
    @objc(ows_turquoise600)
    class var ows_turquoise600: UIColor {
        return UIColor(rgbHex: 0x0DB0B3)
    }
    
    @objc(ows_turquoise700)
    class var ows_turquoise700: UIColor {
        return UIColor(rgbHex: 0x097677)
    }
    
    @objc(ows_turquoise800)
    class var ows_turquoise800: UIColor {
        return UIColor(rgbHex: 0x043B3C)
    }
    
    @objc(ows_turquoise900)
    class var ows_turquoise900: UIColor {
        return UIColor(rgbHex: 0x021818)
    }
    
    // MARK: - ElectricViolet

    @objc(ows_electricViolet50)
    class var ows_electricViolet50: UIColor {
        return UIColor(rgbHex: 0xF7ECFF)
    }

    @objc(ows_electricViolet100)
    class var ows_electricViolet100: UIColor {
        return UIColor(rgbHex: 0xEDD8FD)
    }
    
    @objc(ows_electricViolet200)
    class var ows_electricViolet200: UIColor {
        return UIColor(rgbHex: 0xDBB1FB)
    }
    
    @objc(ows_electricViolet300)
    class var ows_electricViolet300: UIColor {
        return UIColor(rgbHex: 0xC98BF9)
    }
    
    @objc(ows_electricViolet400)
    class var ows_electricViolet400: UIColor {
        return UIColor(rgbHex: 0xB764F7)
    }
    
    @objc(ows_electricViolet500)
    class var ows_electricViolet500: UIColor {
        return UIColor(rgbHex: 0xA53DF5)
    }
    
    @objc(ows_electricViolet600)
    class var ows_electricViolet600: UIColor {
        return UIColor(rgbHex: 0x7C2EB8)
    }
    
    @objc(ows_electricViolet700)
    class var ows_electricViolet700: UIColor {
        return UIColor(rgbHex: 0x531F7B)
    }
    
    @objc(ows_electricViolet800)
    class var ows_electricViolet800: UIColor {
        return UIColor(rgbHex: 0x290F3D)
    }
    
    @objc(ows_electricViolet900)
    class var ows_electricViolet900: UIColor {
        return UIColor(rgbHex: 0x110619)
    }
    
    // MARK: - ShockingPink

    @objc(ows_shockingPink50)
    class var ows_shockingPink50: UIColor {
        return UIColor(rgbHex: 0xFFE9FA)
    }

    @objc(ows_shockingPink100)
    class var ows_shockingPink100: UIColor {
        return UIColor(rgbHex: 0xFED2F4)
    }
    
    @objc(ows_shockingPink200)
    class var ows_shockingPink200: UIColor {
        return UIColor(rgbHex: 0xFCA6E8)
    }
    
    @objc(ows_shockingPink300)
    class var ows_shockingPink300: UIColor {
        return UIColor(rgbHex: 0xFB79DD)
    }
    
    @objc(ows_shockingPink400)
    class var ows_shockingPink400: UIColor {
        return UIColor(rgbHex: 0xF94DD1)
    }
    
    @objc(ows_shockingPink500)
    class var ows_shockingPink500: UIColor {
        return UIColor(rgbHex: 0xF820C6)
    }
    
    @objc(ows_shockingPink600)
    class var ows_shockingPink600: UIColor {
        return UIColor(rgbHex: 0xBA1895)
    }
    
    @objc(ows_shockingPink700)
    class var ows_shockingPink700: UIColor {
        return UIColor(rgbHex: 0x7C1063)
    }
    
    @objc(ows_shockingPink800)
    class var ows_shockingPink800: UIColor {
        return UIColor(rgbHex: 0x3E0832)
    }
    
    @objc(ows_shockingPink900)
    class var ows_shockingPink900: UIColor {
        return UIColor(rgbHex: 0x190314)
    }
    
    // MARK: - Feedback
    
    @objc(ows_error)
    class var ows_error: UIColor {
        return UIColor(rgbHex: 0xEE0004)
    }
}
