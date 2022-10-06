using HTTP
using Mustache
using URIs

function homePage(req::HTTP.Request)
    f = open("index.html", "r")
    d = Dict(
        "title" => "Hello World from Julia"
    )
    s = read(f, String)    
    body = Mustache.render(s, d)
    close(f)
    return HTTP.Response(200, body)
end

function staticFiles(req::HTTP.Request)
    url = req.target # URI(req.target)
    fname = replace(url, "/static/" => "")
    fpath = string("static/", fname)
    if !isfile(fpath)
        return HTTP.Response(404, "Not found")
    end 
    f = open(fpath, "r")
    body = read(f, String)    
    close(f)
    return HTTP.Response(200, body)    
end

function healthz(req::HTTP.Request)
    return HTTP.Response(200, "Healthy")
end


# define REST endpoints to dispatch to "service" functions
const ROUTER = HTTP.Router()
HTTP.register!(ROUTER, "GET", "/", homePage)
HTTP.register!(ROUTER, "GET", "/static/**", staticFiles)
HTTP.register!(ROUTER, "GET", "/healthz", healthz)

port = parse(Int64, get(ENV, "PORT", "8080"))
print(string("Using", " http://0.0.0.0:", port, "\n"))
server = HTTP.serve(ROUTER, "0.0.0.0", port)