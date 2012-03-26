class Router
    constructor: (@routes = [], @e404 = 'not found', @e500 = 'internal server error') ->
    handle : (req, res) ->
        for route in @routes
            continue if req.method isnt route.method
            match = req.url.match route.regex
            continue if not match
            req.match = match
            try
                route.handler req, res
            catch e
                console.log e.message
                console.log e.stack
                res.writeHead 500,
                    'Content-Type':'text/html'
                    'Content-Length':@e500.length
                res.end @e500
            return
        res.writeHead 404,
            'Content-Type': 'text/html'
            'Content-Length':@e404.length
        res.end @e404
    add : (method, regex, handler) ->
        @routes.push
            method  : method
            regex   : regex
            handler : handler
    get     : (regex, handler) -> @add 'GET'    , regex, handler
    post    : (regex, handler) -> @add 'POST'   , regex, handler
    put     : (regex, handler) -> @add 'PUT'    , regex, handler
    delete  : (regex, handler) -> @add 'DELETE' , regex, handler
    head    : (regex, handler) -> @add 'HEAD'   , regex, handler
    trace   : (regex, handler) -> @add 'TRACE'  , regex, handler
    options : (regex, handler) -> @add 'OPTIONS', regex, handler
    connect : (regex, handler) -> @add 'CONNECT', regex, handler
    patch   : (regex, handler) -> @add 'PATCH'  , regex, handler

exports.Router = Router

exports.create = () -> new Router
