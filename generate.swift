import Foundation

// Run using `swift generate.swift` for JSON output, or `swift generate.swift -t` for text output.

struct LanguageInfo: Codable {
    let name: String
    let symbol: String 
}

let isTextMode = CommandLine.arguments.last == "-t"

let outputLocale = NSLocale(localeIdentifier: "en_US")
// All lang infos keyed by display name, so we can sort output by display name
var langsByDisplayName: [String: LanguageInfo] = [:]
for localeCode in Locale.availableIdentifiers {
    if let displayName = outputLocale.displayName(forKey: NSLocale.Key.identifier, value: localeCode) {
        let langInfo = LanguageInfo(name: displayName, symbol: localeCode.replacingOccurrences(of: "_", with: "-"))
        langsByDisplayName[displayName] = langInfo
    }
}

// `availableIdentifiers` don't include all language codes (for example `ie` for Interlingue is missing)
// `isoLanguageCodes` includes the missing ones.
for langCode in Locale.isoLanguageCodes {
    if let displayName = outputLocale.displayName(forKey: NSLocale.Key.languageCode, value: langCode) {
        let langInfo = LanguageInfo(name: displayName, symbol: langCode)
        langsByDisplayName[displayName] = langInfo
    }
}

// Sort lang infos for output
var allLanguageInfos: [LanguageInfo] = []
for name in langsByDisplayName.keys.sorted() {
    if let langInfo = langsByDisplayName[name] {
        allLanguageInfos.append(langInfo)
    }
}


if isTextMode {
    // Output Text
    for langInfo in allLanguageInfos {
        puts("\(langInfo.name) (\(langInfo.symbol))")
    }
} else {
    // Output JSON
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
        let encodedData = try encoder.encode(allLanguageInfos)

        if let prettyJson = String(data: encodedData, encoding: .utf8) {
            print(prettyJson)
        }
    } catch {
        print("Error during JSON encoding: \(error.localizedDescription)")
        exit(-1)
    }
}

// Ensure we have no duplicate symbols
let allSymbols = Set(allLanguageInfos.map { $0.symbol })
if (allLanguageInfos.count != allSymbols.count) {
    print("WARNING: Symbols are not unique.")
}