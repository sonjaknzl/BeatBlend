import Foundation

public func trackInfo(forIndex index: Int) -> (String, String, String, String) {
    switch index {
    case 1:
        return ("The Bells", "VELDA", "126", "06:04")
    case 2:
        return ("Profondo", "VELDA", "126", "07:29")
    case 3:
        return ("Hazy Fields", "Twelve", "125", "05:37")
    default:
        return ("Unknown Track", "Unknown Artist", "BPM", "00:00") 
    }
}

