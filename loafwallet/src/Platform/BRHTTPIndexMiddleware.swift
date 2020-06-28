import Foundation

// BRHTTPIndexMiddleware returns index.html to any GET requests - regardless of the URL being requestd
class BRHTTPIndexMiddleware: BRHTTPFileMiddleware {
    override func handle(_ request: BRHTTPRequest, next: @escaping (BRHTTPMiddlewareResponse) -> Void) {
        if request.method == "GET" {
            let newRequest = BRHTTPRequestImpl(fromRequest: request)
            newRequest.path = request.path.rtrim(["/"]) + "/index.html"
            super.handle(newRequest) { resp in
                if resp.response == nil {
                    let newRequest = BRHTTPRequestImpl(fromRequest: request)
                    newRequest.path = "/index.html"
                    super.handle(newRequest, next: next)
                } else {
                    next(resp)
                }
            }
        } else {
            next(BRHTTPMiddlewareResponse(request: request, response: nil))
        }
    }
}
