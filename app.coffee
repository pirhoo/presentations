###
Module dependencies.
###
express = require("express")
http    = require("http")
fs      = require("fs")
path    = require("path")
_       = require("underscore")
config  = require("config")

# Create the app
app     = express()

app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use require("less-middleware")(src: __dirname + "/public")
  app.use express.static(path.join(__dirname, "public"))
  # Custom local functions
  app.locals
    getThumbnail: (prez, w=680, h=480)->
      host     = process.env.HOST or config.host
      prez     = host + "/" + prez
      key      = process.env.BROWSHOT_KEY or config.browshot_key
      provider = "https://api.browshot.com/api/v1/simple"
      cache    = 60*60*24*60 # 60 days cache
      return "#{provider}?url=#{prez}&width=#{w}&height=#{h}&key=#{key}&cache=#{cache}"

# Error handler in development mode
app.configure "development", -> app.use express.errorHandler()

# Homepage endpoint
app.get "/", (req, res) ->
  prezs = fs.readdirSync(path.join(__dirname, "views", "prez") )
  prezs = _.map prezs, (p)-> p.split(".jade")[0]
  # Load the home
  res.render "home", prezs: prezs

# Presentation endpoint
app.get "/:controller", (req, res) -> res.render "prez/" + req.params.controller

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
