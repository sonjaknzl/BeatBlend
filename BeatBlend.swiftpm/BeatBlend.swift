import SwiftUI

@main
struct BeatBlend: App {
    init() {
        setupDefaultFontFamily()
    }

    var body: some Scene {
        WindowGroup {
            ControllerView()
        }
    }
    private func setupDefaultFontFamily() { 
        let fontURL = Bundle.main.url(forResource: "AnalogueOS-Regular", withExtension: "ttf")

        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        let font = UIFont(name: "AnalogueOS-Regular", size: 30)!
        
        UILabel.appearance().font = font
    }
}




