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


fs.readFile('./archivo.txt', (err, data) => {
    if (err) throw err;
    
});

app.post('/cargarArchivo',(req, res) => {
    console.log("Entro una peticion REST");
  var user_name=req.body.texto;
  parser.parse(data.toString());
  console.log("User name = "+respuesta.texto);
  res.end(JSON.stringify(respuesta));
});

app.listen(4000,() => {
  console.log("Started on PORT 4000");
});