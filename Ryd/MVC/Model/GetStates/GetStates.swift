// MARK: - GetStatesResponse
struct GetStatesResponse: Codable {
    let status: Bool?
    let states: [State]?
}

// MARK: - State
struct State: Codable {
    let id: Int?
    let name, stateCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case stateCode = "state_code"
    }
}

// MARK: - GetLaguagesResponse
struct GetLaguagesResponse: Codable {
    let status: Bool?
    let languages: [Language]?
}

// MARK: - Language
struct Language: Codable {
    let id: Int?
    let title, code: String?
}
