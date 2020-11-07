const express = require("express");
const bodyParser = require("body-parser");
const router = express.Router();
const cors = require('cors');
const app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(cors());

app.get('/',(req, res) => {
  //res.sendfile("/html/templates/PruebaLab.html");
});


var parser = require('./gramatica');


app.post('/cargarArchivo',(req, res) => {
    console.log("Entro una peticion REST");
  var user_name=req.body.texto;
  var hola = parser.parse(user_name.toString());
  //console.log("Resultado del analisis");
  //console.log(JSON.stringify(hola));
  //console.log("User name = "+hola);
  res.end(JSON.stringify(hola));
});

app.listen(4000,() => {
  console.log("Started on PORT 4000");
});