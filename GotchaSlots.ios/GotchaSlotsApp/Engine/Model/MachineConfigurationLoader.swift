import Foundation

enum MachineConfigurationLoader {
    enum LoadError: Error {
        case resourceNotFound(String)
    }

    static func load(named name: String, in bundle: Bundle = .main) throws -> MachineConfiguration {
        guard let url = bundle.url(forResource: name, withExtension: "json", subdirectory: "MachineConfigs")
            ?? bundle.url(forResource: name, withExtension: "json")
        else {
            throw LoadError.resourceNotFound(name)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(MachineConfiguration.self, from: data)
    }

    /// Direct decode from a Data blob — used by tests, which don't want to depend on how the
    /// resource is bundled.
    static func load(from data: Data) throws -> MachineConfiguration {
        try JSONDecoder().decode(MachineConfiguration.self, from: data)
    }
}
