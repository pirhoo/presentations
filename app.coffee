###
Module dependencies.
###
express = require("express")
http    = require("http")
fs      = require("fs")
path    = require("path")

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

# Error handler in development mode
app.configure "development", -> app.use express.errorHandler()

# Presentation endpoint
app.get "/:controller", (req, res) -> res.render "prez/" + req.params.controller

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
