

struct LoginUserEntity: Codable {
    var member_id: String?
    var member_email: String?
    var member_pw: String?
    var member_code: Int = 0

    enum CodingKeys: String, CodingKey {
        case member_id = "member_id"
        case member_email = "member_email"
        case member_code = "member_code"
        case member_pw = "member_pw"
    }
}
