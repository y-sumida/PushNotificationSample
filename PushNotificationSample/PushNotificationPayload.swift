public struct PushNotificationPayload: Codable {
    // 以下のようなカスタムキーを持っているとする
    // {"aps" : {}, "custom": {"mode": 1,  "score": 100}}

    let mode: NotificationMode
    let score: Int?

    enum CodingKeys: String, CodingKey {
        case custom
        case mode
        case score
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .custom)
        mode = try nested.decode(NotificationMode.self, forKey: .mode)
        score = try nested.decodeIfPresent(Int.self, forKey: .score)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .custom)
        try nested.encode(mode, forKey: .mode)
        try nested.encodeIfPresent(score, forKey: .score)
    }

    enum NotificationMode: Int, Codable, Equatable {
        case mode1 = 1, mode2, mode3 // 実際にはちゃんと定義する
    }
}

